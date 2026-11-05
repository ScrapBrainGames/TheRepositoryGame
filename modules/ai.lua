local M = {}

local barriers = {}
local player =
{
    position = vmath.vector3(),
    velocity = vmath.vector3(),
}

local actions = {
    move = {
        duration = 3,
        next = { "wait" }
    },
    wait = {
        duration = 2,
        next = { "move", "wait" }
    }
}

local action = actions.move
local timer = actions.move.duration

function M.add_barrier(id, position)
    barriers[id] = position
end

function M.player_position(position, velocity)
    player.position = position or player.position
    player.velocity = velocity or player.velocity
    return player.position, player.velocity
end

function M.update(dt, position, sighted, movement)

end

return M
