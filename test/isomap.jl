using DimensionalityReduction

d = 2
k = 3
X = vcat(randn(7,3)/10,eye(3,3)*1000,abs(randn(5,3))*100)
I = isomap(X,d,k)
@assert size(I.Y) == (15,2)

