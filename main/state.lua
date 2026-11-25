local M = {
    previous = hash("empty"),
    current = hash("empty"),
    start = vmath.vector3(),
    tilemap = msg.url(),
}

M.characters = {}
M.names = {}
M.killed = {}

-- Track combat state
M.combat = false

M.player = {
    position = vmath.vector3()
}

function M.register(id, player, name, lesser)
    M.characters[id] = player or M.characters[id] or false
    if name then M.names[id] = name end
end

function M.remove(id)
    M.characters[id] = nil
end

function M.reset()
    M.characters = {}
    M.names = {}
    M.killed = {}
    M.player = {
        position = vmath.vector3()
    }
    M.heir = nil
    M.lesser = {}
end

function M.count()
    local count = 0
    local id
    for key, value in pairs(M.characters) do
        id = key
        count = count + 1
    end
    return count, id
end

function M.major()
    local count = 0
    for id, player in pairs(M.characters) do
        if player then
            if M.names[id] ~= "empty" then
                count = count + 1
            end
        elseif M.names[id] ~= "mook" then
            count = count + 1
        end
        if count > 1 then return true end
    end
    return false
end

function M.kill(id, record)
    if record then
        table.insert(M.killed, M.names[id])
    end
    M.characters[id] = nil
end

function M.ending(id)
    local survivor = M.names[id]
    local victim = M.killed[#M.killed]
    msg.post(id, "set_player")
    msg.post("main:/monologue#monologue", "start", { speaker = survivor, context = victim })
end

M.heir = nil

function M.pass(id)
    if id and M.characters[id] ~= nil then
        M.heir = id
    else
        M.heir = next(M.characters)
    end
    if M.heir then
        msg.post(M.heir, "set_player")
    end
end

return M
