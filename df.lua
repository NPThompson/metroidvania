-- df.lua




-- for calculating elapsed frames
_time_accumulator  = 0
_delta_frames      = 0
_seconds_per_frame = 1/60




-- call update() every iteration to keep current, get() to get elapsed frames, and reset() before next iteration
df = {
	-- keeps track of the elapsed time and converts that to elapsed frames, rounding down
	update = function(dt)
		_time_accumulator = _time_accumulator + dt
		while _time_accumulator > _seconds_per_frame do
			_time_accumulator = _time_accumulator - _seconds_per_frame
			_delta_frames = _delta_frames + 1
		end
	end,
	
	reset = function()
		_delta_frames = 0
	end,

	get = function()
		return _delta_frames
	end
}