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
    return vmath.vector3(math.random(1000), math.random(1000), 0)
end

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
            direction.z = 0
            local done = vmath.dot(direction, direction) < 100
            return direction, done
        end
    },
    wait = {
        name = "wait", --for debugging
        duration = 1,
        next = { "move", "wait" },
        act = function()
            return vmath.vector3()
        end
    }
}

local action = actions.move
local timer = actions.move.duration

function M.add_barrier(id, position)
    barriers[id] = position
end

function M.remove_barrier(id)
    barriers[id] = nil
end

function M.set_player_position(position, velocity)
    player.position = position or player.position
    player.velocity = velocity or player.velocity
    return player.position, player.velocity
end

function M.get_player_position(position, velocity)
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
    local direction, done = action.act()
    if done then timer = 0 end
    return direction
end

return M
