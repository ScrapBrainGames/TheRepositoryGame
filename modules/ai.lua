local M = {}

local barriers = {}

function M.add_barrier(id, params)
    -- Add the barrier
    barriers[id] = params

    -- Nodes on all 4 sides of the barrier
    barriers[id].sides = {}
    for i = -1, 1, 2 do
        table.insert(barriers[id].sides, 1,
            params.position + vmath.vector3(0, i * (params.height * 0.5 + 32), 0)
        )
        table.insert(barriers[id].sides, 1,
            params.position + vmath.vector3(i * (params.width * 0.5 + 32), 0, 0)
        )
    end

    -- Nodes at the corners
    barriers[id].corners = {}
    for i = -1, 1, 2 do
        for j = -1, 1, 2 do
            table.insert(barriers[id].corners, 1,
                params.position + vmath.vector3(i * (params.width * 0.5 + 32), j * (params.height * 0.5 + 32), 0)
            )
        end
    end
end

function M.remove_barrier(id)
    barriers[id] = nil
end

local function get_destination(agent)
    local nodes = {}
    for _, value in pairs(barriers) do
        for _, point in ipairs(value.sides) do
            table.insert(nodes, 1, point)
        end
    end
    return nodes[math.random(#nodes)]
end

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

local actions = {}
actions.movement = {
    move = function(agent)
        local timer = 3
        local destination = get_destination(agent)
        local next = "wait"
        return function(dt, sighted)
            timer = timer - dt
            if timer <= 0 then
                return next
            end
            local direction = destination - agent.state.position
            direction.z = 0
            if vmath.length_sqr(direction) < 1000 then
                return next
            end
            agent.state.direction = direction
        end
    end,
    wait = function(agent)
        local timer = 1
        local next = "move"
        agent.state.direction = vmath.vector3()
        return function(dt, sighted)
            timer = timer - dt
            if timer <= 0 then
                return next
            end
        end
    end
}
actions.combat = {
    wait = function(agent)
        local timer = 3
        local next = "aim"
        return function(dt, sighted)
            timer = timer - dt
            if timer <= 0 then
                return next
            end
        end
    end,
    aim = function(agent)
        local timer = 1
        local next = "fire"
        agent.state.aiming = true
        agent.state.weapon:cycle()
        return function(dt)
            agent.state.target = player.position
            timer = timer - dt
            if timer <= 0 then
                return next
            end
        end
    end,
    fire = function(agent)
        local position = agent.state.position
        local direction = agent.state.target - position
        agent.state.weapon:fire(position, direction)
        agent.state.aiming = false
        return function()
            return "wait"
        end
    end
}

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
        print("Movement: ", next)
        agent.action.movement = actions.movement[next](agent)
    end
    -- Combat
    next = agent.action.combat(dt, sighted)
    if next then
        print("Combat: ", next)
        agent.action.combat = actions.combat[next](agent)
    end
end

return M
