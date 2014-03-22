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

# Swiss roll dataset
function swiss_roll(n::Int = 1000, noise::Float64=0.05)
    t = (3 * pi / 2) * (1 + 2 * rand(n, 1))
    height = 30 * rand(n, 1)
    X = [t .* cos(t) height t .* sin(t)] + noise * randn(n, 3)   
    return X
end