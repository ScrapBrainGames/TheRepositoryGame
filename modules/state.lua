local M = {
    previous = hash("empty"),
    current = hash("empty"),
    start = vmath.vector3(),
    tilemap = msg.url(),
}

M.characters = {}
M.names = {}
M.killed = {}

function M.register(id, player, name)
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

function M.kill(id, record)
    if record then
        table.insert(M.killed, M.names[id])
    end
    M.characters[id] = nil
end

function M.ending(id)
    local survivor = M.names[id]
    local victim = M.killed[#M.killed]
    msg.post("main:/monologue#monologue", "start", { speaker = survivor, victim = victim })
end

return M
