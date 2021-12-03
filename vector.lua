-- vector.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com



require "string"
require "table"



vector = {


mt = 
{
    __add = function(v, w)
        local rv = vector.new(v)
        
        for i, x in ipairs(w) do
            rv[i] = rv[i] + x
        end
        
        return rv
    end,

    __tostring = function(v)
        local rv = '('
        local vlen = #v 
        for i =1, vlen do 
            rv = rv .. tostring(v[i])
            if i < vlen then  
                rv = rv .. ', '
            end
        end
        return rv .. ')'
    end,
    
    __newindex = function(v, key, value)
        if vector.mt[key] then v[vector.mt[key]] = value else
        rawset(v,key,value) end
    end,
    
    __sub = function(v,w)
        local rv = vector.new(v)
        
        for i, x in ipairs(w) do
            rv[i] = rv[i] - x
        end
        
        return rv
    end,
    
    __mul = function(v,s)
        local rv = vector.new(v)
        
        for i = 1, #rv do
            rv[i] = rv[i] * s
        end
        
        return rv       
    end,
    
    __div = function(v,s)
        return v * (1/s)
    end,
    
    -- multiple return swizzle (since __index will only return one value)
    -- v"xy" == x,y
    __call = function(v, i)
        return unpack(v[i])
    end,
    
    -- returns a new vector if swizzled
    -- returns a single element if applied to one value
    __index = function(v, i)
        -- missing values default to 0
        if type(i) ~= "string" then 
            return 0 
        end
        
        -- single chars map to common elements
        if string.len(i) == 1 then 
            return v[vector.mt[i]] 
        end

        -- longer string means swizzle
        local rv = {}
        
        while string.len(i) > 0 do 
            rv[#rv+1] = v[string.sub(i,1,1)]
            i = string.sub(i,2)
        end
        
        return vector.new(rv)
    end,
    
    -- common element notation
    x = 1,
    y = 2,
    z = 3,
    
    u = 1,
    v = 2,
    
    w = 1,
    h = 2
}, -- end vector.mt


-- computes the average point of an array of vectors
average = function(pts)
    local rv = vec{0,0}
    
    local i = 1
    
    for i = 1,#pts do
        rv = rv + pts[i]
    end
    
    return rv/i
end,

new = function(vals)
    local rv = {}
    setmetatable(rv, vector.mt)
    
    for k,v in pairs(vals) do rv[k] = v end

    return rv
end
} -- end vector