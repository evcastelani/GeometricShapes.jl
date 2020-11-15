module GeometricShapes

using LinearAlgebra, Liga, DelimitedFiles

"""
This type provides a list of objects, plans, circle, spheres, etc 
which can be used to detect the desired shape. The performance of the 
detection depend on the number of objects in list. Consequently, a 
good performance is obtained when we get a smart list. Is important 
to note that the element of the list is a MultiVector. 
"""
struct RegisteredShape
	id :: String
	layout :: Vector{Any}
	GAobjects :: Vector{MultiVector}
	dimension :: Int64
end

"""
This type is a MultiVector of embedded points of R^n. It is the 
representation of an image like a vector of MultiVectors.
"""
mutable struct GAImage
	coords :: Vector{MultiVector}
#	bound :: Vector{Int64} 
end

"""
This function is a constructor of a GAImage type. This depends of 
a defined GA enviromment, so it is recommended run the register 
function before. 
	
	Example:

	julia> image = GeometricShapes.gaimage("quadrado.txt");

"""
function gaimage(file::String)
	A = readdlm(file)
	dim = length(A[1,:])
	vm = Vector{MultiVector}(undef,length(A[:,1]))
	for j=1:1:length(A[:,1])
		vm[j] = embedding(A[j,1:dim])
	end
#	bd = zeros(Int,dim)
#	for i=1:dim
#		bd[i] = maximum(A[:,i])
#	end
	return GAImage(vm)
end

"""
This function is a filter to a GAImage type. The argument of this 
function is a GAImage and it return a smaller GAImage with strike
points. The quality these strike points allows the voting system
improve the perfomance. New strategies to get others strike points 
can be used.
"""
function uniform_selection(A::GAImage)
	# need to code!
	return GAImage(A.coords[1:2:length(A.coords)])
end

function uniform_selection2(A::GAImage)
	k = 1
	store_index = [1]
	choose = rand([1,2,3,4,5])
	while k+choose<length(A.coords)
		push!(store_index,k+choose)
		k = k+choose
		choose = rand([1,2,3])
	end
	return GAImage(A.coords[store_index])
end



"""
This is the main function and it is used to detect a shape
from a GAImage type. We need to setup vote_bound and precision.

	Example

	julia> obj = GeometricShapes.detect(image,plans,50,0.5)

	returns a vector obj which contains each detected object.

"""
function detect(A::GAImage,regs::RegisteredShape,vote_bound=50,ε=0.01)
	nGAob = length(regs.GAobjects)
	nGAim = length(A.coords)
	vot = zeros(nGAob)
	for i=1:1:nGAob
		for j=1:1:nGAim
			M = Liga.inner(regs.GAobjects[i],A.coords[j])
			if norm(M.comp,Inf)<ε
				vot[i] += 1
			end
		end
	end
	detc = findall(t -> t>vote_bound, vot)
	return regs.GAobjects[detc]
end

"""
This function automates build some RegisteredShape

	Example

	julia> GeometricShapes.register("plan",2,"Conformal",Any[400,400])

"""
function register(tobj::String,dim::Int,space::String,addinfo::Vector{Any})
	if tobj == "plan" && dim == 2 && space == "Conformal"
		layout(3,1,"Conformal")
		P = []
		lv = addinfo[1]
		lh = addinfo[2]
		θbound = round(Int,(180/pi)*atan(lv/lh))
		for θ = 0:1:θbound
			nx = cos(θ*π/180.0)
            		ny = sin(θ*π/180.0)
                	tam = lh/cos(θ*π/180.0)
			for α = 1:tam
				P = push!(P,multivector([nx,ny]) + α*e∞)
			end
	    	end
		for θ = θbound+1:1:90
			nx = cos(θ*π/180.0)
            		ny = sin(θ*π/180.0)
                	tam  = lv/sin(θ*π/180.0)
			for α = 1:tam
				P = push!(P,multivector([nx,ny]) + α*e∞)
			end
	    	end
		return RegisteredShape(" line ",[3,1,"Conformal"],P, 2)
	end
	if tobj == "circle" && dim ==2 && space == "Conformal"
		layout(3,1,"Conformal")
		Sph = []
		lv = addinfo[1]
		lh = addinfo[2]
		for px = 5:lh-5
			for py = 5:lv-5
				for ρ=10:20
					Sph = push!(Sph,embedding(Float64.([px,py]))-0.5*(ρ^2)*e∞)
				end
			end
		end
		return RegisteredShape("circle",[3,1,"Conformal"],Sph,2)
	end
end
end # module
