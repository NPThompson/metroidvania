-- hitbox.lua



require 'rect'



hitbox = 
{
    new = function()
        local rv = {}
        setmetatable(rv, hitbox)
        return rv
    end,
    
    rect = function(...)
        local rv = hitbox.new()
        rv.rect = rect.new(...)
        return rv
    end,

    test = function(a, b)
        local rv = a.rect:overlap(b.rect)
        if rect.valid(rv) then 
            return rv
        end
    end,
    
    move = function(h, dx,dy)
        h.rect:move(dx,dy)
    end
} hitbox.__index = hitbox