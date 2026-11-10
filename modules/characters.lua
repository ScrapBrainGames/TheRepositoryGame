local weapons = require "modules.weapons"

local M = {}

M.player = "default"

local characters = {
    default = {
        state = {
            health = 1,
        },
        aim_movement = 50,
        normal_movement = 250,
        weapon = weapons.sixgun(),
    },
    sixgun = {
        state = {
            health = 1,
        },
        aim_movement = 50,
        normal_movement = 250,
        weapon = weapons.sixgun(),
    },
    singlegun = {
        state = {
            health = 1,
        },
        aim_movement = 0,
        normal_movement = 250,
        weapon = weapons.singlegun(),
    },
    shotgun = {
        state = {
            health = 1,
        },
        aim_movement = 100,
        normal_movement = 150,
        weapon = weapons.shotgun(),
    },
}

function M.initialize(character, name)
    local params = characters[name] or characters.default
    character.state = params.state
    character.aim_movement = params.aim_movement
    character.normal_movement = params.normal_movement
    character.weapon = params.weapon
end

function M.check(name)
    return characters[name] and characters[name].state.health > 0
end

return M
