#############
# Formato
#############
# # var: explicacion...
#  @variable(Model, var >= 0, TypeVar)

##############################################################
# Variables asociadas a energia renovable
##############################################################
# E_re: Energia suministrada por la fuente renovable
@variable(Mo, E_re[tiempo] >= 0)

# N_re: Numero de fuentes renovables 
@variable(Mo, N_re >= 0, Int)


##############################################################
# Variables asociadas a la bateria
##############################################################
# SOC: state of charge, carga del banco de baterias
@variable(Mo, SOC[tiempo] >= 0)

# Cbat: Capacidad del banco de baterias
@variable(Mo, Cbat >=0)

# Ebat_ch: Energia de carga al banco de baterias
@variable(Mo, Ebat_ch[tiempo] >=0)

# Ebat_dis: Energia de descarga del banco de baterias
@variable(Mo, Ebat_dis[tiempo] >=0)

# Pbat_ch: Potencia de carga de la bateria completa
@variable(Mo, Pbat_ch >=0)

# Pbat_dis: Potencia de descarga de la bateria completa
@variable(Mo, Pbat_dis >=0)


##############################################################
# Variables asociadas al modelo diesel
##############################################################
# E_ge: Energia producida por los generadores en el tiempo tiempo
@variable(Mo, E_ge[tiempo] >= 0)

# N_ge: Numero de generadores activos en el tiempo tiempo
@variable(Mo, N_ge[tiempo] >= 0, Int)

# Co_ge: Costo de generacion en el tiempo tiempo
@variable(Mo, Co_ge[tiempo] >= 0)

# Co_fuel: Costo total de combustible para generadores 
@variable(Mo, Co_fuel >= 0)


##############################################################
# Variables asociadas a energia
##############################################################
# E_LL: Energia que no fue satisfecha por el sistema
@variable(Mo, E_LL[tiempo] >= 0)

# E_cur: Energia que no fue almacenada o consumida por el sistema 
@variable(Mo, E_cur[tiempo] >= 0)


##############################################################
# Variables asociadas funcion objetivo
##############################################################
# YC: Yearly Costs o costos anuales operativos OPEX
@variable(Mo, YC >= 0)

# Inv: Inversion inicial CAPEX
@variable(Mo, Inv >= 0)


##############################################################
# Variables asociadas a costos
##############################################################
# Co_OM: Costo de operacion y mantencion
@variable(Mo, Co_OM >= 0)

# Co_rep: Costo de por remplazar la bateria
@variable(Mo, Co_rep >= 0)

# Co_LL: Costo por carga perdida
@variable(Mo, Co_LL >= 0)


##############################################################
# Variables asociadas a escenarios (NO SE ESTA USANDO)
# PD: habria que insertar el indice en cada variable que 
# dependa del escenario, ver paper...
##############################################################
# I_s: probabilidad del escenario s
@variable(Mo, I_occur[s] >= 0)
