import csv
import random
import networkx as nx


# Example degree sequence (replace with your own degree distribution)
degree_sequence = []

# Open the CSV file for reading
with open('data.csv', newline='') as csvfile:
    csv_reader = csv.reader(csvfile)

    # Read the header to get column indices
    headers = next(csv_reader)
    deg_col_idx = headers.index('DEGREE')  # Get index for 'DEGREE' column
    rep_col_idx = headers.index('DEGREE_N_NODES')  # Get index for 'DEGREE_N_NODES' column

    # Read specific columns row by row
    for row in csv_reader:
        deg = row[deg_col_idx]
        rep = row[rep_col_idx]

        degree_sequence.extend([deg] * int(rep))  # Add degree to sequence


def biased_random_number():
    # Define probabilities for each number in the range
    probabilities = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
    # Higher weights for numbers in range 111 to 115 (reversed order)

    # Generate a random number based on the adjusted probabilities
    biased_number = random.choices(range(111, 121), weights=probabilities)[0]
    return biased_number

randomized_degree_sequence = [biased_random_number() for _ in range(10)]

#sort randomized degree sequence in ascending order
randomized_degree_sequence.sort()

degree_sequence.extend(randomized_degree_sequence)

# Total number of nodes desired
num_nodes = 78427854

# Generate a directed graph using the directed_configuration_model method
directed_graph = nx.directed_configuration_model(degree_sequence, out_degree=degree_sequence, create_using=nx.DiGraph())

# Open CSV file for writing
with open('networkx_10jan.csv', 'w', newline='') as csvfile:
    csv_writer = csv.writer(csvfile)

    # Write nodes section
    csv_writer.writerow(['Node ID'])
    for node in directed_graph.nodes():
        csv_writer.writerow([f'Node: {node}'])

    # Add an empty row to separate nodes and edges sections
    csv_writer.writerow([])

    # Write edges section
    csv_writer.writerow(['Source', 'Target'])
    for edge in directed_graph.edges():
        csv_writer.writerow([f'Node: {edge[0]}', f'Node: {edge[1]}'])

print("Nodes and edges exported to nodes_and_edges.csv")
