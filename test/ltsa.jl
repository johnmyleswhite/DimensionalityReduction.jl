using DimensionalityReduction
using Base.Test

X, L = swiss_roll(2000)
I = ltsa(X)
@test size(I.Y, 1) == size(X, 1)-1
@test size(I.Y, 2) == size(X, 2)