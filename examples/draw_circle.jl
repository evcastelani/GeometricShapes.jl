using DelimitedFiles, PyPlot, Liga
function draw_circ(file,S)
	ax=gca()
	ax.axis("equal")
	pts = readdlm(file)
	plot(pts[:,1],pts[:,2],".b")
	for i=1:length(S)
		c = [S[i].comp[2],S[i].comp[3]]
		S[i] = S[i]∘(inverse(inner(-1.0*S[i],e∞)))
		S[i] = S[i]∘S[i]
		ρ = sqrt(S[i].comp[1])
		xp = zeros(360)
		yp = zeros(360)
		for θ=1:360
			xp[θ] = c[1]+ρ*cos(θ*π/180)
			yp[θ] = c[2]+ρ*sin(θ*π/180)
		end
		plot(xp,yp,"-r")
	end
end
