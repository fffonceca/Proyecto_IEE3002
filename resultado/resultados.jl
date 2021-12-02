using Plots

## libreria
Plots.pyplot()
## Vectores
eje_tiempo = tiempo

## data
demanda_v = D[eje_tiempo]
E_generada = JuMP.value.(E_ge)[eje_tiempo]
E_renovable = JuMP.value.(E_re)[eje_tiempo]
flujo_bateria = JuMP.value.(Ebat_ch)[eje_tiempo] .- JuMP.value.(Ebat_dis)[eje_tiempo]
E_perdida = JuMP.value.(E_LL)[eje_tiempo]
SoCharge = JuMP.value.(SOC)[eje_tiempo]
Capacidad_bateria = JuMP.value(Cbat)
Unidades_renovables = JuMP.value(N_re)

println("RESULTADOS: ")
println("Cbat: ", Capacidad_bateria)
println("Unidades Renovables: ", Unidades_renovables)
println("Costo total: ", objective_value(Mo))

##############################################################
# Resultados de Despacho
##############################################################
eje_y = hcat(demanda_v, E_generada, E_renovable, flujo_bateria, E_perdida)

## plot
obj_plot = plot(title="Despacho de energía", xlabel="Horas", ylabel="Wh", 
                ylims=(1.2*minimum(eje_y), 1.4*maximum(eje_y)), dpi=100, 
                size=(1600,800));

## plotiando
plot!(eje_tiempo, eje_y[:,1], label="Demanda",              lw = 1.5,   color="black", linestyle = :dashdot);
plot!(eje_tiempo, eje_y[:,2], label="Energia no Renovable", lw = 0,     fill=(0,0.5,:orange));
plot!(eje_tiempo, eje_y[:,3], label="Energia Renovable",    lw = 0,     fill=(0,0.5,:green));
plot!(eje_tiempo, eje_y[:,4], label="Flujo de Batería",     lw = 1,     color=RGB(0.2,0.35,0.6));
plot!(eje_tiempo, eje_y[:,5], label="Carga de Perdida",     lw = 1,     color=:grey);

savefig(obj_plot, "resultado/graficos/despacho_energia.png")

##############################################################
# Resultados en SOC
##############################################################
if Capacidad_bateria > 0
    ## data
    eje_y2 =hcat(SoCharge./Capacidad_bateria, -1*flujo_bateria./norm(flujo_bateria));

    ## plot
    obj_plot2 = plot(title="Flujos sobre la Batería", xlabel="Horas", dpi=100, 
                    size=(1600,600));
    plot!(eje_tiempo, eje_y2[:,1], label="Estado de Carga", lw = 2);
    plot!(eje_tiempo, eje_y2[:,2], label="Flujo de energía", lw = 2);
    savefig(obj_plot2, "resultado/graficos/SOC.png")
else
    println("No hubo baterias")
end


