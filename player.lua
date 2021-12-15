-- player.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com



entity_player = function()
    local rv = entity.new 
      { acceleration = 1
       ,sprite       = "eliza"
       ,friction     = 0.3
       ,class        = {entity = true, player = true}
       ,timers       = {jump = 10}
       ,hitbox       = hitbox.rect{-6,-10, 6,18}
      }
    
    -- slide off walls
    rv:reaction( 'wall', react.slide )
    
    rv:action( action.translate
              ,action.move_controls{ left = "left", up = "up", down = "down", right = "right"} 
              ,action.animate_player)
    return rv
end