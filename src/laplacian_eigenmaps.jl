function laplacian_eigenmaps(X::Matrix, d::Int=2, k::Int=12; t::Float64=1.0)    
    n = size(X, 2)

    # Construct NN graph
    println("Building neighborhood graph...")
    D, E = find_nn(X, k)

    # Select largest connected component    
    Dc = spzeros(n,n)
    for i = 1 : n        
        jj = E[:, i]
        Dc[i,jj] = D[:, i]
    end
    CC = components(E)
    C = length(CC) == 1 ? CC[1] : CC[indmax(map(size, CC))]    
    Dc = Dc[C,C]
    
    # Compute weights
    println("Compute weights...")
    W = exp((-Dc.^2)./t)
    D = diagm(sum(W,2)[:])
    L = D - W

    # Build eigenmaps
    println("Compute embedding (solve eigenproblem)...")
    λ, U = eig(L, D)
    idx = sortperm(real(λ))
    λ = real(λ)[idx[2:(d+1)]]
    Y = real(U)[:,idx[2:(d+1)]]

    return Eigenmap(d, k, t, C, λ, Y')
end
