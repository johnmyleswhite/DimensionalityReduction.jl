using DimensionalityReduction

X = swiss_roll()
I = mds( sqrt(sum(X.^ 2, 1)' .+ sum(X.^ 2, 1) .- 2*At_mul_B(X,X)) )
@assert size(I.Y, 1) == size(X, 1)-1
@assert size(I.Y, 2) == size(X, 2)
