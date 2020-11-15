using GeometricShapes

line2D(file,vote,dim,space) = begin
	plans = GeometricShapes.register("plan",2,space,Any[dim[1],dim[2]]);
	image = GeometricShapes.gaimage(file);
	@time detecobjs = GeometricShapes.detect(image,plans,vote,0.5) 
end

line2Dfilter1(file,vote,dim,space) = begin
	plans = GeometricShapes.register("plan",2,space,Any[dim[1],dim[2]]);
	image = GeometricShapes.uniform_selection(GeometricShapes.gaimage(file));
	@time detecobjs = GeometricShapes.detect(image,plans,vote,0.5) 
end

circle2D(file,vote,dim,space)= begin
	circles = GeometricShapes.register("circle",2,space,Any[dim[1],dim[2]]);
	image = GeometricShapes.gaimage(file);
	@time detecobjs = GeometricShapes.detect(image,circles,vote,2.5)
end
