-- unit.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com



-- defines units of time and space



require"vector"



unit=
{
     seconds_per_frame = 1/60
    
    -- computes the elapsed number of frames given so many elapsed seconds
    -- keeps track of any remainder and feeds it into the next computation
    ,delta_frames = function(dt)
        local df = 0
        _df_time_accumulator = _df_time_accumulator + dt
        
        -- quotient returns the quotient and remainder
        -- see util for definition of quotient
        df, _df_time_accumulator = quotient( _df_time_accumulator, unit.seconds_per_frame )
        
        return df
    end

    -- world coordinates and screen coordinates are oriented in the same way:
    -- +x is right 
    -- +y is down
   ,up   = vector.new { 0,-1 }
   ,down = vector.new { 0, 1 }
   ,left = vector.new {-1, 0 }
   ,right= vector.new { 1, 0 }
}

-- helper variables
_df_time_accumulator = 0