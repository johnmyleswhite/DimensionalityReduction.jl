using Graphs

# Generate all combinations of "n" elements from a given iterable object
function combn(v::Vector, n::Int)
    nv = length(v)
    A = [0:nv^n-1]+(1/2)
    B = [nv.^[1-n:0.]]
    IND = int(rem(floor(A * B'),nv) + 1)
    v[IND]
end

# Creates incidence graph and list distances corresponding to graph egdes
function find_nn(X::Matrix, k::Int=12)
    rows = size(X,1)
    #dists = spzeros(rows, rows)
    dists = zeros(0)
    g = simple_inclist(rows, is_directed=false)
    for i=1:rows
        e = out_edges(i, g)
        D = vec(sqrt(sum((X.-X[i,:]).^2,2)))
        knn = sortperm(D)[2:k+1]
        for j=1:k
            v = knn[j]
            if length(filter(x -> target(x)==v, e)) == 0
                add_edge!(g, v, i)
                #dists[i, v] = dists[v, i] =D[v]
                push!(dists, D[v])
            end
        end
    end
    g, dists
end

# Get largets connected component from graph as well as corrsponding disances
function find_largest_cc(G::GenericIncidenceList, D::Vector)
    ccs = connected_components(G)
    cc_idx = sortperm(map(size, ccs), rev=true)[1]
    cc = ccs[cc_idx]
    n = length(cc)
    if n == 1
        CCG = G
        dists = D
    else
        cc_idx = Dict(cc,1:n)
        dists = Float64[]
        CCG = simple_inclist(n, is_directed=false)
        for i=1:n
            eg = out_edges(cc[i], G)
            e = out_edges(i, CCG)
            for j=1:length(eg)
                s = source(eg[j])
                t = target(eg[j])
                if length(filter(x->target(x)==cc_idx[t], e)) == 0
                    add_edge!(CCG, cc_idx[t], cc_idx[s])
                    push!(dists, D[eg[j].index])
                end
            end
        end
    end
    CCG, dists, cc
end

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
    L, P = eig(M)
    if length(L) < d
        d = length(L)
        warn("Target dimensionality reduced to $(d)")
    end
    
    # Compute embedding
    L = real(L)[1:d]
    P = real(P)[:,1:d]
    Y = P .* real(sqrt(complex(L)))'

    return Isomap(d, k, L, P, cc, Y, M)
end
