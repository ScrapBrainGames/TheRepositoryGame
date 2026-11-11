local M = {}

local barriers = {}

function M.add_barrier(id, params)
    -- Add the barrier
    barriers[id] = params

    -- Nodes on all 4 sides of the barrier
    barriers[id].nodes = {}
    for i = -1, 1, 2 do
        table.insert(barriers[id].nodes,
            params.position + vmath.vector3(0, i * (params.height * 0.5 + 32), 0)
        )
        table.insert(barriers[id].nodes,
            params.position + vmath.vector3(i * (params.width * 0.5 + 32), 0, 0)
        )
    end

    -- Nodes at the corners
    for i = -1, 1, 2 do
        for j = -1, 1, 2 do
            table.insert(barriers[id].nodes,
                params.position + vmath.vector3(i * (params.width * 0.5 + 32), j * (params.height * 0.5 + 32), 0)
            )
        end
    end
end

function M.remove_barrier(id)
    barriers[id] = nil
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

local function sightline(from, to)
    local left, right, top, bottom
    if from.x < to.x then
        left = from.x
        right = to.x
    else
        left = to.x
        right = from.x
    end
    if from.y < to.y then
        bottom = from.y
        top = to.y
    else
        bottom = to.y
        top = from.y
    end
    for _, barrier in pairs(barriers) do
        local x = barrier.position.x
        local y = barrier.position.y
        if left < x and x < right then
            local t = (x - from.x) / (to.x - from.x)
            local yt = from.y + t * (to.y - from.y)
            if math.abs(yt - y) < barrier.height * 0.5 then
                -- Sight line blocked by barrier
                return false
            end
        end
        if bottom < y and y < top then
            local t = (y - from.y) / (to.y - from.y)
            local xt = from.x + t * (to.x - from.x)
            if math.abs(xt - x) < barrier.width * 0.5 then
                -- Sight line blocked by barrier
                return false
            end
        end
    end
    return true
end

local function get_destination(agent)
    -- Get all nodes, in random order
    local nodes = {}
    for _, value in pairs(barriers) do
        for _, point in ipairs(value.nodes) do
            if #nodes < 1 then
                table.insert(nodes, point)
            else
                table.insert(nodes, math.random(#nodes + 1), point)
            end
        end
    end

    -- Get the first best node, if available
    local backup = {}
    local target
    for _, point in ipairs(nodes) do
        -- Skip any node we're already on
        if vmath.length_sqr(point - agent.state.position) > 1000 then
            -- Check that agent can see the node
            if sightline(agent.state.position, point) then
                -- Check that player can't see the node
                if sightline(player.position, point) then
                    table.insert(backup, point)
                else
                    target = point
                    break
                end
            end
        end
    end
    -- Return best node available
    return target or backup[1]
end

local actions = {}
actions.movement = {
    move = function(agent)
        local timer = 3
        local destination = get_destination(agent)
        local next = math.random() < 0.5 and "wait" or "move"
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
        local timer = 2
        local next = "move"
        agent.state.direction = vmath.vector3()
        return function(dt, sighted)
            if sighted then
                return next
            end
            timer = timer - dt
            if timer <= 0 then
                return next
            end
        end
    end
}
actions.combat = {
    wait = function(agent)
        local timer = 0.5
        local next = "wait"
        agent.state.aiming = false
        return function(dt, sighted)
            timer = timer - dt
            if timer <= 0 then
                if agent.state.weapon:ready() then
                    if sighted then
                        return "aim"
                    else
                        return "wait"
                    end
                else
                    if sighted then
                        return "wait"
                    else
                        return "reload"
                    end
                end
                return next
            end
        end
    end,
    aim = function(agent)
        local timer = 0.25
        agent.state.aiming = true
        agent.state.weapon:cycle()
        return function(dt, sighted)
            local t = vmath.length(player.position - agent.state.position) / agent.state.weapon.speed
            agent.state.target = player.position + t * player.velocity
            timer = timer - dt
            if timer <= 0 then
                if sighted then
                    return "fire"
                else
                    return "wait"
                end
            end
        end
    end,
    fire = function(agent)
        local position = agent.state.position
        local direction = agent.state.target - position
        agent.state.weapon:fire(position, direction)
        agent.state.aiming = false
        return function()
            if agent.state.weapon:ready() then
                return math.random() < 0.5 and "aim" or "wait"
            else
                return "wait"
            end
        end
    end,
    reload = function(agent)
        local timer = 1
        agent.state.weapon:reload()
        agent.state.aiming = true
        return function(dt, sighted)
            timer = timer - dt
            if timer <= 0 then
                agent.state.aiming = false
                if sighted then
                    return "aim"
                else
                    return "wait"
                end
            end
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
        --print("Combat: ", next)
        agent.action.combat = actions.combat[next](agent)
    end
end

return M
