function minmax_normalization(X::Matrix)
    X -= minimum(X)
    X / maximum(X)
end

function diffusion_maps(X::Matrix, d::Int=2, t::Int=1, sigma::Float64=1.0)
    X = minmax_normalization(X)
    
    info("Compute Markov forward transition probability matrix with $(t) timesteps...")
    sumX = sum(X.^ 2, 2)
    K = exp(( -2(X*X') .+ sumX' .+ sumX ) ./ (2*sigma^2))
    
    p = sum(K, 1)'
    K ./= ((p * p') .^ t)
    p = sqrt(sum(K, 1))'
    K ./= (p * p')
    
    U, S, V = svd(K, false)
    U ./= U[:,1]
    Y = U[:,2:(d+1)]
    
    return Diffmap(d, t, K, Y)
end
