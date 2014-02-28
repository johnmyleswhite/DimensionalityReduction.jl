using DimensionalityReduction

my_tests = ["test/pca.jl",
            "test/ica.jl",
            "test/isomap.jl"]

println("Running tests:")

for my_test in my_tests
    println(" * $(my_test)")
    include(my_test)
end
