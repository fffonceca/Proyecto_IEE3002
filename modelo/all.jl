# Modelo
println("Creando modelo...\n")
Mo = Model(Gurobi.Optimizer);

# Agregando variables
println("Agregando variables...\n")
include("variable.jl")

# Agregando Funcion objetivo
println("Agregando funcion objetivo\n")
include("funcion_obj.jl")

# Agregando restricciones
println("Agregando restricciones...\n")
include("restricciones.jl")

# println(Mo)

# Optimizar
println("Empezamos a optimizar...\n")
JuMP.optimize!(Mo)

# Generando resultados
println("Generando resultados...\n")
include("../resultado/resultados.jl")