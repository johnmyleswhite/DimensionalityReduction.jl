using DimensionalityReduction

my_tests = ["test/pca.jl",
            "test/mds.jl",
            "test/utils.jl",
            "test/isomap.jl",
            "test/lle.jl",
            "test/laplacian_eigenmaps.jl",
            "test/diffusion_maps.jl"]

println("Running tests:")

for my_test in my_tests
    println(" * $(my_test)")
    include(my_test)
end
