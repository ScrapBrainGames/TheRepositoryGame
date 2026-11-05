local M = {}

local barriers = {}
local player = vmath.vector3()

function M.add_barrier(id, position)
    barriers[id] = position
end

function M.player_position(position)
    player = position
end

return M
