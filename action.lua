-- action.lua

-- platformer game
-- N.P.Thompson 2021


require "space"



action= 
{
	-- entity moves through space, determined by velocity
	translate  = function(entity, frames)		
		entity:move((entity.velocity * frames)"xy")
	end,
	
	-- object moves about in four directions
	move_controls = function(bindings)
		return function(entity, frames)
		    
			if entity.grounded.below then 
				for f = 1,frames do 
					entity.velocity = entity.velocity * (1 - entity.friction)
				end
			end
			
			-- if love.keyboard.isDown(bindings.right) then
				-- entity.velocity = entity.velocity + (space.right * entity.acceleration * frames)
			-- end
			-- if love.keyboard.isDown(bindings.up) then
				-- entity.velocity = entity.velocity + (space.up * entity.acceleration * frames)
			-- end
			-- if love.keyboard.isDown(bindings.down) then
				-- entity.velocity = entity.velocity + (space.down * entity.acceleration * frames)
			-- end
			-- if love.keyboard.isDown(bindings.left) then
				-- entity.velocity = entity.velocity + (space.left * entity.acceleration * frames)
			-- end
			if (entity.grounded.below or entity.grounded.left) and love.keyboard.isDown(bindings.left)    then
				entity.velocity = entity.velocity + (space.left * entity.acceleration * frames)
			end

			if (entity.grounded.below or entity.grounded.right) and love.keyboard.isDown(bindings.right) then
				entity.velocity = entity.velocity + (space.right * entity.acceleration * frames)
			end

			if love.keyboard.isDown(bindings.up) and entity.timers.jump == 0 then
				if entity.grounded.below then 
					entity.velocity = entity.velocity + (space.up * 10)
					entity.timers.jump = 10
				end
			end
		
			for f = 1,frames do 
				entity.velocity.y = math.min(entity.velocity.y + 0.9, 4)
			end
		
		end
	end
}