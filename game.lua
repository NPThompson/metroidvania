-- game.lua




require 'list'
require 'rect'
require 'df'
require 'room'






game = {
-- =============================================
	-- state variables
	entities = list(),
	rooms    = {},

-- =============================================
	-- entities can be killed without specifying a room, but not spawned without specifying a room
	kill = function(entity)
		game.entities:rm(entity)
		entity.where.entities:rm(entity)
		
		return entity
	end,
	
	-- a note on how updating and testing collisions works:
	-- collision testing only alerts entities to the fact that they are touching one another
	-- an entity may have an action that causes it to react some kinds of entities, this is triggered during update
	-- after the update, the entity 'forgets' that it was touching the other object
	-- (we assume that nothing is touching unless we prove it to be so)
	
	-- so, here's the process:
	--   update everything
	--   forget what was touching what
	--   test to see what is touching what now
	--   repeat	
	update = function(df)
		for e in elems(game.entities) do 
			e:execute_actions(df)
			e.grounded = {below=false,right=false,left=false}		
		end
	end,

	test_collisions = function()
		for _, r in pairs(game.rooms) do 
			r:test_collisions()
		end 
	end,
	
        
	draw_room = function(r, o)
			-- draw room background
			love.graphics.setColor(0,0.06,0.1)
			love.graphics.rectangle("fill", -o.x, -o.y, r.tiles.size[1] * r.tile_size, r.tiles.size[2] * r.tile_size)
			love.graphics.setColor(1,1,1)
			
			-- draw tiles
			local tilepos = (vector.new(o) * -1)
			for x = 0, r.tiles.size[1] do
				for y = 0, r.tiles.size[2] do 
					if r.tiles(x,y) ~= r.tiles.default then 
						sprite.blocks:draw(0,0, (tilepos - vector.new{1,1} * (r.tile_size/2))"xy")	
					end
				tilepos.y = tilepos.y + r.tile_size
				end
			tilepos.x = tilepos.x + r.tile_size
			tilepos.y = -o.y
			end
			
			-- draw entities
			for e in elems(r.entities) do 
				game.draw_entity(e, e.position - o)
			end
	
	end,
	
	
	
	draw = function(center_room, origin)
		local traversed   = {}
		local to_draw     = { {room = center_room, translation = origin} }
		local depth       = 3
		local view_rect = {0,0,320,240}
		
			while depth > 0 and #to_draw > 0 do
				for _, draw_it in pairs(to_draw) do 
					-- draw all in queue
					traversed[draw_it.room] = true
					
					-- add neighbors to next iteration
					for dir, door in pairs(draw_it.room.doors) do 
						if door.destination and not traversed[door.destination] then 
						to_draw[#to_draw+1] = 
								{
									room        = door.destination,
									translation = door.translation + draw_it.translation -- origin
								}
						end
					end
				end			
				depth = depth - 1			
			end
			
			-- draw all in reverse order, so that the closest rooms appear over the furthest
			local i = #to_draw
			while i > 0 do  
				game.draw_room(to_draw[i].room, to_draw[i].translation)
				i = i - 1
			end			
	end,
	
	draw_entity = function(entity, where)		
		love.graphics.setColor(1,1,1)
		
		if entity.sprite then 
			sprite[entity.sprite]:draw(entity.frame.col or 0
									  ,entity.frame.row or 0
									  ,where"xy")
		end 
	end,
}-- end game table