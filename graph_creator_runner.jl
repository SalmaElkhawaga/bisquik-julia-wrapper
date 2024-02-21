include("create_graph_funcs.jl") 

using DataFrames;
using SparseArrays;
using CSV;
using JSON3;
using Random;

# Function to generate random values biased towards lower values
function generate_biased_random()
    while true
        value = rand(111:120)
        if value <= 114 || rand() < 0.5
         return value
    end
end
end
rand_degrees =Int64[]

for i in 1:676194
    push!(rand_degrees, generate_biased_random())
end

sort!(rand_degrees)

# Read the CSV file
csv_data = CSV.File("CashApp.csv")

degree_data = [row[1] for row in eachrow(csv_data)]

degrees =Int64[]

for i in 1:109
    deg = degree_data[i][:DEGREE]
    rep = degree_data[i][:DEGREE_N_NODES]

    for j in 1:rep
        push!(degrees, parse(Int64,deg))
    end
end

#add rand_degrees to degrees
for i in 1:676194
    push!(degrees, rand_degrees[i])
end

## Graph parameters
n = 78427854
println("length of input degrees", length(degrees))

#Checking
(degs,check_flag)=check_graphical_sequence(degrees,5,n)
println("valid flag: ", check_flag)

(src,dst,l) = bisquik_graph(degrees,5,n);
println("length of src result", length(src))
println("length of l result", length(src))

weights= rand(1:500,length(src))

matrix = hcat(src, dst, weights)
df = DataFrame(matrix, :auto)
CSV.write("output.csv", df, header=["src", "dst", "weight"])


