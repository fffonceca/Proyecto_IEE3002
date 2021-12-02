using Statistics

# Generando matriz
D_matrix = reshape(demanda, horas, Int(8760/horas));

# Generado medias
a = mean(D_matrix, dims=1);

# Buscando seccion de max demanda
max_matrix = findmax(a);

# Maxima demanda contratada
max_index = max_matrix[2][2];

# Obteniendo vector de tiempo
tiempo_v = horas*(max_index-1)+1:horas*max_index;

# Redefiniendo parametros
D = demanda[tiempo_v]';
E_re_u = energy_re[tiempo_v];