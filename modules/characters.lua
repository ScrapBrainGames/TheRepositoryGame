local weapons = require "modules.weapons"

local M = {}

M.player = "empty"
M.loadout = nil

local health = function(health, handicap)
    return {
        health = health or 10,
        max_health = health or 10,
        handicap = handicap or 12
    }
end

local character = function(params)
    local char = params or {}
    char.aim_delay = char.aim_delay or 0.25
    char.state = char.health and (char.handicap and health(char.health, char.handicap) or health(char.health)) or
        health(10)
    char.aim_movement = char.aim_movement or 50
    char.normal_movement = char.normal_movement or 250
    char.reload_movement = char.reload_movement or 100
    char.accuracy = char.accuracy or 0.85
    char.aggro = char.aggro or 0.5
    return char
end

local mook = function(loadout)
    local char = character(
        {
            health = 2,
            handicap = 2,
            aggro = 0.9,
        }
    )
    char.loadout = loadout or {
        weapon = math.random() < 0.9 and weapons.sixgun() or weapons.shotgun(),
        body = nil,
        hat = nil,
    }
    char.weapon = char.loadout.weapon
    return char
end

local characters = {
    empty =
    {
        health = 1,
        handicap = 1,
        weapon = weapons.empty(),
    },
    default = {
        aim_movement = 50,
        normal_movement = 250,
        reload_movement = 100,
        weapon = weapons.sixgun(),
        aim_delay = 0.25,
        accuracy = 0.85
    },
    sixgun = {
        aim_movement = 50,
        normal_movement = 250,
        reload_movement = 100,
        weapon = weapons.sixgun(),
        aim_delay = 0.25,
        accuracy = 0.85
    },
    singlegun = {
        aim_movement = 0,
        normal_movement = 300,
        reload_movement = 150,
        weapon = weapons.singlegun(),
        aim_delay = 0.25,
        accuracy = 0.95,
        aggro = 0.1,
    },
    shotgun = {
        aim_movement = 100,
        normal_movement = 300,
        reload_movement = 200,
        weapon = weapons.shotgun(),
        aim_delay = 0.25,
        accuracy = 0.85
    },
}

local obituaries = {}

function M.initialize(self, name)
    local char
    if name == "mook" then
        char = mook(self.player and M.loadout or nil)
    else
        char = character(characters[name])
    end
    for key, value in pairs(char) do
        self[key] = value
    end
end

function M.check(name)
    if name == "mook" then return true end
    return characters[name] and name ~= M.player and not obituaries[name]
end

function M.died(name)
    obituaries[name] = true
end

return M
