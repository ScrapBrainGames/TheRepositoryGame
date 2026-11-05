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

local function get_destination(agent)
    return vmath.vector3(math.random(1000), math.random(1000), 0)
end

local actions = {
    move = {
        name = "move", --for debugging
        duration = 3,
        next = { "wait" },
        enter = function(agent) agent.destination = get_destination(agent) end,
        act = function(agent)
            local direction = agent.destination - agent.position
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

local function enter_action(agent, name)
    local action = actions[name]
    agent.action, agent.timer = action, action.duration
    if action.enter then action.enter(agent) end
end

function M.new(start)
    local agent = { position = vmath.vector3() }
    enter_action(agent, start or "wait")
    return agent
end

function M.update(agent, dt, position, sighted, movement)
    agent.position = position
    agent.timer = agent.timer - dt
    local direction, done = agent.action.act(agent, dt, sighted, movement)
    if done or agent.timer <= 0 then
        local next = agent.action.next
        enter_action(agent, next[math.random(#next)])
    end
    return direction
end

return M
