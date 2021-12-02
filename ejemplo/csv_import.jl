using CSV
using DataFrames

demand = CSV.read("Demand.csv", DataFrame);
energy_re = CSV.read("Renewable_Energy.csv", DataFrame);

D = demand[:,2]';
E_neta_fv =  energy_re[:,2]'.*1000;

