-- player.lua

-- code for player controls and the submarine



require"sprite"



torpedo = function(p, v)
	local rv = 
	{   sprite       = sprite.spritesheet( sprite.items )
	   ,velocity     = v
	   ,position     = p
	   ,duration     = 40
       ,update = function(this, df)
			this.position = this.position + this.velocity	
			this.sprite:position(this.position)
			this.duration = this.duration - df
			if this.duration <= 0 then kill(this) end
		end
	}
	
	rv.sprite:frame(0,0)
	
	return rv
end



submarine = function(args)
	local rv = 
	{   sprite       = sprite.spritesheet( sprite.misc )
	   ,velocity     = vec2(0,0)
	   ,position     = vec2(0,0)
	   ,acceleration = 0.3
	   ,friction     = 0.1
	   ,angle        = 0 
	   ,torp_timer	 = 0
       ,update = function(this, df)
			if window:key_down "left"  then
				this.velocity = this.velocity + vec2(-1,0) * this.acceleration
			end

			if window:key_down "right" then
				this.velocity = this.velocity + vec2(1,0) * this.acceleration
			end

			if window:key_down "down"  then
				this.velocity = this.velocity + vec2(0,-1) * this.acceleration
			end

			if window:key_down "up"    then
				this.velocity = this.velocity + vec2(0,1) * this.acceleration
			end
			
			if window:key_down "space" then 
				if this.torp_timer <= 0 then 
					spawn(torpedo(this.position + vec2(6,-1), vec2(1,0)))
					this.torp_timer = 100
				end				
			end

			if this.torp_timer > 0 then
				this.torp_timer = this.torp_timer - 1
			end
			
			this.velocity = this.velocity * (1 - this.friction)
			this.position = this.position + this.velocity
			
			this.sprite:position(this.position)
		end
	}
	return rv
end	
