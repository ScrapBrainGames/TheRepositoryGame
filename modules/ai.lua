local M = {}

local barriers = {}
local player =
{
    position = vmath.vector3(),
    velocity = vmath.vector3(),
}

local current =
{
    position = vmath.vector3(),
}

local function get_destination()
    return vmath.vector3()
end

local zero = vmath.vector3()

local actions = {
    move = {
        name = "move", --for debugging
        duration = 3,
        next = { "wait" },
        act = function()
            if not current.destination then
                current.destination = get_destination()
            end
            local direction = current.destination - current.position
            return direction
        end
    },
    wait = {
        name = "wait", --for debugging
        duration = 2,
        next = { "move", "wait" },
        act = function()
            return zero
        end
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
    current.position = position
    timer = timer - dt
    if timer <= 0 then
        current.destination = nil
        action = actions[action.next[math.random(1, #action.next)]]
        timer = action.duration
        print(action.name)
    end
    return action.act()
end

return M
