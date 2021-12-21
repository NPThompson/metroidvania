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
    
    
}