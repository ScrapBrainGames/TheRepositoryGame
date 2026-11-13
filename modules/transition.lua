local M = {
    previous = hash("title"),
    start = vmath.vector3(),
}

M.characters = {}

function M.register(id, player)
    M.characters[id] = player or M.characters[id] or false
end

function M.remove(id)
    M.characters[id] = nil
end

function M.reset()
    M.characters = {}
end

return M
