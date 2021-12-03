-- build.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com



require 'room'



build = 
{   -- returns a room derived from the input string
    -- text represents a grid of 16x16 tiles
    -- a '#' is a solid tile, a '.' is an empty one
    -- newlines indicate 'next row'
    -- the size of the room is calculated based on the input string
    room = function(str)
        local x,y = 1,1
        
        local rv = room.new(vector.new{0,0})
        rv.tiles = grid.new()
        rv.tile_size = 16
        
        local ch 
        
        
        for i = 1,str:len() do 
            ch = str:byte(i)
            
            -- new row
            if ch == 10 then -- 10 == '\n'
                y = y + 1
                x = 0
            else                
                -- spawn if a '#'
                if ch == 35 then  -- 35 == #
                    rv.tiles:set(x,y,true)
                end
            end
            -- continue column
            x = x + 1
        end
        
        rv.size = vector.new(rv.tiles.size) * rv.tile_size

        rv:calculate_walls()
        return rv
    end,
    
    map = function(graph)
        graph.r1 = build.room 
[[
#######...##########
#...................
#...................
#...................
#.............#.....
#.....#......#......
#...........#.......
#...................
#...................
#...................
####################
]]
        graph.r2 = build.room 
[[
#######...###############################
......##...#.............................
...........#.............................
.........##............................##
.....###................................#
.....#...........#######................#
.....########....##.....##....######....#
.......................................##
......................................###
.....................................####
#########################################
]]
        graph.r5 = build.room
[[
##################
..................
..................
##################
]]
        graph.r3 = build.room 
[[
####################
...................#
...................#
#...###............#
#.######............
#.####..............
#....#######........
#.......####....####
#........###.......#
#..................#
#######...##########
]]
        graph.r4 = build.room 
[[
#################
#...............#
#...............#
#...########....#
..#####.........#
..#...........###
..#..........####
##..###.........#
########........#
#######.....#...#
#######...#######
]]

        -- connect the rooms
        graph.r4:connect_vertical( graph.r2)
        graph.r3:connect_vertical( graph.r1)

        graph.r3:connect_horizontal( graph.r4)
        graph.r1:connect_horizontal( graph.r2)
        
        graph.r2:connect_horizontal( graph.r5)
        graph.r5:connect_horizontal( graph.r3)                
    end,
    
    map2 = function(graph)
        graph.r1 = build.room
[[
....##..........................
................................
...........###..................
.............####.............#.
#............................##.
##.........................#####
................................
.....###..............##........
...................####.........
...........#.........#..........
..........######................
.###...........#................
...............#................
...............#.##.....####....
................................
]]
    graph.r1:connect_horizontal(graph.r1)
    graph.r1:connect_vertical(graph.r1)
    end
}
