function trans_mat_vec(A::SparseMatrixCSC{Float64,Int64}, x::Vector{Float64},alpha::Float64)
  y = zeros(size(A,2))
  cp = A.colptr
  nz = A.nzval
  rv = A.rowval
  n = size(A,2)



  for i=1:n
      yi = 0.
      for nzi=cp[i]:cp[i+1]-1
          yi += nz[nzi]*x[rv[nzi]]
      end
      y[i] = yi*alpha
  end
  return y
end

function pagerank_solver(A,k,alpha)
# k is the number of vectors under the experiment

# Generate transition matrix P
n = size(A,1);
s = sum(A,2);
idx = 1:n;
vals = 1./s;
@time begin
P = sparse(idx, idx, vals[:])*A;
end
## Create the vectors V
#@time begin
#p = sortperm(s[:],rev=true);
#ids = p[1:k];
#end
ids = 321;
@time begin
# set up our vectors v:
V = zeros(Float64,n,k);
for v = 1:k
    V[ids[v],v] = 1;
end
end

## Solve the PageRank problem using the power method
@time begin
X = V;
Vp = (1-alpha)*V;
end
err = 1e-12;
@time begin
iters_nb = floor((log(err/2))/(log(alpha)));
end
for i = 1:iters_nb
    @time begin
    X = trans_mat_vec(P,X[:],alpha) + Vp;
    end
end
return X;
end
