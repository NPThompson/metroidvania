-- entity.lua



require"vector"
-- actions are performed every frame by entities
require"action"
-- rectangles for collision detection
require"rect"



entity ={
	-- moves position and hitbox of an entity
	move = function(e, dx, dy)
		e.position  = e.position  + {dx,dy}
		e.hitbox[1] = e.hitbox[1] + dx  
		e.hitbox[2] = e.hitbox[2] + dy  
		e.hitbox[3] = e.hitbox[3] + dx  
		e.hitbox[4] = e.hitbox[4] + dy  
	end,
	
	-- performs all the actions in e's list of actions 
	-- execute every cycle of the game
	-- the df argument can take into account frame skips when larger than 1
	execute_actions = function(e,df)
		for _, act in pairs(e.actions) do 
			act(e,df)
		end
		if e.timers then for k,v in pairs(e.timers) do
			e.timers[k] = math.max(e.timers[k] - df,0)
			end
		end
	end,
	
	-- (...) is a list of functions to be executed whenever update() is called
	add_action = function(this,act)
		this.actions[#this.actions + 1] = act
		return this
	end,
	
	rm_action = function(this, the_action)
		for k, act in pairs(this.actions) do
			if act == the_action then 
				this.actions[k] = nil
				return
			end
		end
		return this
	end,

	-- builds an entity
	new = function(args)
		local rv =
		{   actions  = {}
		   ,velocity = vector.new{0,0} 
		   ,position = vector.new{0,0} 
		   ,hitbox   = {-8,-8,8,8}
		   ,frame = { row = 0, col = 0 }
		   ,grounded = {}
		}
		
		for k,v in pairs(args) do 
			rv[k] = v
		end

		setmetatable(rv,entity)
		return rv
	end,


	player = function()
		local rv = entity.new 
		  { acceleration = 1
		   ,sprite       = "eliza"
		   ,friction     = 0.3
		   ,hitbox       = {-6,-10, 6,18}
		   ,type         = "player"
		   ,timers       = {jump = 10}
		  }

		rv:add_action( action.translate )
		rv:add_action( action.move_controls{ left = "left", up = "up", down = "down", right = "right"} )
				
		return rv
	end
} -- end entity
entity.__index = entity