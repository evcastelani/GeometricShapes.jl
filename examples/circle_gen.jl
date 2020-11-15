using DelimitedFiles

function circle_gen(dimh,dimv,pcirc,ptotal)
	center = [40,51]
	radius = 11
	x = zeros(Int,ptotal)
	y = zeros(Int,ptotal)
	θ = [0:2.0*π/pcirc:2.0*π;]
	for i=1:length(θ)
		x[i] = round(Int,center[1]+radius*cos(θ[i]))
		y[i] = round(Int,center[2]+radius*sin(θ[i]))
	end
	for i=length(θ)+1:ptotal
		x[i] = rand([1:1:dimh;])
		y[i] = rand([1:1:dimv;])
	end
	datafile= "circ-$pcirc-$ptotal-$dimh-$dimv.txt"
	f=open(datafile,"w")
	for i=1:ptotal
		println(f,x[i]," ",y[i])
	end
	close(f)
end
