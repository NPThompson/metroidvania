-- collision.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com



require 'util'



move_and_ground_entity = function(e,dx,dy)
    e:move(dx,dy)
    if dx ~= 0 then e.velocity.x = 0 end
    if dy ~= 0 then e.velocity.y = 0 end
    if dy < 0 then e.grounded.below = true end
    if dx < 0 then e.grounded.right = true end
    if dx > 0 then e.grounded.left = true end
end

greater_collision_area = function(c1,c2)
    if c1.overlap[1] * c1.overlap[2] > c2.overlap[1] * c2.overlap[2] then 
        return c1 
    else 
        return c2 
    end
end

resolve_collision = function(e, collision)
    local dx,dy = collision.overlap[1], collision.overlap[2]
    
    if dx > dy then 
        dx = 0 
    else 
        dy = 0
    end
    
    if math.abs(e.velocity.x) > 0.05 then 
        dx = dx * -signum(e.velocity.x)
    else
        dx = dx * signum(e.position.x - collision.x)
    end
    
    if math.abs(e.velocity.y) > 0.05 then 
        dy = dy * -signum(e.velocity.y)
    else
        dy = dy * signum(e.position.y - collision.y)
    end
    
    move_and_ground_entity(e, dx,dy)
end


