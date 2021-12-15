-- react.lua



-- a table of reactions to things

-- prototype:
--  react( <this entity>,  <foreign entity>, <collision data> )

-- In general, reactions should only write to <this entity>



require 'sound'



react =
{
    -- removes from existence
    kill = function(this)
        this.where:kill(this)
        sound.play('coin', 0.05)
    end,
    
    slide = function(e, other_e, collision)
        local max_col = e.collisions[1].data
        
        for _, col in pairs(e.collisions) do 
            local data = col.data 
            if rect.area(max_col) < rect.area(data) then 
                max_col = data
            end
        end

        resolve_collision(e, max_col)
        
        local old_collisions = e.collisions
        e.collisions = {}
        
        for _, col in pairs(old_collisions) do
            local new_col = e:collision(col.other)
            if new_col then e:append_collision( new_col, col.other ) end
        end
        
        max_col = e.collisions[1].data
        
        for _, col in pairs(e.collisions) do 
            local data = col.data 
            if rect.area(max_col) < rect.area(data) then 
                max_col = data
            end
        end

        resolve_collision(e, max_col)
        
        e.collisions = {}
    end
}



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
    local dx,dy = abs( collision[3] - collision[1]), abs( collision[4] - collision[2])
    
    if dx > dy then 
        dx = 0 
    else 
        dy = 0
    end
    
    if math.abs(e.velocity.x) > 0.05 then 
        dx = dx * -signum(e.velocity.x)
    else
        dx = dx *  signum(e.position.x - collision[1])
    end
    
    if math.abs(e.velocity.y) > 0.05 then 
        dy = dy * -signum(e.velocity.y)
    else
        dy = dy *  signum(e.position.y - collision[2])
    end
    
    move_and_ground_entity(e, dx,dy)
end


