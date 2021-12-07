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

-- defines units of space and time 
-- and a procedure for computing elapsed frames (unit.delta_frames(dt))
require 'unit'

-- sprites support drawing specific subimages (called frames) from a large image (the sprite)
-- entities do not reference sprites directly, instead using a string 
require 'sprite'



love.load = function()
    -- builds a basic map for debugging
    build.map(game.rooms)
    
    -- init graphics
    sprite.eliza  = sprite.load( "eliza.png", 6, 8)
    sprite.blocks = sprite.load( "tiles.png", 1, 1)
    sprite.coin   = sprite.load( "coin.png",  1, 1)
    
    love.window.setTitle("metroidvania")
    view.init(640,480)
    
    -- init audio
    sound.coin = love.audio.newSource('coin.wav', 'static')

    -- spawn player
    p1 = entity.player()
    p1:move(120,120)
    
    game.rooms.r1:spawn(p1)
    view.set_target(p1)
 end



-- main loop
love.update = function(dt)
    local frames = unit.delta_frames(dt)
    
    if frames > 0 then 
        game.update(frames)
        game.test_collisions()
    end
end


    

love.keypressed = function(key, scancode, isrepeat)
    if key ==  "escape" then
        love.event.quit(0) 
    end
end



love.draw = function()
    view.draw() -- draw what each viewport sees to its canvas
end