-- collision.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com



require 'util'



-- TODO:
-- add support for multiple hitboxes, arbitrarily associated with classes and reactions
--      syntax would look something like:
--           collider:rule( bounce,    hitbox_small, 'wall')
--           collider:rule( gravitate, radius_large, 'wall')
--      These two rules would cause a collider to be attracted to walls but bounce off
--      of them. Because the two rules have different hitboxes, the gravitation can act
--      on the entity for some time until it is close enough to bounce.



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
        rv.reactions = {}
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

    rule = function(c, reaction, type_flag)
        c.reactions[type_flag] = {reaction}
    end,
    
    -- tests two colliders against each other
    test = function( a, b )
        local overlap = rect.overlap(a.hitbox, b.hitbox) 
        if rect.valid(overlap) then 
            a:react(b, overlap)
            b:react(a, overlap)
        end
    end,
    
    -- reacts one collider against another 
    react = function( a, b, overlap )
        for type_flag, _ in pairs(b.is_a) do 
            for _, react in pairs(a.reactions[type_flag] or {}) do
                react(a.entity, b.entity, type_flag, overlap )
            end
        end
    end
} collider.__index = collider