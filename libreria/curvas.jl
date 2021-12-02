## Curvas de demanda obtenida del mismo paper
## Curvas de energia renovable obtenidas de https://solar.minenergia.cl/exploracion
using CSV
using DataFrames

## Csvs

# Vector de demanda, escalada por PIB nacional... PIB_CHILE/PIB_BOLIVIA
demanda = CSV.read("data_csv/Demand.csv", DataFrame)[:,7].*4.2;

# Vector de energia producida unitariamente por panel solar
energy_re = CSV.read("data_csv/Renewable_Energy.csv", DataFrame)[:,2]'.*1000;
