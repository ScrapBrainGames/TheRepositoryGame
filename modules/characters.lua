local M = {}

local characters = {
    default = {
        health = 3,
        aim_movement = 750,
        normal_movement = 1500,
    }
}

function M.initialize(character)
    local params = characters["default"]
    character.health = params.health
    character.aim_movement = params.aim_movement
    character.normal_movement = params.normal_movement
end

function M.ai()

end

return M
