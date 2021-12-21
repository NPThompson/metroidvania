-- view.lua



require'vector'



view = {
    init = function(x,y)
        view.windowsize = vector.new{x,y},
        love.window.setMode( x,y )
        
        view.ports[1] = 
        { 
          canvas = love.graphics.newCanvas(320,240)
         ,area   = {vector.new{0,0}, view.windowsize}
        }
        -- for crisp pixel scaling
        view.ports[1].canvas:setFilter("nearest", "nearest")
    end,
    
    -- in future, multiple viewports for multiple players is desired
    ports = {},

    -- sets the viewport to follow a target
    set_target = function( e )
        view.ports[1].target = e
    end,
        
        
    

    draw = function()
        for _, viewport in pairs(view.ports) do 
            local target = viewport.target
            if target then
                love.graphics.setCanvas(viewport.canvas)
                --love.graphics.clear(0,0,0)
                    -- beginning in the room where the target is
                    view.draw_map( target.where
                                   -- and centered on the target
                                  ,target.position - viewport.area[2]/4)
            end
        end
        
        -- draw viewports to screen
        love.graphics.setCanvas() -- set target to main window
        love.graphics.setColor(1,1,1)
        
        for _, viewport in pairs(view.ports) do
            love.graphics.draw(viewport.canvas, 0,0, 0, 2,2)
        end
    end,


    
    draw_map = function(center_room, origin)
        local traversed   = {}
        local to_draw     = { {room = center_room, translation = origin} }
        local rooms       = 10
        
            while rooms > 0 and #to_draw > 0 do
                for _, draw_it in pairs(to_draw) do 
                    -- add neighbors to next iteration
                    for dir, door in pairs(draw_it.room.doors) do 
                        if door.destination and rooms > 0 then -- and not traversed[door.destination] then 
                        to_draw[#to_draw+1] = 
                                {
                                    room        = door.destination,
                                    translation = door.translation + draw_it.translation -- origin
                                }
                                rooms = rooms -1
                        end
                    end
                end         
            end
            
            -- draw all in reverse order, so that the closest rooms appear over the furthest
            local i = #to_draw
            while i > 0 do  
                view.draw_room(to_draw[i].room, to_draw[i].translation)
                i = i - 1
            end         
    end,


    
    draw_room = function(r, o)
            -- draw room background
            love.graphics.setColor(0,0.06,0.1)
            love.graphics.rectangle("fill", -o.x, -o.y, r.tiles.size[1] * r.tile_size, r.tiles.size[2] * r.tile_size)
            love.graphics.setColor(1,1,1)
            
            -- draw tiles
            local tilepos = (vector.new(o) * -1)
            for x = 0, r.tiles.size[1] do
                for y = 0, r.tiles.size[2] do 
                    if r.tiles(x,y) ~= r.tiles.default then 
                        sprite.blocks:draw(0,0, (tilepos - vector.new{1,1} * (r.tile_size/2))"xy")  
                    end
                tilepos.y = tilepos.y + r.tile_size
                end
            tilepos.x = tilepos.x + r.tile_size
            tilepos.y = -o.y
            end
            
            -- draw entities
            for e in elems(r.entities) do 
                if e.draw then 
                    e.draw(e, e.position - o)
                end 
                   
            end
    
    end
}