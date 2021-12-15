-- action.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com



require "unit"



action= 
{
    -- entity moves through space, determined by velocity
    translate  = function(entity, frames)       
        entity:move((entity.velocity * frames)"xy")
    end,
    
    -- object moves about in four directions
    move_controls = function(bindings)
        return function(entity, frames)
            
            if entity.grounded.below then 
                for f = 1,frames do 
                    entity.velocity = entity.velocity * (1 - entity.friction)
                end
            end
            
            if (entity.grounded.below or entity.grounded.left) and love.keyboard.isDown(bindings.left)    then
                entity.velocity = entity.velocity + (unit.left * entity.acceleration * frames)
            end

            if (entity.grounded.below or entity.grounded.right) and love.keyboard.isDown(bindings.right) then
                entity.velocity = entity.velocity + (unit.right * entity.acceleration * frames)
            end

            if love.keyboard.isDown(bindings.up) and entity.timers.jump == 0 then
                if entity.grounded.below then 
                    entity.velocity = entity.velocity + (unit.up * 10)
                    entity.timers.jump = 10
                end
            end
        
            for f = 1,frames do 
                entity.velocity.y = min(entity.velocity.y + 0.9, 4)
            end
        
        end
    end,
    
    animate_player = function(entity, frames)
        -- flip
        if entity.velocity.x > 0.1 then 
            entity.frame.flip = false
        end
        if entity.velocity.x < -0.1 then 
            entity.frame.flip = true
        end
        
        -- jumping?
        if abs(entity.velocity.y) > 2 then 
            entity.frame.row = 1
        else 
            entity.frame.row = 0
            if abs(entity.velocity.x) > 0.3 then
                entity.frame.row = 2
            end
        
        end
    end
}