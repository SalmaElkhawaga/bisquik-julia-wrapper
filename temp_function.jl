include("pagerank_solver_v2.jl")
include("pre_pagerank_solver.jl")
function temp_function(P,V)
     @printf("Started ...")
    tStart=time()
    #####################################################
    # This is based on pagerank_solution_nonzeros_v3.m
    n = [1e9]
    d = floor(n.^(1/2))
    delta = 3
    p = 0.5 # power law

    # epsilon accuracy:
    eps_accuracy = [1e-1, 1e-2, 1e-3, 1e-4]
    # alpha values:
    #alpha = [0.25]# 
    alpha = [0.3 0.5 0.65 0.85]

    #####################################################
    tStart = time()
    k = 1 # number of vectors to pick - we're always picking 1 vec for now
    NNZEROS = zeros(Int64,length(eps_accuracy),length(alpha),length(n))
        for alpha_id = 1:length(alpha)
            X = pagerank_solver_v2(P,V,alpha[alpha_id])
            X_sorted = sort(X,1)

            for i = 1:length(eps_accuracy)
                t = 0
                for c = 1:k
                    vsum = cumsum(X_sorted[:,c])
                    temp = find(vsum .< eps_accuracy[i])
                    index = temp[end]
                    t = t + index
                end
                # get the average of non zeros among k vectors
                NNZEROS[i,alpha_id,1] = (k*n[1] - t)/k
            end
        end
        @printf("Elapsed time TWO is %f seconds.\n",time()-tStart)
        return NNZEROS
    
end
        
        
        