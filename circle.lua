-- circle.lua



circle = 
{
    new = function(pos, rad)
        local rv = { pos = pos, rad = rad }
        setmetatable(rv, circle)
        return rv
    end,
    
    overlap = function(a,b)
        local x = abs(a.pos.x - b.pos.x)
        local y = abs(a.pos.y - b.pos.y)
        
        return sqrt(x*x + y*y) - (b.rad + a.rad)
    end
}