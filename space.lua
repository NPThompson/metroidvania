-- space.lua



-- defines up, down, left, right
-- and units of measurement (pixels per second)



require"vector"



space=
{
	up   = vector.new{0,-1}
   ,down = vector.new{0,1}
   ,left = vector.new{-1,0}
   ,right= vector.new{1,0}
}