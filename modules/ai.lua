local M = {}

local barriers = {}

function M.add_barrier(id, params)
    -- Add the barrier
    barriers[id] = params

    -- Nodes on all 4 sides of the barrier
    barriers[id].nodes = {}
    for i = -1, 1, 2 do
        table.insert(barriers[id].nodes,
            params.position + vmath.vector3(0, i * (params.height * 0.5 + 48), 0)
        )
        table.insert(barriers[id].nodes,
            params.position + vmath.vector3(i * (params.width * 0.5 + 48), 0, 0)
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

-- Add nodes without a barrier
function M.add_node(id, position)
    barriers[id] = {
        nodes = {
            position
        }
    }
end

function M.remove_barrier(id)
    barriers[id] = nil
end

local enemies = {}
local destinations = {}
function M.track_enemy(id, position)
    enemies[id] = position
end

function M.remove_enemy(id)
    enemies[id] = nil
    destinations[id] = nil
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

local function enemy_spread(point, id)
    for key, position in pairs(destinations) do
        if key ~= id and vmath.length_sqr(point - position) < 80000 then
            return false
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
        -- Skip any node we're already on or too close to the player or other enemies
        if vmath.length_sqr(point - agent.state.position) > 1000 and vmath.length_sqr(point - player.position) > 160000 and enemy_spread(point, agent.state.id) then
            -- Check that agent can see the node
            if not physics.raycast(agent.state.position, point, { hash("level"), hash("player") }) then
                -- Check that player can't see the node
                if physics.raycast(player.position, point, { hash("level") }) then
                    target = point
                    break
                else
                    table.insert(backup, point)
                end
            end
        end
    end
    target = target or backup[1]
    destinations[agent.state.id] = target
    -- Return best node available
    return target
end

local function clear_shot(agent)
    local from = agent.state.position
    local target = player.position
    local direction = vmath.normalize(target - from)
    local range = vmath.length(target - from) + 100
    local to = vmath.vector3()
    for margin = 100, range, 100 do
        to.x = target.x - margin * direction.y
        to.y = target.y + margin * direction.x
        if physics.raycast(from, to, { hash("player") }) then return false end
        to.x = target.x + margin * direction.y
        to.y = target.y - margin * direction.x
        if physics.raycast(from, to, { hash("player") }) then return false end
    end


    return true
end

local actions = {}
actions.movement = {
    move = function(agent)
        local timer = 2
        local destination = get_destination(agent)
        local next = agent.state.weapon.reloading and "wait" or math.random() < 0.5 and "wait" or "move"
        return function(dt, sighted)
            if not destination then
                return "wait"
            end
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
        local next = agent.state.weapon.reloading and "wait" or "move"
        agent.state.direction = vmath.vector3()
        return function(dt, sighted)
            if sighted then
                return "move"
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
                        return agent.state.weapon.reloading and "wait" or "reload"
                    end
                end
                return next
            end
        end
    end,
    aim = function(agent)
        local timer = agent.state.weapon.cycletime + agent.state.aim_delay
        agent.state.aiming = true
        agent.state.weapon:cycle()
        return function(dt, sighted)
            local t = vmath.length(player.position - agent.state.position) / agent.state.weapon.speed
            agent.state.target = player.position + t * player.velocity * math.random()
            timer = timer - dt
            if timer <= 0 then
                agent.state.aiming = false
                if sighted then
                    if clear_shot(agent) then
                        return "fire"
                    else
                        print("waiting for clear shot")
                        timer = 0.25
                    end
                else
                    return "wait"
                end
            end
        end
    end,
    fire = function(agent)
        local target = agent.state.target
        local position = agent.state.position
        -- Add some inaccuracy
        target = target +
            vmath.vector3(math.random() * 2 - 1, math.random() * 2 - 1, 0) * vmath.length(target - position) *
            (1 - agent.state.accuracy)
        local direction = target - position
        agent.state.weapon:fire(position, direction)
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
        --print("Movement: ", next)
        agent.action.movement = actions.movement[next](agent)
    end
    -- Combat
    next = agent.action.combat(dt, sighted)
    if next then
        --print("Combat: ", next)
        agent.action.combat = actions.combat[next](agent)
    end
end

function M.react(agent)
    agent.action.movement = actions.movement.move(agent)
end

return M
