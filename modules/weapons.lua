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
---@field reloading boolean
---@field cycletime number
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
        reloading = false,
        cycletime = 0.125,
    }
    return setmetatable(instance, self)
end

function gun:set(id)
    self.id = id
end

function gun:cycle()
    if self.reloading then return end
    if self.timer then
        timer.cancel(self.timer)
    end
    self.timer = timer.delay(self.cycletime, false, function()
        self.cocked = true
        self.timer = nil
    end)
end

function gun:decock()
    if self.timer then
        timer.cancel(self.timer)
    end
    self.timer = nil
    self.cocked = false
end

function gun:spin() end

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

function gun:reload(time)
    if self.reloading and not time then return end
    local delay = 0.5
    if time then
        delay = time
    else
        for index, _ in ipairs(self.chambers) do
            if self.chambers[index] == false then
                delay = delay + 0.5
            end
        end
        if delay <= 0 then return end
    end
    self.reloading = true
    self.cocked = false
    return timer.delay(delay, false,
        function()
            self.reloading = false
            for index, _ in ipairs(self.chambers) do
                self.chambers[index] = true
            end
        end)
end

function gun:rounds()
    local count = 0
    for _, value in ipairs(self.chambers) do
        count = value and count + 1 or count
    end
    return count
end

function gun:ready()
    return (self.chambers[1] or self.chambers[2]) and not self.reloading
end

-- Sixgun (single action revolver)
---@class Sixgun : Gun
local sixgun = setmetatable({}, { __index = gun })
sixgun.__index = sixgun

function sixgun:new()
    local instance = gun.new(self)
    instance.speed = 900
    instance.chambers = { true, true, true, true, true, true }
    instance.noise = 0.1
    instance.damage = 4
    return instance
end

function sixgun:cycle()
    if self.timer then
        timer.cancel(self.timer)
    end
    self.timer = timer.delay(self.cycletime, false, function()
        table.insert(self.chambers, 7, self.chambers[1])
        table.remove(self.chambers, 1)
        self.cocked = true
        self.timer = nil
    end)
end

function sixgun:spin()
    if not self.cocked then
        table.insert(self.chambers, 7, self.chambers[1])
        table.remove(self.chambers, 1)
    end
end

-- Singlegun (single shot rifle)
---@class Singlegun : Gun
local singlegun = setmetatable({}, { __index = gun })
singlegun.__index = singlegun

function singlegun:new()
    local instance = gun.new(self)
    instance.speed = 1200
    instance.noise = 0.01
    instance.damage = 9
    return instance
end

-- Shotgun (double barrel shotgun)
---@class Shotgun: Gun
local shotgun = setmetatable({}, { __index = gun })
shotgun.__index = shotgun

function shotgun:new()
    local instance = gun.new(self)
    instance.speed = 800
    instance.chambers = { true, true }
    instance.noise = 0.2
    instance.damage = 1
    instance.factory = "#shotgun"
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
            local pellet = factory.create(self.factory, position, nil, props)
            sprite.play_flipbook(pellet, "pellet")
        end
    end
end

-- The weapons module
local M = {}

function M.sixgun() return sixgun:new() end

function M.singlegun() return singlegun:new() end

function M.shotgun() return shotgun:new() end

return M
