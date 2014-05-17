function isomap(X::Matrix; d::Int=2, k::Int=12)
    # Construct NN graph
    println("Building neighborhood graph...")
    D, E = find_nn(X, k)

    # Select largest connected component
    CC = components(E)
    if length(CC) == 1
        C = CC[1]
        Dc = D
        Ec = E        
    else
        C = CC[indmax(map(size, CC))]
        Dc = D[:,C]    

        # renumber edges    
        R = Dict(C, 1:length(C))
        Ec = zeros(Int,k,length(C))
        for i = 1 : length(C)
            Ec[:,i] = map(i->get(R,i,0), E[:,C[i]])
        end
    end

    # Compute shortest path for every point
    println("Computing shortest paths...")
    n = size(Dc,2)
    DD = zeros(n, n)
    for i=1:n
        P, PD = dijkstra(Dc, Ec, i)
        DD[i,:] = PD
    end

    # Perform MDS
    println("Constructing low-dimensional embedding...")
    M = DD.^2
    #SM = sum(DD.^2, 1)    
    #M = -0.5(((M .- (SM' ./ n)) .- (SM ./n)) .+ sum(M)/(n^2))

    # Double centering matrix J = I - 1/N 11'
    #J = eye(n) - ones(n, n) ./ n
    #B = -0.5 * J * M * J

    # Simplification
    #o = ones(n)
    #B = M - (o * o' * M ./ n) - (M * o * o' ./ n) + (o * o' * M * o * o' ./ (n^2))
    #B = M - (o * o' * M ./ n) - ((o * o' * M')' ./ n) + (o * o' * M * o * o' ./ (n^2))    
    #B = M - o * sum(M, 1) ./ n - (o * sum(M, 2)')' ./ n .+ sum(M, 1) * o * o'./ (n^2)
    B = (M .- sum(M, 1) ./ n .- sum(M, 2) ./ n .+ sum(M) ./ (n^2)) .* -0.5

    # Compute embedding
    λ, U = eig(B)   
    indices = find(!(imag(λ) .< 0.0) .* !(imag(λ) .> 0.0) .* real(λ) .> 0)[1:d]
    λ = λ[indices]
    U = U[:, indices]
    Y = real(U .* sqrt(λ)')

    return Isomap(d, k, C, λ, Y')
end