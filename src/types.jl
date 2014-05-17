type PCA
    rotation::Matrix{Float64}
    scores::Matrix{Float64}
    standard_deviations::Vector{Float64}
    proportion_of_variance::Vector{Float64}
    cumulative_variance::Vector{Float64}
end

type ICA
    S::Matrix{Float64}
    H::Matrix{Float64}
    iter::Vector{Int}
    W::Matrix{Float64}
end

type NMF
    W::Matrix{Float64}
    H::Matrix{Float64}
    iterations::Int
    accuracy::Float64
end

type TSNE
    Y::Matrix{Float64}
end

type MDS
    Y::Matrix{Float64}
    D::Matrix{Float64}
    k::Int
end

type Isomap
    d::Int
    k::Int
    cc::Vector{Int}
    λ::Vector{Float64}    
    Y::Matrix{Float64}    
end

type Diffmap
    d::Int
    t::Int
    K::Matrix{Float64}
    Y::Matrix{Float64}
end

type Eigenmap
    d::Int
    k::Int
    t::Float64
    cc::Vector{Int}
    λ::Vector{Float64}
    Y::Matrix{Float64}
end

type LLE
    d::Int
    k::Int
    cc::Vector{Int}
    λ::Vector{Float64}
    Y::Matrix{Float64}  
end

function Base.show(io::IO, pc::PCA)
    println(io, "Rotation:")
    show(io, pc.rotation)
    print(io, "\n\n")
    println(io, "Scores:")
    show(io, pc.scores)
    print(io, "\n\n")
    println(io, "Reconstruction:")
    show(io, pc.scores * pc.rotation')
    print(io, "\n\n")
    println(io, "Standard Deviations:")
    show(io, pc.standard_deviations)
    print(io, "\n\n")
    println(io, "Proportion of Variance:")
    show(io, pc.proportion_of_variance)
    print(io, "\n\n")
    println(io, "Cumulative Variance:")
    show(io, pc.cumulative_variance)
end

function Base.show(io::IO, ic::ICA)
    println(io, "Source Matrix:")
    show(io, ic.S)
    print(io, "\n\n")
    println(io, "Mixing Matrix:")
    show(io, ic.H)
    print(io, "\n\n")
    println(io, "Iterations:")
    show(io, ic.iter)
    print(io, "\n\n")
    println(io, "Extracting Matrix:")
    show(io, ic.H)
end

function Base.show(io::IO, res::NMF)
    println(io, "W:")
    show(io, res.W)
    print(io, "\n\n")
    println(io, "H:")
    show(io, res.H)
    print(io, "\n\n")
    println(io, "Reconstruction:")
    show(io, res.W * res.H)
    print(io, "\n\n")
    println(io, "Iterations:")
    show(io, res.iterations)
    print(io, "\n\n")
    println(io, "Accuracy:")
    show(io, res.accuracy)
end

function Base.show(io::IO, res::TSNE)
    @printf "t-SNE results\n"
    show(io, res.Y)
end

function Base.show(io::IO, res::Isomap)
    println(io, "Dimensionality:")
    show(io, res.d)
    print(io, "\n\n")
    println(io, "NNs:")
    show(io, res.k)
    print(io, "\n\n")
    println(io, "Eigenvalues:")
    show(io, res.λ)
    print(io, "\n\n")
    println(io, "Embedding:")
    show(io, res.Y)
end

function Base.show(io::IO, res::Diffmap)
    println(io, "Dimensionality:")
    show(io, res.d)
    print(io, "\n\n")
    println(io, "Timesteps:")
    show(io, res.t)
    print(io, "\n\n")
    println(io, "Kernel:")
    show(io, res.K)
    print(io, "\n\n")
    println(io, "Embedding:")
    show(io, res.Y)
end

function Base.show(io::IO, res::Eigenmap)
    println(io, "Dimensionality:")
    show(io, res.d)
    print(io, "\n\n")
    println(io, "NNs:")
    show(io, res.k)
    print(io, "\n\n")
    println(io, "t:")
    show(io, res.t)
    print(io, "\n\n")
    println(io, "Eigenvalues:")
    show(io, res.λ)
    print(io, "\n\n")
    println(io, "Embedding:")
    show(io, res.Y)
end

function Base.show(io::IO, res::LLE)
    println(io, "Dimensionality:")
    show(io, res.d)
    print(io, "\n\n")
    println(io, "NNs:")
    show(io, res.k)
    print(io, "\n\n")
    println(io, "Eigenvalues:")
    show(io, res.λ)
    print(io, "\n\n")
    println(io, "Embedding:")
    show(io, res.Y)
end

