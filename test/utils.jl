using DimensionalityReduction

k = 3
X = rand(3, 15)

# test k-nn graph
D, E = DimensionalityReduction.find_nn(X, k)
@assert size(X,2) == size(D,2) && size(D, 1) == k
@assert size(X,2) == size(E,2) && size(E, 1) == k

# test connected components
CC = DimensionalityReduction.components(E)
@assert length(CC) > 0

# test shortest path
#P, PD = dijkstra(D, E, 1)