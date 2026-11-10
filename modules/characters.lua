local weapons = require "modules.weapons"

local M = {}

local characters = {
    sixgun = {
        health = 1,
        aim_movement = 100,
        normal_movement = 300,
        weapon = weapons.sixgun(),
    },
    singlegun = {
        health = 1,
        aim_movement = 0,
        normal_movement = 250,
        weapon = weapons.singlegun(),
    },
}

function M.initialize(character)
    local params = characters["sixgun"]
    character.health = params.health
    character.aim_movement = params.aim_movement
    character.normal_movement = params.normal_movement
    character.weapon = params.weapon
end

return M
