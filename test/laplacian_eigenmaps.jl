using DimensionalityReduction

X = swiss_roll()
I = laplacian_eigenmaps(X)
@assert size(I.Y, 1) == size(X, 1)-1
@assert size(I.Y, 2) == size(X, 2)