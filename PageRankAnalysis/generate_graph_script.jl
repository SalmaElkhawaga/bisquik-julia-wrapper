include("../create_graph.jl");
include("pagerank_solver.jl");
# Pkg.add("Gadfly");
tStart=time();

#####################################################
# This is based on pagerank_solution_nonzeros_v3.m
function generate_graph_script(n::Int64)
# n = [1e4];
d = floor(n.^(1/2));
delta = 3;
p = 0.5; # power law

# epsilon accuracy:
eps_accuracy = [1e-1, 1e-2, 1e-3, 1e-4];
# alpha values:
alpha = [0.25 0.85 0.95];

#####################################################
# count the number of nonzeros:
tStart = time();
k = 1;# number of vectors to pick
NNZEROS = zeros(Int64,length(eps_accuracy),length(alpha),length(n));
for exp_id = 1:length(n)
    A = create_graph(p,n[exp_id],d[exp_id],delta);
    for alpha_id = 1:length(alpha)
    	X = pagerank_solver(A,k,alpha[alpha_id]);
    	X_sorted = sort(X,1);
        
        for i = 1:length(eps_accuracy)
            t = 0;
            for c = 1:k
            	vsum = cumsum(X_sorted[:,c]);
            	temp = find(vsum .< eps_accuracy[i]);
            	index = temp[end];
                t = t + index;
            end
            # get the average of non zeros among k vectors
            NNZEROS[i,alpha_id,exp_id] = (k*n[exp_id] - t)/k;
        end    
    end
end
tStop = time();
@printf("Elapsed time TWO is %f seconds.\n",tStop-tStart)
return NNZEROS;
end

#####################################################
# using Gadfly
# # Generate Data to plot
# cols = length(n);
# rows = length(alpha);
# eps_accuracy_reciprocal = 1./eps_accuracy;
# for i = 1 : cols
#     for j = 1 : rows
#     	c = NNZEROS[:,j,i];
#  		# subplot(rows,cols,(j-1)*cols+i, 'XScale', 'log', 'YScale', 'log')
# 	 	ratios = c./((1/(1-p)) * (d[i]^(1/p)-d[i]));
#  		nsize = n[i]/((1/(1-p)) * (d[i]^(1/p)-d[i]));
#  		yval = nsize*ones(length(eps_accuracy_reciprocal),1); 
#  		val3 = eps_accuracy_reciprocal.^(1/(1-alpha[j]));
#  				
# 		# curve 1: actual non zeros
# 		# curve 2: the upper limit possible with all n independent of eps_accuracy
# 		# curve 3: RHS: yvalues = (1/eps)^(1/(1-alpha))
# 		 
# 
# 		myplot = plot(layer(x = eps_accuracy_reciprocal, 
# 						y = ratios, 
# 						#Geom.line #,Theme(line_width=1pt, default_color=color("orange"))
# 						Geom.point, Geom.line, Scale.x_log10, Scale.y_log10, Theme(default_color=color("blue"))
# 						),
# 					layer(x = eps_accuracy_reciprocal,
# 							y = yval,
# 							# Geom.point #, Theme( default_point_size=1mm, default_color=color("green"))
# 							Geom.point, Geom.line, Scale.x_log10, Scale.y_log10, Theme(default_color=color("red"))
# 							)
# # 					layer(x = eps_accuracy_reciprocal,
# # 							y = val3,
# # 							Geom.point #, Theme( default_point_size=1mm, default_color=color("green"))
# # 							# Geom.line, Scale.x_log10, Scale.y_log10
# # 							)
# 							)
# 		println("Saving plot $i$j");
# 		draw(PDF(join(["plot", string(i), string(j),".pdf"]), 16cm, 12cm), myplot);
#     end
# #         
# #         loglog(x=eps_accuracy_reciprocal,ratios,'x-','LineWidth',1.15);
# #         hold on;
# #         
# #         % curve 2: the upper limit possible with all n
# #         nsize = n(i)/((1/(1-p)) * (d(i)^(1/p)-d(i)));
# #         loglog(eps_accuracy_reciprocal,...
# #             nsize*ones(size(eps_accuracy_reciprocal)),...
# #             'r--','LineWidth',1.15);
# #         hold on;
# #         
# #         % curve 3: yvalue fixed = 1/(1-alpha)
# #         val2 = 1/(1-alpha(j));
# #         loglog(eps_accuracy_reciprocal,...
# #             val2*ones(size(eps_accuracy_reciprocal)),...
# #             'g--','LineWidth',1.15);
# #         hold on;
# #         
# #         % curve 4: yvalues = (1/eps)^(1/(1-alpha))
# #         val3 = eps_accuracy_reciprocal.^(1/(1-alpha(j)));
# #         loglog(eps_accuracy_reciprocal,val3,...
# #             'k--','LineWidth',1.15);        
# #        
# #         if j == 1
# #             str = strcat('n = ', num2str(n(i)));
# #             title(str,'FontSize', 15);
# #         end
# #         
# #         if i == 1
# #         str = strcat('\alpha = ', num2str(alpha(j)));
# #         ylabel(str,'FontSize', 15);
# #         end
# #     end
# end

