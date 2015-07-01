function trans_mat_vec_v2(src::Vector{Int64},dst::Vector{Int64}, nzvals::Vector{Float64},x::Vector{Float64})
    y = zeros(Float64,length(x))
    for i = 1:length(src)
        j = dst[i]
        y[j] += nzvals[src[i]]*x[src[i]]
    end
    return y
end


function pagerank_solver_v3(src::Vector{Int64},dst::Vector{Int64},nzvals::Vector{Float64},V::Vector{Float64},alpha::Float64)
    ## Solve the PageRank problem using the power method
    X = V
    Vp = (1-alpha)*V

    err = 1e-12
    iters_nb = floor((log(err/2))/(log(alpha)))

    for i = 1:iters_nb
        X = alpha*trans_mat_vec_v2(src,dst,nzvals,X[:]) + Vp
    end

    return X
end