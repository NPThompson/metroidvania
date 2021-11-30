-- util.lua

reduce = function(array, operator)
	
	local rv = array[1]
	local i = 2 
	local length = #array

	while i <= length do 
		rv = operator(rv, array[i])
		i = i + 1
	end 
	
	return rv
end