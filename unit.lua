-- unit.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com



-- defines units of time and space



require"vector"



unit=
{
    seconds_per_frame = 1/60
    
    -- dt in seconds
    ,delta_frames = function(dt)
        local df = 0
        _df_time_accumulator = _df_time_accumulator + dt
        while _df_time_accumulator > unit.seconds_per_frame do
            _df_time_accumulator = _df_time_accumulator - unit.seconds_per_frame
            df = df + 1
        end
        return df
    end
    
   ,up   = vector.new{0,-1}
   ,down = vector.new{0,1}
   ,left = vector.new{-1,0}
   ,right= vector.new{1,0}
}

_df_time_accumulator = 0