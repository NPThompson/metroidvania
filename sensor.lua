-- sensor.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com



-- what's a sensor?

-- a sensor is a discount collider. It can 'ping' the 
-- local room (entity.where) for entities, filter these 
-- by class, detect a collision, distance, or other 
-- measurement, and notify it's owning entity.

-- as an example, a monster might have a sensor with an 
-- arc hitbox, where the angle is determined by it's view
-- angle and the distance and arc by it's 'awareness'. if
-- the player wanders into that arc, the monster becomes
-- aggressive.

-- benefits of sensors

-- sensors can be added to and removed from entities on 
-- the fly, changing their behaviour.
-- Also, since sensors are not entities, they do not add 
-- any collisions to the number already being considered.
-- If there are N entities in a room, and a sensor is 
-- pinged, it will make N tests. If you add another one,
-- it will also make N tests. Whereas if you added a new
-- entity, you would make N+1 tests.
-- Further, sensors do not have to ping every frame. they
-- can be pinged based on conditional events, or every 
-- few frames, or whatever.

-- why sensors?

-- I was planning to give colliders multiple hitboxes and 
-- different reactions associated with different hitboxes 
-- and classes, but that would have been difficult and 
-- error-prone to code, so I asked myself why I wanted
-- that feature. 
-- I wanted the player to be 'grounded' whenever he was 
-- touching a wall, allowing him to move. But because the
-- avatar slides off the wall every frame, it was hit-or-
-- miss as to when they'd be grounded. So I wanted an 
-- extra, slightly lower box to detect walls, and this 
-- would set the grounded flag whenever it detected a
-- wall.
-- I couldn't think of any other significant uses for the 
-- advanced collider features, so decided to go with some
-- thing simpler: Sensors.
 
sensor = 
{
    new = function(hitbox, entity, reaction)
        local rv = { hitbox   = hitbox,
                     entity   = entity, 
                     reaction = reaction }
        setmetatable(rv, sensor)
        return rv
    end,
    
    -- hitbox relative to entity position
    sync = function(s)
        local hb = rect.new(s.hitbox)
        hb:move( s.entity.position.x, s.entity.position.y )
        -- detect collision
    end,
    
    ping_room = function( hitbox, room )
        local collisions = {}
        for e in elems(room.entities) do 
            local col = hitbox:test(e.hitbox)
            if col then 
                collisions[#collisions+1] = {col, e}
            end
        end
        return collisions
    end,
    
    -- 
    ping = function(s)
        s:sync()
        local detection = s:filter()
        
        if #detection > 1 then 
            -- ... ?    
        end
    end,
    
}