
##############################################################
######################### Parametros #########################
##############################################################


# Parametros cambiables
LLP = 0                                 # probabilidad de no satisfacer demanda
I_re = 0.2                              # penetracion renovable, porcentaje en energia renovable
Nbat = 0                                # numero de dias de independencia de la bateria
DOD = 0.5                               # deuda de descarga (% descarga máxima)


# Parametros fijos
r = 0.12                                # tasa de descuento
N_ge_int = 3                            # cantidad de generadores disponibles en Juan Bautista
CY = 1200                               # ciclos máximos de vida para la batería

U_fv = 1.56                             # costo célula FV en USD/W
U_ge = 1.48                             # costo grupo electrógeno de diésel en USD/W
U_fuel = 0.913                          # costo diesel en USD/l
U_bat = 0.297                           # costo batería en USD/Wh
U_elec = 0.149                          # costo de la electrónica de protección de la batería en USD/Wh
U_LL = 0.003                            # costo de la carga perdida en el sistema en USD/Wh

delta_t = 1                             # bloque de tiempo = 1hora
delta_t_dis = 4                         # tiempo de descarga
delta_t_ch = 4                          # tiempo de carga

effi_dis = 0.95                         # eficiencia de descarga de la batería
effi_ch = 0.95                          # eficiencia de carga de la batería
effi_fv = 1                             # eficiencia unidad renovable
effi_ge = 0.314                         # eficiencia grupo electrogeno de diesel

I_cost = 1.5/100                        # % del costo del combustible a carga nominal, reemplaza la eficiencia constante del gen de diesel

I_re_om = 1.5/100                       # % del costo total de la inversión usado cada año en mantenimiento para renovables
I_bat_om = 1.5/100                      # % del costo total de la inversión usado cada año en mantenimiento para baterias
I_ge_om = 1.5/100                       # % del costo total de la inversión usado cada año en mantenimiento para generadores

I_ge = 0.5                              # % mínimo de entrega de energía por el gen. de diesel
I_fv = 0.3                              # % ERNC
C_fv = 545                              # Capacidad unidad FV en W
C_ge = 400000                           # capacidad generador en W
LHV = 9890                              # minimo valor de calentado del diesel Wh/l
