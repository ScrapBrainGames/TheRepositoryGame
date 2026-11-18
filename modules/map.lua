local M = {}

local map = {
    empty = {
        "tutorial",
        "empty",
    },
    tutorial = {
        "empty",
        "title",
    },
    title = {
        "tutorial",
        "square",
    },
    square = {
        "title",
        "pots",
    },
    pots = {
        "square",
        "town",
    },
    mine = {
        "station",
        "graveyard",
    },
    graveyard = {
        "mine",
    }
}

-- Convert the map to hashes
for key, value in pairs(map) do
    map[hash(key)] = {}
    for index, value in ipairs(value) do
        map[hash(key)][index] = hash(value)
    end
end

function M.get(current, index)
    return map[current][index]
end

return M
