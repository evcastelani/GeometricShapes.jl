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
This function is a constructor of a GAImage type
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
	return A.coords[1:2:lenght(A.coords)]
end

"""
This is the main function and it is used to detect a shape
from a GAImage type. We need to setup vote_bound and precision.
"""
function detect(A::GAImage,regs::RegisteredShape,vote_bound=50,ε=0.01)
	nGAob = length(regs.GAobjects)
	nGAim = length(A.coords)
	vot = zeros(nGAob)
	for i=1:1:nGAob
		for j:1:1:nGAim
			#M = Liga.inner(A.coords[j],regs.GAobjects[i])
			#if norm(M.comp,inf)<ε
			#	vot[i] += 1
			#end
		end
	end
	detc = findall(t -> t>vote_bound, vot)
	return regs.GAobjects[detc]
end

"""
This function automates build some RegisteredShape
"""
function register(tobj::String,dim::Int,space::String,addinfo::Vector{Any})
	if tobj = "plan" && dim == 2 && obs[2] == "Conformal"
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
end
end # module
