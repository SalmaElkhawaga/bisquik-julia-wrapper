# plotting data from the count of nonzeros
#####################################################
function plot_data(NNZEROS)
using Gadfly
# Generate Data to plot
cols = size(NNZEROS,3);
rows = size(NNZEROS,2);
eps_accuracy = [1e-1, 1e-2, 1e-3, 1e-4];
eps_accuracy_reciprocal = 1./eps_accuracy;
for i = 1 : 1 #cols
    for j = 1 : 1 #rows
    	c = NNZEROS[:,j,i];
 		# subplot(rows,cols,(j-1)*cols+i, 'XScale', 'log', 'YScale', 'log')
	 	ratios = c./((1/(1-p)) * (d[i]^(1/p)-d[i]));
 		nsize = n[i]/((1/(1-p)) * (d[i]^(1/p)-d[i]));
 		yval = nsize*ones(length(eps_accuracy_reciprocal),1); 
 		val3 = eps_accuracy_reciprocal.^(1/(1-alpha[j]));
 				
		# curve 1: actual non zeros
		# curve 2: the upper limit possible with all n independent of eps_accuracy
		# curve 3: RHS: yvalues = (1/eps)^(1/(1-alpha))
		 

		myplot = plot(layer(x = eps_accuracy_reciprocal, 
						y = ratios, 
						#Geom.line #,Theme(line_width=1pt, default_color=color("orange"))
						Geom.point, Geom.line, Scale.x_log10, Scale.y_log10, Theme(default_color=color("blue"))
						),
					layer(x = eps_accuracy_reciprocal,
							y = yval,
							# Geom.point #, Theme( default_point_size=1mm, default_color=color("green"))
							Geom.point, Geom.line, Scale.x_log10, Scale.y_log10, Theme(default_color=color("red"))
							)
# 					layer(x = eps_accuracy_reciprocal,
# 							y = val3,
# 							Geom.point #, Theme( default_point_size=1mm, default_color=color("green"))
# 							# Geom.line, Scale.x_log10, Scale.y_log10
# 							)
							)
		println("Saving plot $i$j");
		draw(PDF(join(["plot", string(i), string(j),".pdf"]), 16cm, 12cm), myplot);
    end
end

end