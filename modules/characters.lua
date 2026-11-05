local M = {}

function M.initialize(character)
    character.health = 3
    character.aim_movement = 750
    character.normal_movement = 1500
end

return M
