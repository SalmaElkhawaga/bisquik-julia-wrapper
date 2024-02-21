using LightGraphs;
using CSV;
using DataFrames;
using SparseArrays;
using JSON3;
using Random;
using Dates;

# Function to generate random values biased towards lower values
function generate_biased_random()
    while true
        value = rand(111:120)
        if value <= 114 || rand() < 0.5
         return value
    end
end
end
println(" start randomizing degrees...")
rand_degrees =Int64[]

for i in 1:676194
    push!(rand_degrees, generate_biased_random())
end

println(" start sorting randomized degrees...")

sort!(rand_degrees)

println(now()," start reading CashApp degrees...")

# Read the CSV file
csv_data = CSV.File("CashApp.csv")

degree_data = [row[1] for row in eachrow(csv_data)]

degrees =Int64[]

println(now(), " start adding CashApp degrees to array...")
degree_data_length = length(degree_data) - 5
for i in 1:degree_data_length
    deg = degree_data[i][:DEGREE]
    rep = degree_data[i][:DEGREE_N_NODES]

    for j in 1:rep
        push!(degrees, parse(Int64,deg))
    end
end

println(now(), " start adding random degrees to CashApp degrees...")

#add rand_degrees to degrees
for i in 1:676194
    push!(degrees, rand_degrees[i])
end


# Total number of nodes desired
num_nodes = 78427854


# Function to generate a directed graph from a degree sequence and number of nodes
function generate_directed_graph(degree_sequence, num_nodes)
    graph = DiGraph(num_nodes)  # Create an empty directed graph with specified number of nodes

    # Sort the degree sequence in descending order to facilitate edge assignment
    sorted_degrees = sort(degree_sequence, rev=true)

    # Loop through nodes and assign edges based on degrees
    for i in 1:num_nodes
        current_degree = sorted_degrees[i]
        for j in 1:current_degree
            # Assign edges to higher-degree nodes
            neighbor = mod(i + j - 2, num_nodes) + 1  # Create an edge to a neighboring node
            add_edge!(graph, i, neighbor)  # Add directed edge from node i to its neighbor
        end
    end

    return graph
end


# Function to get source and destination lists from a directed graph
function get_source_destination_lists(directed_graph)
    source_list = Int[]
    destination_list = Int[]

    for edge in edges(directed_graph)
        src_node = src(directed_graph, edge)
        dst_node = dst(directed_graph, edge)
        push!(source_list, src_node)
        push!(destination_list, dst_node)
    end

    return source_list, destination_list
end

# Generate a directed graph using the custom function
println(now(), " start generating directed graph...")
directed_graph = generate_directed_graph(degrees, num_nodes)

println(now(), " start getting src, dst from directed graph...")
src, dst = get_source_destination_lists(directed_graph)
println("length of src result", length(src))


println(now(), " start randomizing weights...")
weights= rand(1:500,length(src))

println(now()," start concatinating edges with weights...")
matrix = hcat(src, dst, weights)

println(now(), " start creating df...")
df = DataFrame(matrix, :auto)

println(now(), " start writing to csv output...")
CSV.write("output-lightgraphs-9jan.csv", df, header=["src", "dst", "weight"])
