module DimensionalityReduction
    export pca, pcaeig, pcasvd
    export ica, 
           nmf, 
           mds, 
           tsne, 
           isomap, 
           diffusion_maps, 
           laplacian_eigenmaps
    export swiss_roll

    include("types.jl")
    include("pca.jl")
    include("nmf.jl")
    include("mds.jl")
    include("ica.jl")
    include("tsne.jl")
    include("utils.jl")
    include("isomap.jl")
    include("diffusion_maps.jl")
    include("laplacian_eigenmaps.jl")    
    
end
