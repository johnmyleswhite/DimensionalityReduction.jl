function lle(X::Matrix; d::Int=2, k::Int=12)
    n = size(X, 2)

    # Construct NN graph
    println("Building neighborhood graph...")
    D, E = find_nn(X, k)

    # Select largest connected component
    cc = components(E)
    c = cc[indmax(map(size, cc))]    
    if length(cc) == 1
        c = cc[1]             
    else
        c = cc[indmax(map(size, cc))]
        # renumber edges    
        R = Dict(c, 1:length(c))
        Ec = zeros(Int,k,length(c))
        for i = 1 : length(c)
            Ec[:,i] = map(i->get(R,i,0), E[:,c[i]])
        end
        E = Ec
        X = X[:,c]
    end


    if k > d 
        println("   [K>D: regularization will be used]")
        tol = 1e-5
    else
        tol = 0
    end
    
    # Reconstruct weights
    println("Solve for reconstruction weights...")
    W = zeros(k, n)
    for i = 1 : n
        Z = X[:, E[:,i]] .- X[:,i]
        C = Z'*Z
        C = C + eye(k, k) * tol * trace(C)
        wi = vec(C\ones(k, 1))        
        W[:, i] = wi./sum(wi)
    end
    
    # Compute embedding
    println("Compute embedding (solve eigenproblem)...")
    M = eye(n,n) # speye(n,n)
    for i = 1 : n
        w = W[:, i]
        jj = E[:, i]
        M[i,jj] = M[i,jj] - w'
        M[jj,i] = M[jj,i] - w
        M[jj,jj] = M[jj,jj] + w*w'
    end

    #λ, U = eigs(M, nev=d+1) # only for sparse
    λ, U = eig(M)    
    λ = λ[2:(d+1)] # get bottom (smallest) eigenvalues (discard first)
    Y = U[:,2:(d+1)]'*sqrt(n)

    return LLE(d, k, c, λ, Y)
end
