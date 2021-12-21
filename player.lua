-- player.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com



local torso_frame = function(aim)
    if aim < -0.1 then return 1 end 
    
    if aim >  0.1 then return 2 end 
    
    return 0
end



player = {
    control = function(bindings)
        return function(entity, frames)
            if entity.grounded.below then 
                for f = 1,frames do 
                    entity.velocity = entity.velocity * (1 - entity.friction)
                end
            end
            
            if love.keyboard.isDown(bindings.up) then 
                entity.aim = min(entity.aim + 0.05, 1)
            end
            
            if love.keyboard.isDown(bindings.down) then 
                entity.aim = max(entity.aim - 0.05, -1)
            end
            
            if (entity.grounded.below or entity.grounded.left) and love.keyboard.isDown(bindings.left)    then
                entity.velocity = entity.velocity + (unit.left * entity.acceleration * frames)
                entity.facing_right = false
            end

            if (entity.grounded.below or entity.grounded.right) and love.keyboard.isDown(bindings.right) then
                entity.velocity = entity.velocity + (unit.right * entity.acceleration * frames)
                entity.facing_right = true
            end

            if love.keyboard.isDown(bindings.jump) and entity.timers.jump == 0 then
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
    
    draw = function(entity, where)
        -- draw legs         
        sprite[entity.sprite]:draw(   1
                                     ,0
                                     ,where.x
                                     ,where.y
                                     ,not entity.facing_right)

        -- draw torso
        sprite[entity.sprite]:draw(   0
                                     ,torso_frame(entity.aim)
                                     ,where.x
                                     ,where.y
                                     ,not entity.facing_right)
    end,
    
    new = function()
        local rv = entity.new 
          { acceleration = 1
           ,sprite       = "cybot"
           ,friction     = 0.3
           ,class        = {entity = true, player = true}
           ,timers       = {jump = 10}
           ,hitbox       = hitbox.rect{-6,-10, 6,18}
           ,draw         = player.draw
           ,facing_right = true
           ,aim          = 0.0    -- 1 = up, -1 = down, 0 = forward facing
          }
        
        -- slide off walls
        rv:reaction( 'wall', react.slide )
        
        rv:action( action.translate
                  ,player.control{ left = "left", up = "up", down = "down", right = "right", jump = "z", fire = "x"} 
                  )
        return rv
    end

}