-- room.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com




-- rooms are, perhaps, the most vital part of this kludge,
-- the succulent meatball at the center of this spaghetti,
-- tangled in the starchy threads of several interdependent
-- components of the game.

-- the most important aspect of rooms is collision detection.
-- nothing can collide with another thing except it occupy a
-- shared space, and rooms are that unit.

-- rooms know of two kinds of 'things' that can collide:
--  entities
--  tiles

-- entities can collide with other entities or with tiles.

--  TILES

-- the room has a tile grid from which it's appearence and 
-- walls are derived. a wall is any tile exposed to open unit.

-- walls are kept in a seperate collection from entities. while
-- it would be simpler to treat walls as entities, there are a 
-- few good reasons for this choice:
--      tile v entity collision behavior is special:
--          it needs to be done before other kinds of collisions.
--          sliding often requires two tests to be done
--      it is more efficient
--          if walls were entities, they would be tested against
--          each other, even if the test included a conditional
--          like (ignore tile v tile), it's a quadratic increase
--          in tests for every new tile.
--      it lends itself to future optimization
--          Walls can be merged together to form larger ones,
--          reducing the number of tests. Such an optimization
--          is not necessary now, but may become so in future.
--      and of course, last but by no means least:
--          it works right now and I don't want to mess with it.



--  INTER-ROOM CONNECTIONS

-- rooms can be connected together arbitrarily, making a graph.
-- the graph need not follow euclidean notions of space, but 
-- it is recommended that a room not directly connect with 
-- itself, and that any path that contradicts previous spatial
-- intuition (e.g. room X is north of room Y, but path P goes 
-- north from X into Y) be long enough that the two rooms are 
-- not visible simultaneously.



require 'entity'
require 'hitbox'
require 'grid'
require 'util'




-- entities can be spawned into rooms, and killed from rooms
room ={

    new = function(sz)
        local rv = {
            
            size     = sz,
            entities = list(),          
            doors    = {} -- north, south, east, west
        }
        setmetatable(rv,room)
        return rv
    end,

    -- destroys an entity
    kill = function(r, entity)
        game.entities:rm(entity)
        r.entities:rm(entity)
        
        return entity
    end,

    -- creates a new entity and puts it in the world
    spawn = function(r, entity)
        game.entities:prepend(entity)
        r.entities:prepend(entity)
        entity.where = r
        
        return entity
    end,

    -- moves an entity into another room
    transfer = function(r, entity, direction)
        local door = r.doors[direction]
        if door then 
            door.destination.entities:prepend(entity)
            r.entities:rm(entity)
            
            entity:move(door.translation"xy")
            entity.where = r.doors[direction].destination
        end
    end,

    out_of_bounds = function(r,e)
        if e.hitbox.rect[1] < 0          then return "left"  end
        if e.hitbox.rect[2] < 0          then return "up"    end
        if e.hitbox.rect[3] > r.size[1]  then return "right" end
        if e.hitbox.rect[4] > r.size[2]  then return "down"  end
    end,

    -- calculates hitboxes of tiles in room 
    -- in future, will be the constructor of a 'walls' entity
    -- with a multi-hitbox collider, derived from the tiles 
    calculate_walls = function(r)
        -- we'll compute rectangles by looking at edges first
        -- that is, tiles with at least one empty neighbor
        local edges = {}
        
        -- room stores rectangles in this table
        r.walls = {}

        for x = 1, r.tiles.size[1] do 
            for y = 1, r.tiles.size[2] do 
                if r.tiles(x,y) then 
                    -- calculate neighbors
                    local lf, rt, up, dn = r.tiles(x-1,y  )
                                         , r.tiles(x+1,y  )
                                         , r.tiles(x,  y-1)
                                         , r.tiles(x,  y+1)

                    local empty_nbrs = 0
                    local e = {}
                    
                    if not lf then 
                        empty_nbrs = empty_nbrs + 1
                        e.lf = true
                    end
                    
                    if not rt then 
                        empty_nbrs = empty_nbrs + 1 
                        e.rt = true
                    end
                    
                    if not up then 
                        empty_nbrs = empty_nbrs + 1 
                        e.up = true
                    end
                    
                    if not dn then 
                        empty_nbrs = empty_nbrs + 1 
                        e.dn = true
                    end

                    if empty_nbrs > 0 then 
                        e.x = x
                        e.y = y
                        edges[#edges+1] = e 
                    end
                end
            end
        end
                
        -- now compute walls
        for s = 1, #edges do
            local e = edges[s]
            
            -- add a rectangle
            r.walls[#r.walls+1] = 
                entity.wall( hitbox.rect{ (e.x-1) *16
                                         ,(e.y-1) *16
                                         , e.x    *16
                                         , e.y    *16 })
        end     

    end,
    
    test_collisions = function(r)
        -- wall collision detection
      
        for e in elems(r.entities) do
            for _, w in pairs(r.walls) do 
                local col = e:collision(w)
                if col then 
                    e:append_collision(col, w) 
                end 
            end 
            e:process_collisions()
        end 
        
        -- inter-entity collision detection
        r.entities:handshake( room.collide_entities )
        for e in elems(r.entities) do
            e:process_collisions()
        end
        
        -- room transfer test           
        for e in elems(r.entities) do
            if not e.where == r then r.entities:rm(e) else
                local transfer_dir = r:out_of_bounds(e)
                if transfer_dir then 
                    r:transfer(e, transfer_dir)
                end
            end
        end -- end for
    end, -- end function
    
    collide_entities = function(e1, e2)
        local col = e1:collision(e2)
        if col then 
            e1:append_collision(col, e2)
            e2:append_collision(col, e1) 
        end
    end,
    
    -- functions for connecting rooms together
    -- by default, the top of the rooms are considered even with each other (y=0)
    -- vertical offset, if positive, sets the right room down by so many pixels
    connect_horizontal = function(left, right, vertical_offset)
        local v = vertical_offset or 0
        
        right.doors.left = 
        {   
            destination = left,
            translation = vector.new{ left.size.w, -v }
        }
        
        left.doors.right = 
        {   
            destination = right,
            translation = vector.new{ -left.size.w,  v }
        }
    end,
    
    -- when connected vertically, the left edges are considered even with each other (x=0)
    -- the horizontal offset sets the down room right by so many pixels
    connect_vertical = function(up, down, horizontal_offset)
        local h = horizontal_offset or 0
        
        down.doors.up = 
        {   
            destination = up,
            translation = vector.new{  h,  up.size.h }
        }
        
        up.doors.down = 
        {   
            destination = down,
            translation = vector.new{ -h, -up.size.h }
        }
    end


}-- end room
room.__index = room