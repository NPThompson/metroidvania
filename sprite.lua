-- sprite.lua



-- drawing coordinates too are centered 
sprite= {
	load = function(src, rows, cols)
		local rv = {}
		
		rv.image = love.graphics.newImage(src)
		
		-- quad state changes on every call to draw
		rv.quad  = love.graphics.newQuad(0,0,0,0, rv.image)
		
		-- set frame animation data
		rv.w, rv.h = rv.image:getDimensions()
		rv.framew, rv.frameh = rv.w/cols, rv.h/rows
		
		rv.draw = function(spr,r,c,x,y)
			spr.quad:setViewport(c * spr.framew
								,r * spr.frameh
								,spr.framew
								,spr.frameh
								,spr.w
								,spr.h
								) 
			love.graphics.draw(spr.image, spr.quad, math.floor(x - (spr.framew/2)), math.floor(y - (spr.frameh/2)))
		end
		
		return rv
	end
}