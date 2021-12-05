-- rect.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com



-- (coordinates in this game go +x is right, +y is down)
-- a rect is represented as four numbers in sequence:
-- { x1, y1, x2, y2 }
-- these can be collected in an array, but are passed and returned
-- as a comma-separated list
-- where x1,y1 is the upper-left corner and x2,y2 the lower-right
-- x2,y2 are relative to a common origin, not to the upper-left corner
-- e.g. they represent the point, not the width and height of the rect,
-- the width and height is given by the difference




rect = 
{
    new = function(vals)
        local rv = {vals[1], vals[2], vals[3], vals[4]}
        setmetatable(rv,rect)
        return rv
    end,
    
    move = function(r,dx,dy)
        r[1] = r[1] + dx
        r[2] = r[2] + dy
        r[3] = r[3] + dx
        r[4] = r[4] + dy
    end,
    
    overlap = function( r1, r2 )
        -- rectangle assignment
        return rect.new{ max (r1[1], r2[1])
                        ,max (r1[2], r2[2])
                        ,min (r1[3], r2[3])
                        ,min (r1[4], r2[4])}
    end,
    
    -- x1,y1 should be the upper-left corner, x2,y2 the lower-right corner
    -- otherwise not a valid rectangle. for collision detection, if the 
    -- overlap is not a valid rectangle, no collision ocurred.
    valid = function(x1,y1,x2,y2)
        if not y1 then 
            return rect.valid(x1[1], x1[2], x1[3], x1[4])
        else 
            return x2 >= x1 and y2 >= y1
        end
    end,
        
    area = function(x1,y1,x2,y2)
        if not y1 then 
            return rect.area(x1[1], x1[2], x1[3], x1[4])
        else 
            return (x2-x1) * (y2-y1)
        end
    end,
        
    union = function(r, s)
        return min(r[1],s[1])   
              ,min(r[2],s[2])
              ,max(r[3],s[3])
              ,max(r[4],s[4])
    end,
    
    merge = function(r, s)
        local u = {rect.union(r,s)}
        if rect.area(u[1],u[2],u[3],u[4]) == rect.area(r[1],r[2],r[3],r[4]) + rect.area(s[1],s[2],s[3],s[4])
        then return u else return nil end
    end
    
} rect.__index = rect