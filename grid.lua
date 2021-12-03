-- grid.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com



-- usage:
-- g = grid.new()    -> make new grid
-- g(x,y)            -> get element at x,y
-- g:set(x,y,val)    -> set element at x,y to val
grid = 
{
    new = function()
        local rv = {}
        rv.size = {0,0}
        setmetatable(rv, grid)
        return rv
    end,
    
    default = false,
    
    __tostring = function(g)
        local rv = ''
        local tmp = 0
        for j = 1, g.size[2] do 
            for i = 1, g.size[1] do
                tmp = g(i,j)
                if tmp ~= g.default then 
                    rv = rv .. '#'
                else 
                    rv = rv .. '.'
                end
            end
            if j < g.size[2] then 
                rv = rv .. '\n'
            end
        end
        return rv
    end,
    
    __call = function(g,x,y)
        if not g[x] then g[x] = {} end
        local elem = g[x][y]
        if not elem then 
            return g.default
        else 
            return elem
        end
    end,
    
    set = function(g,x,y,val)
        if not g[x] then g[x] = {} end

        g[x][y] = val 
        
        if x > g.size[1] then g.size[1] = x end
        if y > g.size[2] then g.size[2] = y end
    end
}
grid.__index = grid