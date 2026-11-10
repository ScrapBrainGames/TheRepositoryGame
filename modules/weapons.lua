-- Parent gun with default methods and properties
local gun = {}

function gun:new()
    local instance = {
        speed = 100,
        damage = 1,
        offset = 32,
        chambers = { true },
        cocked = false,
        factory = "#factory",
    }
    setmetatable(instance, self)
    self.__index = self
    return instance
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
        direction = vmath.normalize(direction)
        position = position + direction * self.offset
        local props = {
            direction = direction,
            speed = self.speed,
            damage = self.damage,
            sender = self.id
        }
        factory.create(self.factory, position, nil, props)
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

-- Sixgun (single action revolver)
local sixgun = {}

function sixgun:new()
    local instance = gun:new()
    instance.speed = 600
    instance.chambers = { true, true, true, true, true, true }
    return instance
end

function sixgun:cycle()
    table.insert(self.chambers, 7, self.chambers[1])
    table.remove(self.chambers, 1)
    self.cocked = true
end

-- Singlegun (single shot rifle)
local singlegun = {}

function singlegun:new(id, factory)
    local instance = gun:new()
    instance.speed = 1200
    return instance
end

-- The weapons module
local M = {}

function M.sixgun() return sixgun:new() end

function M.singlegun() return singlegun:new() end

return M
