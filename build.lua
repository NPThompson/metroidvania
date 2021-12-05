-- build.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com



require 'room'



build = 
{   
    char_code = 
    {
        [35] = true
    },
    
    spawn_code = 
    {
        ['0'] = entity.coin
    },
    -- returns a room derived from the input string
    -- text represents a grid of 16x16 tiles
    -- a '#' is a solid tile, a '.' is an empty one
    -- newlines indicate 'next row'
    -- the size of the room is calculated based on the input string
    room = function(str, spawn_code)
        spawn_code = spawn_code or build.spawn_code 

        local x,y = 1,1
        
        local rv = room.new(vector.new{0,0})
        rv.tiles = grid.new()
        rv.tile_size = 16
        
        local ch 
        local set_ch = 0
        
        for i = 1,str:len() do 
            ch = str:byte(i)
            
            -- new row
            if ch == 10 then -- 10 == '\n'
                y = y + 1
                x = 0
            else                
                -- spawn if a '#'
                set_ch = build.char_code[ch] 
                if set_ch then 
                    rv.tiles:set(x,y,true)
                else
                    -- spawn entity
                    if spawn_code[ch] then 
                        local new_entity = spawn_code[ch]()
                        new_entity:move(x * rv.tile_size, y * rv.tile_size)
                        rv:spawn(new_entity)
                    end
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
#.....0.............
#.............#.....
#.....#......#......
#...........#.......
#...................
#.0.................
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
#...########..0.#
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


-- init spawn codes 
for k, v in pairs(build.spawn_code) do 
    build.spawn_code[ k:byte(1) ] = v
    build.spawn_code[ k ] = nil
end