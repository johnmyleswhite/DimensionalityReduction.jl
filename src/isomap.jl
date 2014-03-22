using Graphs

function isomap(X::Matrix, d::Int=2, k::Int=12)
    # Construct NN graph
    G, D = find_nn(X, k)
    G, D, cc = find_largest_cc(G,D)
    n = num_vertices(G)

    # Compute shortest path for every point
    DD = zeros(n, n)
    for i=1:n
        r = dijkstra_shortest_paths(G, D, i)
        DD[:,i] = r.dists
    end

    # Perform MDS
    M = DD.^2
    SM = sum(M,1)
    M = -0.5(((M .- (SM' ./ n)) .- (SM ./n)) + sum(M)/(n^2))    
    
    # Compute embedding
    #L, P = eig(M)
    #L = real(L)[1:d]
    #P = real(P)[:,1:d]
    #Y = P .* real(sqrt(complex(L)))'

    λ, U, _ = eigs(M, nev=d+1, which="SM")
    λ = λ[2:(d+1)]
    U = U[:,2:(d+1)]
    Y = U .* λ'

    return Isomap(d, k, λ, U, cc, Y, M)
end
