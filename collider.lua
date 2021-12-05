-- collision.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com



require 'util'


-- a collider is fairly simple:
-- it has one hitbox and a number of rules for whenever it 
-- touches another collider of a given class. 
-- class here means 'strings that colliders use to index rules.'
-- a collider can be a member of multiple classes
-- a collider can have multiple reactions against a single class
-- collider:rule(selfdestruct, 'bullet', 'explosion')
collider = 
{
    new = function(owner, hitbox, ...)
        local rv = {}
        rv.entity = owner
        rv.hitbox = hitbox
        -- source of rules: maps class to reaction
        rv.react = {}
        -- defines what classes the collider is a member of
        -- we assume every collider belongs to an entity
        rv.is_a  = {entity=true}
        
        for _, v in pairs{...} do 
            rv.is_a[v] = true
        end
        
        setmetatable(rv,collider)
        return rv
    end,
    
    -- moves all the hitboxes
    move = function(c,dx,dy)
        c.hitbox:move(dx,dy)
    end,

    rule = function(c, reaction, ...)
        c.reactions[type_flag] = reaction
    end,
    
    -- tests two colliders against each other
    test = function( a, b )
        local overlap = rect.overlap(a.hitbox, b.hitbox) 
        if rect.valid(overlap) then 
            a.react(b, overlap)
            b.react(a, overlap)
        end
    end,
    
    -- reacts one collider against another 
    react = function( a, b, overlap )
        for type_flag, _ in pairs(b.is_a) do 
            for _, react in pairs(a.reactions[type_flag]) do
                react(a.owner, type_flag, overlap )
            end
        end
    end
} collider.__index = collider



move_and_ground_entity = function(e,dx,dy)
    e:move(dx,dy)
    if dx ~= 0 then e.velocity.x = 0 end
    if dy ~= 0 then e.velocity.y = 0 end
    if dy < 0 then e.grounded.below = true end
    if dx < 0 then e.grounded.right = true end
    if dx > 0 then e.grounded.left = true end
end

greater_collision_area = function(c1,c2)
    if c1.overlap[1] * c1.overlap[2] > c2.overlap[1] * c2.overlap[2] then 
        return c1 
    else 
        return c2 
    end
end

resolve_collision = function(e, collision)
    local dx,dy = collision.overlap[1], collision.overlap[2]
    
    if dx > dy then 
        dx = 0 
    else 
        dy = 0
    end
    
    if math.abs(e.velocity.x) > 0.05 then 
        dx = dx * -signum(e.velocity.x)
    else
        dx = dx *  signum(e.position.x - collision.x)
    end
    
    if math.abs(e.velocity.y) > 0.05 then 
        dy = dy * -signum(e.velocity.y)
    else
        dy = dy *  signum(e.position.y - collision.y)
    end
    
    move_and_ground_entity(e, dx,dy)
end


