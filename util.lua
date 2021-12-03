-- util.lua


signum = function(x) if x > 0 then return 1 else return -1 end end 
max    = math.max
min    = math.min
abs    = math.abs
floor  = math.floor
ceil   = math.ceil



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