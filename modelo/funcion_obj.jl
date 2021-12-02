# Funcion Objetivo
# Minimizar los costos totales
# F.O: Inversion inicial + Costo actual neto

# Funcion Objetivo: Minimizar
@objective(Mo, Min, Inv + sum(YC/((1 + r)^y) for y in años))


##############################################################
# Restricciones 6: Asociadas a costos de la funcion obj
##############################################################
# Restriccion (6e): definicion de U_rep, o costo unitario de reemplao de bateria.
# PD: Se define antes, ya que es una constante
U_rep = (U_bat - U_elec)/(2*CY*(1-DOD))

# Restriccion (6a): definicion de inversion inicial, se define
# tanto por la cantidad de unidades renovables.
@constraint(Mo, Inv == U_fv*N_re*C_fv + U_bat*Cbat)
# TODO: arreglar generadores para que esten los 3 y nada mas.

# Restriccion (6b): definicion de los costos anuales
@constraint(Mo, YC == Co_OM + Co_fuel + Co_rep + Co_LL)

# Restriccion (6c): definicion de Co_OM, o costos de operacion y mantenimiento
@constraint(Mo, Co_OM == U_fv*N_re*C_fv*I_re_om + U_bat*Cbat*I_bat_om + U_ge*N_ge_int*C_ge*I_ge_om)

# Restriccion (6d): definicion de Co_rep, o costos de reparacion
@constraint(Mo, Co_rep == U_rep*sum(Ebat_ch[i] for i in tiempo) + U_rep*sum(Ebat_dis[i] for i in tiempo))

# Restriccion (6f): definicion de Co_LL, o costo por carga perdida
@constraint(Mo, Co_LL == U_LL*sum(E_LL[i] for i in tiempo))