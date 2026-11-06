local M = {}

local barriers = {}
local path = {}

function M.add_barrier(id, params)
    -- Add the barrier
    barriers[id] = params
    -- Add nodes around the barrier for pathfinding
    local position = params.position
    local width = params.width
    for x = position.x - width, position.x + width, width do
        for y = position.y - width, position.y + width, width do
            path[vmath.vector3(x, y, 0)] = true
        end
    end
    -- Remove any nodes covered by barriers
    for _, params in pairs(barriers) do
        for position in pairs(path) do
            if math.abs(position.x - params.position.x) <= params.width * 0.5 and math.abs(position.y - params.position.y) <= params.width * 0.5 then
                path[position] = nil
            end
        end
    end
end

function M.remove_barrier(id)
    barriers[id] = nil
end

local function get_destination(agent)
    local nodes = {}
    for key in pairs(path) do
        table.insert(nodes, key)
    end
    return nodes[math.random(#nodes)]
end

local actions = {}
actions.movement = {
    move = function(agent)
        local agent = agent
        local timer = 3
        local destination = get_destination(agent)
        return function(dt, sighted)
            timer = timer - dt
            if timer <= 0 then
                return "wait"
            end
            local direction = destination - agent.state.position
            direction.z = 0
            if vmath.length_sqr(direction) < 100 then
                return "wait"
            end
            agent.state.direction = direction
        end
    end,
    wait = function(agent)
        local agent = agent
        local timer = 1
        agent.state.direction = vmath.vector3()
        return function(dt, sighted)
            timer = timer - dt
            if timer <= 0 then
                return "move"
            end
        end
    end
}
actions.combat = {
    wait = function(agent)
        local agent = agent
        local timer = 1
        agent.state.direction = vmath.vector3()
        return function(dt, sighted)
            timer = timer - dt
            if timer <= 0 then
                return "wait"
            end
        end
    end
}

local player =
{
    position = vmath.vector3(),
    velocity = vmath.vector3(),
}

function M.set_player_position(position, velocity)
    player.position = position or player.position
    player.velocity = velocity or player.velocity
    return player.position, player.velocity
end

function M.get_player_position()
    return player.position, player.velocity
end

function M.new(state)
    local agent = {
        state = state,
        action = {}
    }
    agent.action.movement = actions.movement.move(agent)
    agent.action.combat = actions.combat.wait(agent)
    return agent
end

function M.update(agent, dt, sighted)
    local next
    -- Movement
    next = agent.action.movement(dt, sighted)
    if next then
        agent.action.movement = actions.movement[next](agent)
    end
    -- Combat
    next = agent.action.combat(dt, sighted)
    if next then
        agent.action.combat = actions.combat[next](agent)
    end
end

return M
