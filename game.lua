-- game.lua


-- metroidvanian game
-- N.P.Thompson 2021 (MIT license)




-- game contains all state and subroutines for updating said state



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
} -- end game table