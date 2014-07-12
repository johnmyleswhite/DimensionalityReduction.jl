using DimensionalityReduction
using Base.Test

X, L = swiss_roll()
I = mds( sqrt(sum(X.^2, 1)' .+ sum(X.^2, 1) .- 2*At_mul_B(X,X)) )
@test size(I.Y, 1) == size(X, 1)-1
@test size(I.Y, 2) == size(X, 2)
