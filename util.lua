-- util.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com



max      = math.max
min      = math.min
abs      = math.abs
floor    = math.floor
ceil     = math.ceil

signum   = function(x) 
    if x > 0 
        then return  1 
        else return -1 
    end 
end
 
quotient = function(x,y)
    return floor(x/y), x % y
end



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