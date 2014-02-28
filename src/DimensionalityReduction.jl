module DimensionalityReduction
    export pca, pcaeig, pcasvd
    export ica, nmf, mds, tsne, isomap, diffusion_maps

    include("types.jl")
    include("pca.jl")
    include("nmf.jl")
    include("mds.jl")
    include("ica.jl")
    include("tsne.jl")
    include("isomap.jl")
    include("diffusion_maps.jl")
end
