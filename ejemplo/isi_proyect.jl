using JuMP, Gurobi, LinearAlgebra
using CSV
using DataFrames

#modelo
Mo= Model(Gurobi.Optimizer)
#parametros
################### DEMANDA & GENERACIÓN NORMAL #########
demand = CSV.read("Demand.csv", DataFrame)
energy_re = CSV.read("Renewable_Energy.csv", DataFrame)
hours = 8760
D = demand[:,2]'# perfil de demanda horaria
E_neta_fv =  energy_re[:,2]'
########################################

r=0.12 #tasa de descuento
DOD=50/100 #deuda de descarga (% descarga máxima)
CY=1200 # ciclos máximos de vida para la batería
U_fv=1.7 #costo célula FV en USD/W
U_ge=1.48 #costo grupo electrógeno de diésel en USD/W
U_fuel=0.68 # costo diesel en USD/l
U_bat=0.44 #costo batería en USD/Wh
U_elec=0.22   #costo de la electrónica de protección de la batería en USD/Wh
U_rep= (U_bat - U_elec)/(2*CY*(1-DOD)) # costo reemplazo de una unidad de batería en USD/Wh
U_LL=0.003 #costo de la carga perdida en el sistema en USD/Wh
delta_t=1   # bloque de tiempo= 1hora
delta_t_dis=4 #tiempo de descarga
delta_t_ch=4 #tiempo de carga
effi_dis= 0.95/100 # eficiencia de descarga de la batería
effi_ch= 0.95/100 # eficiencia de carga de la batería
effi_fv=30/100 # efficiencia unidad FV
effi_ge=31.4/100 # efficiencia grupo electrogeno de diesel
I_cost = 1.5/100 # Icost , % del costo del combustible a carga nominal, reemplaza la efiiencia constante del gen de diesel
I_mant= 1.5/100 # porcentaje del costo total de la inversión usado cada año en mantenimiento
I_ge=50/100 # % mínimo de entrega de energía por el gen. de diesel
I_fv= 5/100#porcentaje ERNC
C_fv=250 # Capacidad unidad FV en W
C_ge=58000 # capacidad generador en W

LHV=9890 # minimo valor de calentado del diesel Wh/l
b_LP= U_ge/(effi_ge*LHV)  #costo unitario de una unidad de diesel
#periodos
T=1:8760#horas del día
#variables
@variable(Mo, N_fv, Int)
@variable(Mo, N_ge, Int)
@variable(Mo, N_bat, Int)
@variable(Mo, N_ge_working[T], Int)
@variable(Mo, E_bat_ch[T] >=0)
@variable(Mo, E_bat_dis[T] >=0)
@variable(Mo, E_fv[T]>=0)
@variable(Mo, E_ge[T]>=0)
@variable(Mo, E_LL[T]>=0)
@variable(Mo, Inv>=0)
@variable(Mo, Co_mant>=0)
@variable(Mo, Co_ge>=0)
@variable(Mo, Co_rep>=0)
@variable(Mo, Co_LL>=0)
@variable(Mo, CO_VAR>=0)
@variable(Mo, SOC[T])
#F.O
@objective(Mo, Min, Inv + sum(YC/((1 + r)^y) for y in 1:20))

#ecuaciones F.O
@constraint(Mo, Inv == U_fv*N_fv*C_fv + U_bat*N_bat*C_bat + U_ge*N_ge*C_ge)
@constraint(Mo, CO_VAR == Co_mant + Co_ge + Co_rep + Co_LL)
@constraint(Mo, Co_mant == Inv*I_mant)
@constraint(Mo, Co_rep == sum(U_rep*(E_bat_dis[t]+E_bat_ch[t]) for t in T))
@constraint(Mo, Co_LL == sum(E_LL[t]*U_LL for t in T))
@constraint(Mo, Co_ge == sum(b_LP*(N_ge_working[t]*C_ge*I_cost + (1-I_cost)*E_ge[t]) for t in T))

#restriccion FV
for t in T
    @constraint(Mo, E_fv[t]== effi_fv*E_neta_fv[t]*N_fv)
    @constraint(Mo, E_fv[t]<= C_fv*N_fv)
end

#restriccion batería
for i in 1:8759
    @constraint(Mo, SOC[i+1] == SOC[i] + E_bat_ch[i]*effi_ch - (E_bat_dis[i]/effi_ch))
    @constraint(Mo, SOC[i] <=C_bat*N_bat)
    @constraint(Mo, SOC[i] >=C_bat*N_bat*DOD)
end

for t in T
    #restriccion batería
    @constraint(Mo, E_bat_ch[t] <= N_bat*C_bat*delta_t/delta_t_ch)
    @constraint(Mo, E_bat_dis[t] <= N_bat*C_bat*delta_t/delta_t_dis)
    #restriccion diésel MILP
    @constraint(Mo, C_ge*I_ge + C_ge*(N_ge_working[t]-1) <= E_ge[t])
    @constraint(Mo, E_ge[t]<= C_ge*N_ge)
    @constraint(Mo, E_ge[t]<= C_ge*N_ge_working[t])
    #restricciones de energía
    @constraint(Mo, D[t] <= E_fv[t] - E_bat_ch[t] + E_bat_dis[t] + E_ge[t] + E_LL[t]) # cumplir la demanda
    #restriccion % ERNC
    @constraint(Mo, E_fv[t]*(1-I_fv) >= E_ge[t]*I_fv)
end
#restriccion
LLP=0.1 # nivel de pérdidas de energía permitida
@constraint(Mo, (sum(E_LL[t] for t in T)/sum(D[t] for t in T)) <=LLP)

#restriccion 1 día de autonomía por la batería
D_indp=0 # n° de días de independencia de la batería
@constraint(Mo, N_bat*C_bat >= (sum(D[t] for t in T)/365)*(D_indp/(1-DOD)))

#optimizar
JuMP.optimize!(Mo)
#imprimir resultados
println("Resultados")
println("Inv:", JuMP.value(Inv))
println("N_bat:", JuMP.value(N_bat))
println("N_fv:", JuMP.value(N_fv))
println("N_ge:", JuMP.value(N_ge))
#println("E_bat_ch:", JuMP.value(E_bat_ch[24]))
#println("E_bat_dis:", JuMP.value(E_bat_dis[24]))
#println("E_fv:", JuMP.value(E_fv[24]))
#println("E_ge:", JuMP.value(E_ge[24]))
#println("E_LL:", JuMP.value(E_LL[24]))
println("Costo total:", objective_value(Mo))
