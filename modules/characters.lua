local weapons = require "modules.weapons"

local M = {}

M.player = "empty"

local health = function(health, max, handicap)
    return {
        health = health,
        max_health = max or health,
        handicap = handicap or 12
    }
end

local characters = {
    empty = {
        state = health(1, 1, 1),
        aim_movement = 50,
        normal_movement = 250,
        reload_movement = 100,
        weapon = weapons.empty(),
        aim_delay = 0.25,
        accuracy = 0.85
    },
    default = {
        -- Player
        state = health(12),
        aim_movement = 50,
        normal_movement = 250,
        reload_movement = 100,
        weapon = weapons.sixgun(),
        aim_delay = 0.25,
        accuracy = 0.85
    },
    sixgun = {
        state = health(10),
        aim_movement = 50,
        normal_movement = 250,
        reload_movement = 100,
        weapon = weapons.sixgun(),
        aim_delay = 0.25,
        accuracy = 0.85
    },
    singlegun = {
        state = health(10),
        aim_movement = 0,
        normal_movement = 300,
        reload_movement = 150,
        weapon = weapons.singlegun(),
        aim_delay = 0.25,
        accuracy = 0.95
    },
    shotgun = {
        state = health(10),
        aim_movement = 100,
        normal_movement = 300,
        reload_movement = 200,
        weapon = weapons.shotgun(),
        aim_delay = 0.25,
        accuracy = 0.85
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
    character.accuracy = params.accuracy
end

function M.check(name)
    return characters[name] and name ~= M.player and characters[name].state.health > 0
end

return M
