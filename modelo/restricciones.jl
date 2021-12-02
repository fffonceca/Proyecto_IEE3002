##############################################################
# Restriccion 2: Restriccion de energia renovable no despachable
##############################################################
# Se asocia la energia producida renovable "r", en este caso es solo
# solar, por lo que la energia E_re = eficiencia * cantidad_producida
# unitariamente * numero de unidades renovables instaladas
@constraint(Mo, E_re[tiempo] .== effi_fv*E_re_u[tiempo]*N_re)


##############################################################
# Restricciones 3: Restricción de banco de baterias
##############################################################
# Restriccion (3a) sobre estado de carga de la bateria
for i in tiempo
    if i == 1
        # Estado inicial del SOC en 100% de la capacidad nominal
        @constraint(Mo, SOC[i] == Cbat + Ebat_ch[i]*effi_ch - Ebat_dis[i]/effi_dis)
    else
        @constraint(Mo, SOC[i] == SOC[i-1] + Ebat_ch[i]*effi_ch - Ebat_dis[i]/effi_dis)
    end
end

# Restriccion (3b) cumplir con profundidad de carga en las baterias
# es decir, carga minima y maxima de las baterias
@constraint(Mo, SOC[tiempo] .<= Cbat)
@constraint(Mo, SOC[tiempo] .>= Cbat*DOD)

# Restriccion (3c) y (3d) definiendo potencia de carga y descarga
@constraint(Mo, Pbat_ch == Cbat/delta_t_ch)
@constraint(Mo, Pbat_dis == Cbat/delta_t_dis)

# Restriccion (3e) y (3f) cumplir con flujo de energia de carga y descarga
# maxima 
@constraint(Mo, Ebat_ch[tiempo] .<= Pbat_ch*delta_t)
@constraint(Mo, Ebat_dis[tiempo] .<= Pbat_dis*delta_t)


##############################################################
# Restricciones 4: Generadores Diesel
##############################################################
# Constantes!!
# Restriccion (4a): Definicion de pendiente LP
b_LP_ge = U_fuel/(effi_ge*LHV)

# Restriccion (4e) define el coef de posicion de los costos MILP en generadores
a_ge = b_LP_ge*C_ge*I_cost

# Restriccion (4f) define la pendiente de costo para caso MILP en generadores
b_ge = (b_LP_ge*C_ge - a_ge)/C_ge

# Restricciones LP!!
# Restriccion (4b) y (4c) garantizar operabilidad de los motores
# diesel, ademas no se puede prender un motor antes de que otro 
# prendido
# Restriccion (4b): Garantizar que se prende un generador solo cuando el anterior esta 
# prendido
for i in tiempo
    @constraint(Mo, C_ge*I_ge + C_ge*(N_ge[i]-1) <= E_ge[i])
    @constraint(Mo, E_ge[i] <= C_ge*N_ge[i])
end

# Restriccion (4c): No exceder maximo de energia entregada por los generadores
@constraint(Mo, E_ge[tiempo] .<= N_ge_int*C_ge)

# Restriccion (4d) define los costos para los generadores
for i in tiempo
    @constraint(Mo, Co_ge[i] == N_ge[i]*a_ge + b_ge*E_ge[i])
end

# Restriccion (4g) suma de los costos totales
@constraint(Mo, Co_fuel == sum(Co_ge[i] for i in tiempo))


##############################################################
# Restricciones 5: restricciones de energia
##############################################################
# Restriccion (5a) definimos la conservacion de flujo energetico de la demanda
for i in tiempo
    @constraint(Mo, D[i] == E_re[i] + E_ge[i] - Ebat_ch[i] + Ebat_dis[i] + E_LL[i] - E_cur[i])
end

# Restriccion (5b) probabilidad de no satisfacer la demanda
@constraint(Mo, sum(E_LL[i] for i in tiempo)/sum(D[i] for i in tiempo) <= LLP)

# Restriccion (5c) limitando minimo de energia renovable en el sistema
@constraint(Mo, sum(E_re[i]*(1-I_re) for i in tiempo) >= sum(E_ge[i] for i in tiempo)*I_re)

# Restriccion (5d) tener un minimo de energia que la bateria
# suministre en caso de corte de otros generadores
@constraint(Mo, Cbat >= (sum(D[i] for i in tiempo)/365)*Nbat/(1-DOD))

# Restriccion (5e) definicion de ocurrencia, hasta ahora tenemos solo un escenario
@constraint(Mo, sum(I_occur[s]) == 1)


##############################################################
# Restricciones 6: costos sobre funcion objetivo
##############################################################
# PD: Restricciones 6 dentro de archivo
# path: modelo/funcion_obj.jl
