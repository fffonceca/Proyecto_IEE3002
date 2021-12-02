println("\nImportando librerias de optimizacion...\n")
using JuMP, Gurobi, LinearAlgebra

# Importanto datos
println("Importanto datos...\n")
include("libreria/parametros.jl");
include("libreria/curvas.jl");

# Conjuntos-Sets
# horas validas = 24,30,40,60,73,120,146,219,292,365
horas = 120;         # horas a simular
años = 1:20;        # años en funcion objetivo
s = 1:1;            # numero de escenarios
tiempo = 1:horas;   # horas del día

## Generando parametros de horas

## horas para dia de mayor demanda
println("Obteniendo maxima demanda\n")
include("libreria/generar.jl");

## Primeras 120 horas
# include("libreria/generar2.jl");

# Corriendo modelo completo
println("Corriendo modelo en horas ", tiempo_v[1], " a ", tiempo_v[end], "\n")
include("modelo/all.jl")



