using JuMP, Gurobi, LinearAlgebra

t = 1:3;
g = 1:3;

#modelo
Mo= Model(Gurobi.Optimizer)

@variable(Mo, x[t,g] >= 0, Int)

@objective(Mo, Min, 10*sum(x))

#ecuaciones F.O
@constraint(Mo, x .>= -3.5)

#optimizar
JuMP.optimize!(Mo)
#imprimir resultados
println("Resultados")
println("Inv:", JuMP.value(x[1,1]))

println("Costo total:", objective_value(Mo))

# ##############################################################
# # Resultados en Consola
# ##############################################################
# println("Cantidad de unidades renovables:", JuMP.value(N_re))

# println("")
# for i in 1:horas
#     println(": Generador prendido en tiempo ", i, " :", JuMP.value(N_ge[i]))
# end

# println("")
# println("Capacidad nominal de la bateria: ", JuMP.value(Cbat))
# println("")

# println("Restriccion SOC:  SOC[i] == SOC[i-1] + Ebat_ch[i-1]*effi_ch - Ebat_dis[i-1]/effi_dis")
# for i in 1:horas-1
#     println(i, ": ", JuMP.value(SOC[i+1]), " = ", JuMP.value(SOC[i]), " + ", JuMP.value(Ebat_ch[i])/effi_ch, " - ",  JuMP.value(Ebat_dis[i])/effi_dis)
# end
# print("")

# println("Restriccion Demanda:  D[i] == E_re[i] + E_ge[i] - Ebat_ch[i] + Ebat_dis[i] + E_LL[i] - E_cur[i]")
# for i in 1:horas
#     println(i, ": ", D[i], " = ", JuMP.value(E_re[i]), " + ", JuMP.value(E_ge[i]), " - ", JuMP.value(Ebat_ch[i]), " + ", JuMP.value(Ebat_dis[i]), " + ", JuMP.value(E_LL[i]), " - ", JuMP.value(E_cur[i]))
# end
