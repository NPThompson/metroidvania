-- main.lua

-- WHAT IS THIS?
-- N.P.Thompson 2021
-- noahpthomp@gmail.com



-- TODO:

-- factor out viewports




-- brief program architecture, and relevant files:

-- everything you can see and interact with in the game is an 'entity'
require 'entity'

-- the state consists of a graph of rooms and a collection of entities:
--	  entities reference the room they are in and vice-versa
--	  entities can only be in one room at a time
--	  when an entity touches the border of a room, it is transferred to the adjacent room if it exists after testing collisions
require 'room'

-- build a room from a string:
-- #######
-- #.....#
-- #.....#
-- #######
require 'buildmap'


-- the viewport determines what entity to track:
--    everything else is drawn relative to the room that entity is in and the position of that entity in the room

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



_print_msg = ""

printit = function(str)
	_print_msg = _print_msg
end



windowsize = vector.new{640,480}

viewports = { 
	{ target = entity.player()
	 ,canvas = love.graphics.newCanvas(320,240)
	 ,area   = {vector.new{0,0}, windowsize}
	}}
	
viewports[1].target:move(120,120)
	
-- for crisp pixel scaling
viewports[1].canvas:setFilter("nearest", "nearest")
	
-- for debugging
-- press space to start	
step   = false	
dostep = false


	
love.load = function()
	game.rooms.r1 = buildmap.room 
[[
#######...#######
#................
#................
#................
#.............#..
#.....#......#...
#...........#....
#................
#................
#................
#################
]]
	game.rooms.r2 = buildmap.room 
[[
#######...###############################
......##...#.............................
...........#.............................
.........##............................##
.....###................................#
.....#...........#######................#
.....########....##.....##....######....#
.......................................##
......................................###
.....................................####
#########################################
]]
	game.rooms.r3 = buildmap.room 
[[
#################
................#
................#
#...###.........#
#.######.........
#.####...........
#..#########.....
#..#########....#
#........###....#
#...............#
#######...#######
]]
	game.rooms.r4 = buildmap.room 
[[
#################
#...............#
#...............#
#...########....#
..#####.........#
..#...........###
..#..........####
##..###.........#
###....#........#
###...#.....#...#
#######...#######
]]
	room.connect_vertical(   game.rooms.r4, game.rooms.r2)
	room.connect_vertical(   game.rooms.r3, game.rooms.r1)

	room.connect_horizontal( game.rooms.r3, game.rooms.r4)
	room.connect_horizontal( game.rooms.r1, game.rooms.r2)
	
	room.connect_horizontal( game.rooms.r2, game.rooms.r3)
		
	game.rooms.r1:spawn(viewports[1].target)

	sprite.eliza = sprite.load( "eliza.png", 6, 8)
	sprite.blocks = sprite.load("tiles.png", 1, 1)
	
	love.window.setMode( windowsize"wh" )
end



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
	
	-- f3 for debug view
	if key == "f3" then 
		game.draw_hitboxes = not game.draw_hitboxes
	end
	
end



love.update = function(dt)
	
	df.update(dt)
	
	
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



love.draw = function()
	-- draw what each viewport sees to its canvas
	for _, viewport in pairs(viewports) do 
		local target = viewport.target
		if target then
			love.graphics.setCanvas(viewport.canvas)
			love.graphics.clear(0,0,0)
				-- beginning in the room where the target is
				game.draw( target.where
						  -- and centered on the target
						  ,target.position - viewport.area[2]/4)
        end
	end
	
	-- draw viewports to screen
	love.graphics.setCanvas() -- set target to main window
	love.graphics.setColor(1,1,1)
	
	for _, viewport in pairs(viewports) do
		love.graphics.draw(viewport.canvas, 0,0, 0, 2,2)
	end
	
	if step then love.graphics.print("space to step\n esc to resume", 0,0) end
end