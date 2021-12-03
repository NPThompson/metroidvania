-- main.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com






-- brief program architecture, and relevant files:

-- everything you can see and interact with in the game is an 'entity'
require 'entity'

-- the state consists of a graph of rooms and a collection of entities:
--    entities reference the room they are in and vice-versa
--    entities can only be in one room at a time
--    when an entity touches the border of a room, it is transferred to the adjacent room if it exists after testing collisions
require 'room'

-- build maps 
-- build rooms from strings like this:
-- #######
-- #.....#
-- #.....#
-- #######
require 'build'


-- the viewport determines what entity to track:
--    everything else is drawn relative to the room that entity is in and the position of that entity in the room
require 'view'



-- updating the state of each entity is done once for every entity by iterating the list of entities
--    and with respect to the number of elapsed frames
-- testing collisions between entities is done once per room on all entities in the room,
--    by iterating the list of rooms (not by following the graph)
require 'game'

-- converts elapsed time into standard-length slices of time called frames
-- each frame equal to 1/60 a second
-- update passes the number of frames along to the entity update method and its actions
-- collision testing ignores the number of elapsed frames
require 'df'


-- sprites support drawing specific subimages (called frames) from a large image (the sprite)
-- entities do not reference sprites directly, instead using a string 
require 'sprite'



love.load = function()
    -- builds a basic map for debugging
    build.map(game.rooms)
    
    -- init graphics
    sprite.eliza  = sprite.load( "eliza.png", 6, 8)
    sprite.blocks = sprite.load( "tiles.png", 1, 1)
    
    love.window.setTitle("metroidvania")
    view.init(640,480)
    
    -- spawn player
    p1 = entity.player()
    p1:move(120,120)
    
    game.rooms.r1:spawn(p1)
    view.set_target(p1)
end



-- main loop
love.update = function(dt)
    
    df.update(dt)
    
    -- for running frame-by-frame
    if not step then 
        frames = df.get()
    else if dostep then  
            frames = 1
            dostep = false
        else frames = 0
        end
    end
    
    
    if frames > 0 then 
        game.update(frames)
        game.test_collisions()
    end
    
    df.reset()
end



-- for debugging
-- press space to start 
step   = false  
dostep = false

    

love.keypressed = function(key, scancode, isrepeat)
    if key ==  "escape" then
        if step then step = false 
    else 
        love.event.quit(0) end
    end

    -- space for frame-by-frame analysis
    if key == "space" then 
        if step then dostep = true 
        else
            step = true 
        end
    end
end



love.draw = function()
    view.draw() -- draw what each viewport sees to its canvas
    
    if step then love.graphics.print("space to step\n esc to resume", 0,0) end
end