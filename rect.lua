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
    overlap = function( Ax1, Ay1, Ax2, Ay2, Bx1, By1, Bx2, By2 )
        -- rectangle assignment
        if not Ax2 then 
            local r,s = Ax1,Ay1
            return rect.overlap( r[1], r[2], r[3], r[4], s[1], s[2], s[3], s[4])
        else
            return max(Ax1,Bx1)
                  ,max(Ay1,By1)
                  ,min(Ax2,Bx2)
                  ,min(Ay2,By2)
        end
    end,
    
    -- x1,y1 should be the upper-left corner, x2,y2 the lower-right corner
    -- otherwise not a valid rectangle. for collision detection, if the 
    -- overlap is not a valid rectangle, no collision ocurred.
    valid = function(x1,y1,x2,y2)
        return x2 >= x1 and y2 >= y1
    end,
    
    area = function(x1,y1,x2,y2)
        return (x2-x1) * (y2-y1)
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
}