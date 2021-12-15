-- entity.lua

-- metroidvanian platformer game
-- N.P.Thompson 2021 (MIT license)
-- noahpthomp@gmail.com



-- general entity code and small or miscallaneous entity constructors 
-- are held here. Complex entities have their own files, such as:
--      player 



require 'react'
require 'player'
require"vector"
-- actions are performed every frame by entities
require"action"
-- rectangles for collision detection
require"rect"



entity ={
    -- constructors defined in other files 
    player = entity_player,

    wall = function(hbox)
        local rv = { hitbox = hbox }
        rv.class = { entity = true, wall = true }
        setmetatable(rv,entity)
        return rv
    end,
    
    coin = function()
        local rv = entity.new{ sprite = "coin" }
        rv.hitbox = hitbox.rect{-6,-6,6,6}
        rv:reaction('entity', react.kill)
        return rv
    end,

    -- builds an entity
    new = function(args)
        local rv =
        {   actions  = {}
           ,class    = {entity = true}
           ,velocity = vector.new{0,0} 
           ,position = vector.new{0,0} 
           ,frame = { row = 0, col = 0 }
           ,grounded = {}
           ,collisions = {}
           ,reactions = {}
        }
        
        for k,v in pairs(args) do 
            rv[k] = v
        end

        setmetatable(rv,entity)
        return rv
    end,

    -- moves position and hitboxes of an entity
    move = function(e, dx, dy)
        e.position  = e.position  + {dx,dy}
        e.hitbox:move(dx,dy)
    end,
    
    -- performs all the actions in e's list of actions 
    -- execute every cycle of the game
    -- the df argument can take into account frame skips when larger than 1
    execute_actions = function(e,df)
        for _, act in pairs(e.actions) do 
            act(e,df)
        end
        if e.timers then for k,v in pairs(e.timers) do
            e.timers[k] = max(e.timers[k] - df,0)
            end
        end
    end,
    
    collision = function(e1, e2)
        return e1.hitbox:test(e2.hitbox)
    end,
    
    append_collision = function(e, col, other_e)
        e.collisions[#e.collisions+1] = { data = col, other = other_e }
    end,
    
    process_collisions = function(e)
        local i = 1 
        while i <= #e.collisions do
            e:react( e.collisions[i].other, e.collisions[i].data)
            i = i + 1
        end
        e.collisions = {}
    end,
    
    react = function(e, other, collision)
        local r
        for type_flag, _ in pairs(other.class) do 
            r = e.reactions[type_flag]
            if r then for _, reaction in pairs(r) do 
                reaction(e, other_e, collision)
                end
            end
        end
    end,
    
    -- (...) is a list of functions to be executed whenever update() is called
    action = function(this, ...)
        for _, act in pairs{...} do 
            this.actions[#this.actions + 1] = act
        end
        return this
    end,
    
    -- (...) is a list of reactions to execute on collision with members of 'type_flag' 
    reaction = function(e, type_flag, ...)
        if not e.reactions[type_flag] then 
            e.reactions[type_flag] = {}
        end
        
        local reactions = e.reactions[type_flag]
        for _, react in pairs{...} do 
            reactions[#reactions+1] = react
        end
    end,
        
    rm_action = function(this, the_action)
        for k, act in pairs(this.actions) do
            if act == the_action then 
                this.actions[k] = nil
                return
            end
        end
        return this
    end
} -- end entity
entity.__index = entity