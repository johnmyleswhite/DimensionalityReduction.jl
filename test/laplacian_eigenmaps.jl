using DimensionalityReduction

d = 2
k = 12
n = 1000
X = swiss_roll(n)
I = laplacian_eigenmaps(X,d,k)
@assert size(I.Y) == (n, d)
