local weapons = require "modules.weapons"

local M = {}

M.player = "default"

local health = function(health, max)
    return {
        health = health,
        max_health = max or health
    }
end

local characters = {
    default = {
        -- Player
        state = health(12),
        aim_movement = 50,
        normal_movement = 350,
        reload_movement = 150,
        weapon = weapons.sixgun(),
    },
    sixgun = {
        state = health(10),
        aim_movement = 50,
        normal_movement = 350,
        reload_movement = 150,
        weapon = weapons.sixgun(),
        aim_delay = 0.125,
    },
    singlegun = {
        state = health(10),
        aim_movement = 0,
        normal_movement = 400,
        reload_movement = 200,
        weapon = weapons.singlegun(),
        aim_delay = 0.25,
    },
    shotgun = {
        state = health(10),
        aim_movement = 100,
        normal_movement = 300,
        reload_movement = 200,
        weapon = weapons.shotgun(),
        aim_delay = 0.25,
    },
}

function M.initialize(character, name)
    local params = characters[name] or characters.default
    character.state = params.state
    character.aim_movement = params.aim_movement
    character.normal_movement = params.normal_movement
    character.reload_movement = params.reload_movement
    character.weapon = params.weapon
    character.aim_delay = params.aim_delay
end

function M.check(name)
    return characters[name] and name ~= M.player and characters[name].state.health > 0
end

return M
