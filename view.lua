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
                    game.draw( target.where
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
    end
}