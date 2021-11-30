-- line.lua



require'vector'



line = {
	__tostring = function(seg)
		return 'line: ' .. tostring(seg[1]) .. ', ' .. tostring(seg[2])
	end,

	vertical = function(seg)
		return seg[1].x == seg[2].x
	end,
	
	horizontal = function(seg)
		return seg[1].y == seg[2].y
	end,
	
	-- returns nil if the two lines do not touch
	-- or a 2d point representing where they touch	
	touch = function( seg1, seg2 )
		if not rect.overlap(rect.new(seg1[1],seg1[2]), rect.new(seg2[1], seg2[2])) then return nil end
		
		-- other cases:
		-- parallel lines    --> auto true. pick midpoint? (already in same rectangle, ergo must touch)
		if seg1:vertical()   and seg2:vertical() 
		or seg1:horizontal() and seg2:horizontal() 
		then return figure.avg_point{seg1[1], seg1[2], seg2[1], seg2[2]} 
		end
		
		-- general case:
		-- using y=mx+b, compute intercept
		
		-- slopes are easy, b is given by
		-- b = y-mx
		local m1 = seg1:slope()
		local m2 = seg2:slope()
				
		local b1 = seg1[1].y - m1 * seg1[1].x
		local b2 = seg2[1].y - m2 * seg2[1].x
		
		-- computing the intercept involves a little algebra
		-- we'll start with finding x
		
		-- since x must satisfy both the first and second equations,
		-- we can set them equal:
		-- y1 == m1 * x1 + b1
		-- y2 == m2 * x2 + b2
		
		-- => let y1 == y2 and x1 == x2, then:
		-- y == m1 * x + b1
		-- y == m2 * x + b2
		-- substitute for y:
		-- m1 * x + b1 == m2 * x + b2
		-- m1 * x == m2 * x + b2 - b1
		-- m1 * x - m2 * x == b2 - b1
		-- x(m1 - m2) == b2 - b1
		-- x == (b2 - b1)/(m1 - m2)
		
		-- once x is found, we can check to see if it is in bounds
		-- for both line segments. if it is, y must also be in 
		-- bounds for both, and can be easily computed since we 
		-- know x.
		local x_intercept = (b2 - b1)/(m1 - m2)
		
		return vector.new{x_intercept, m1 * x_intercept + b1}
	end,
	
	slope = function(seg)
		local run = seg[2].x - seg[1].x 
		if run == 0 then return nil else 
			local rise = seg[2].y - seg[1].y
			return rise/run
		end
	end,
	
	-- assumed q1 begins at 0,0
	-- equal to q1 rotated left 90 degrees
	normal = function(seg,reverse_order)
		local q
		if reverse_order then 
			q = seg[1] - seg[2]
		else 
			q = seg[2] - seg[1]
		end
		return vector.new{-q.y,q.x}
	end,
		
	new = function(p,q,r,s)
		local rv = {}
		if not r then 
			rv = {p,q}
		else 
			rv = {vector.new{p,q}, vector.new{r,s}}
		end
		setmetatable(rv,line)
	
		return rv
	end
}-- end line
line.__index = line