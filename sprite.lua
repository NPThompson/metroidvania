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
		
		rv.draw = function(spr,r,c,x,y,flip)
			spr.quad:setViewport(c * spr.framew
								,r * spr.frameh
								,spr.framew
								,spr.frameh
								,spr.w
								,spr.h
								)
            if flip then 
                love.graphics.draw( spr.image
                                   ,spr.quad
                                   ,math.floor(x + (spr.framew/2))
                                   ,math.floor(y - (spr.frameh/2))
                                   ,0
                                   ,-1 -- -1 x scale
                                   ,1) -- 1  y scale
            else 
                love.graphics.draw( spr.image
                                   ,spr.quad
                                   ,math.floor(x - (spr.framew/2))
                                   ,math.floor(y - (spr.frameh/2)))
            end
        
        end
		
		return rv
	end
}