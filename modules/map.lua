local M = {}

local map = {
    empty = {
        [1] = "tutorial",
        [2] = "empty",
    },
    tutorial = {
        [1] = "empty",
        [2] = "title",
    },
    title = {
        [1] = "tutorial",
        [2] = "square",
    },
    square = {
        [1] = "title",
        [2] = "pots",
    },
    pots = {
        [1] = "square",
        [2] = "town",
    },
    town = {
        [1] = "pots",
        [2] = "barrels",
        [3] = "graveyard",
    },
    barrels = {
        [1] = "town",
    },
    graveyard = {
        [1] = "town",
        [2] = "tomb",
    },
    tomb = {
        [1] = "graveyard",
        [2] = "mine",
    },
    mine = {
        [1] = "tomb",
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
