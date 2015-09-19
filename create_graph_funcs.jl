s = stat("libbisquik.so")
if s.size == 0
    const libpath = string(pwd(), "/libbisquik.dylib")
else
    const libpath = string(pwd(), "/libbisquik.so")
end

include("degseq.jl");
function bisquik_graph(degs::Array{Int64},trials::Int64,n::Int64)
	trial_number = 1;
    @printf("trial number: %i\n",trial_number);
    check_flag = ccall ( (:check_graphical_sequence, libpath),
                        Cint, # return value
                        (Int64, Ptr{Int64}), # arg types
                        n, degs); # actual args
    trial_number = 2;
	while trial_number <= trials && check_flag == 0
		@printf("trial number: %i\n",trial_number);
        #degs = convert(Array{Int64},degs + floor(0.001*degs.*rand(length(degs),1)));
        degs[end] += 1
        if mod(sum(degs),2) != 0
        	degs[end] = degs[end]+1;
        end
        check_flag = ccall ( (:check_graphical_sequence, libpath),
                        Cint, # return value
                        (Int64, Ptr{Int64}), # arg types
                        n, degs); # actual args
		trial_number = trial_number + 1;
	end

    if check_flag == 1
		@printf("Successfully generated a graphical sequence.\n")
        nedges = sum(degs)
        src = zeros(Int64, nedges)
        dst = zeros(Int64, nedges)
        rval = ccall ( (:generate_bisquik_graph, libpath),
                        Cint, # return value
                        (Int64, Ptr{Int64}, Ptr{Int64}, Ptr{Int64}), # arg types
                        length(degs), degs, src, dst) # actual args
		src = src+1;
    	dst = dst+1;
    	A = sparse(src, dst, 1, length(degs), length(degs));
    else
   		@printf("COULD NOT GENERATE A GRAPHICAL SEQUENCE\n")
		###############################
		#TODO: improve this error case#
		###############################
		assert(false);
    end

    return A;
end

function check_graphical_sequence(degs::Array{Int64},trials::Int64,n::Int64)
	trial_number = 1;
    @printf("trial number: %i\n",trial_number);
    check_flag = ccall ( (:check_graphical_sequence, libpath),
                        Cint, # return value
                        (Int64, Ptr{Int64}), # arg types
                        n, degs); # actual args
    trial_number = 2;
	while trial_number <= trials && check_flag == 0
		@printf("trial number: %i\n",trial_number);
        #degs = convert(Array{Int64},degs + floor(0.001*degs.*rand(length(degs),1)));
        degs[end] += 1
        if mod(sum(degs),2) != 0
        	degs[end] = degs[end]+1;
        end
        check_flag = ccall ( (:check_graphical_sequence, libpath),
                        Cint, # return value
                        (Int64, Ptr{Int64}), # arg types
                        n, degs); # actual args
		trial_number = trial_number + 1;
	end
	return (degs,check_flag)
end

function bisquik_graph2(degs::Array{Int64},n::Int64)

    #@printf("Successfully generated a graphical sequence.\n")
    nedges = sum(degs)
    src = zeros(Int64, nedges)
    dst = zeros(Int64, nedges)
    rval = ccall ( (:generate_bisquik_graph, libpath),
                        Cint, # return value
                        (Int64, Ptr{Int64}, Ptr{Int64}, Ptr{Int64}), # arg types
                        length(degs), degs, src, dst) # actual args
    src = src+1
    dst = dst+1
    return (src,dst)
end


function create_graph(p::Float64,n::Int64,dmax::Int64,dmin::Int64)
	n = convert(Int64,n)
   	trials = 5
	degs_vector = convert(Array{Int64,1},ceil(degseq(p,n,dmax,dmin)))
	A = bisquik_graph(degs_vector,trials,n)
	return A
end

# if we just want to look at src and dst
function create_graph(degs_vector::Vector{Int64},n::Int64)
	(src,dst) = bisquik_graph2(degs_vector,n)
	return (src,dst)
end