using Graphs

function laplacian_eigenmaps(X::Matrix, d::Int=2, k::Int=12; t::Float64=1.0)
    # Construct NN graph
    G, dist = find_nn(X, k)
    G, dist, cc = find_largest_cc(G,dist)

    # Compute weights
    w = exp(-dist.^2/t)
    W = weight_matrix(G,w)
    D = diagm(sum(W,2)[:])
    L = D - W

    # Sparse representation    
    #L = laplacian_matrix_sparse(G,w)
    #D = spdiagm(diag(L))

    # Build eigenmaps
    λ, U = eig(L, D)
    λ = λ[2:(d+1)]
    Y = U[:,2:(d+1)]
    return Eigenmap(d, k, λ, Y)
end
