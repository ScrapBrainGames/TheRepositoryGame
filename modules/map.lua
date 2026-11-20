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
    town = {
        "pots",
        "graveyard",
        "barrels",
    },
    barrels = {
        "town",
    },
    graveyard = {
        "town",
        "tomb",
    },
    tomb = {
        "graveyard",
        "mine",
    },
    mine = {
        "tomb",
    },
}

-- Convert the map to hashes
local hashed = {}
for key, value in pairs(map) do
    local h = {}
    for index, value in ipairs(value) do
        h[index] = hash(value)
    end
    hashed[hash(key)] = h
end
map = hashed

function M.get(current, index)
    return map[current][index]
end

return M
