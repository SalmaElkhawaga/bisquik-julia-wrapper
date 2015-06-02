function pagerank_solver(A,k,alpha)
# k is the number of vectors under the experiment

# Generate transition matrix P
n = size(A,1);
s = sum(A,2);
idx = 1:n;
vals = 1./s;
P = sparse(idx, idx, vals[:])*A;

## Create the vectors V

p = sortperm(s[:],rev=true);
ids = p[1:k];

# set up our vectors v:
V = zeros(Float64,n,k);
for v = 1:k
    V[ids[v],v] = 1;
end

## Solve the PageRank problem using the power method

X = copy(V);
err = 1e-12;
iters_nb = floor((log(err/2))/(log(alpha)));
for i = 1:iters_nb
    X = alpha*(P'*X) + (1-alpha)*V;   
# 	X = (1-alpha)*V + (P'*X);
end
X_exact = X;
return X;
end

