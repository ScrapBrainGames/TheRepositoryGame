-- Parent gun with default methods and properties
---@class Gun
---@field speed number
---@field damage number
---@field offset number
---@field chambers boolean[]
---@field cocked boolean
---@field factory string
---@field id hash?
---@field noise number
local gun = {}
gun.__index = gun

function gun:new()
    local instance = {
        speed = 100,
        damage = 1,
        offset = 48,
        chambers = { true },
        cocked = false,
        factory = "#factory",
        noise = 0.0,
    }
    return setmetatable(instance, self)
end

function gun:set(id)
    self.id = id
end

function gun:cycle()
    self.cocked = true
end

function gun:fire(position, direction)
    if self.chambers[1] and self.cocked then
        self.chambers[1] = false
        self.cocked = false
        direction.z = 0
        direction = vmath.normalize(direction) +
            self.noise * vmath.vector3(2 * math.random() - 1.0, 2 * math.random() - 1.0, 0)
        direction = vmath.normalize(direction)
        position = position + direction * self.offset
        local props = {
            direction = direction,
            speed = self.speed,
            damage = self.damage,
            sender = self.id
        }
        local rotation = vmath.quat(
            0, 0,
            (direction.y > 0 and 1 or -1) * (direction.x < 1 and math.sqrt(0.5 * (1 - direction.x)) or 0),
            (direction.x > -1 and math.sqrt(direction.x * 0.5 + 0.5) or 0)
        )
        factory.create(self.factory, position, rotation, props)
    else
        self.cocked = false
    end
end

function gun:reload()
    for index, _ in ipairs(self.chambers) do
        self.chambers[index] = true
    end
end

function gun:rounds()
    local count = 0
    for _, value in ipairs(self.chambers) do
        count = value and count + 1 or count
    end
    return count
end

function gun:ready()
    return self:rounds() > 0
end

-- Sixgun (single action revolver)
---@class Sixgun : Gun
local sixgun = setmetatable({}, { __index = gun })
sixgun.__index = sixgun

function sixgun:new()
    local instance = gun.new(self)
    instance.speed = 600
    instance.chambers = { true, true, true, true, true, true }
    instance.noise = 0.1
    instance.damage = 5
    return instance
end

function sixgun:cycle()
    table.insert(self.chambers, 7, self.chambers[1])
    table.remove(self.chambers, 1)
    self.cocked = true
end

-- Singlegun (single shot rifle)
---@class Singlegun : Gun
local singlegun = setmetatable({}, { __index = gun })
singlegun.__index = singlegun

function singlegun:new()
    local instance = gun.new(self)
    instance.speed = 1200
    instance.noise = 0.0
    instance.damage = 10
    return instance
end

-- Shotgun (double barrel shotgun)
---@class Shotgun: Gun
local shotgun = setmetatable({}, { __index = gun })
shotgun.__index = shotgun

function shotgun:new()
    local instance = gun.new(self)
    instance.speed = 500
    instance.chambers = { true, true }
    instance.noise = 0.25
    instance.damage = 2
    return instance
end

function shotgun:fire(position, direction)
    if self.cocked then
        if self.chambers[1] then
            self.chambers[1] = false
        elseif self.chambers[2] then
            self.chambers[2] = false
        else
            self.cocked = false
            return
        end
        self.cocked = false
        direction.z = 0
        direction = vmath.normalize(direction)
        position = position + direction * self.offset
        local props = {
            direction = direction,
            speed = self.speed,
            damage = self.damage,
            sender = self.id
        }
        for i = 1, 8 do
            props.direction = direction +
                self.noise * vmath.vector3(2 * math.random() - 1.0, 2 * math.random() - 1.0, 0)
            factory.create(self.factory, position, nil, props)
        end
    end
end

-- The weapons module
local M = {}

function M.sixgun() return sixgun:new() end

function M.singlegun() return singlegun:new() end

function M.shotgun() return shotgun:new() end

return M
