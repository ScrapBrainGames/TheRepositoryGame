-- Parent gun with default methods and properties
---@class Gun
---@field name string
---@field speed number
---@field damage number
---@field offset number
---@field chambers boolean[]
---@field cocked boolean
---@field factory string
---@field id hash?
---@field noise number
---@field reloading number
---@field cycling number
---@field cycletime number
local gun = {}
gun.__index = gun

function gun:new()
    local instance = {
        name = "",
        speed = 100,
        damage = 1,
        offset = 48,
        chambers = { true },
        cocked = false,
        factory = "#factory",
        noise = 0.0,
        reloading = false,
        cycletime = 0.25,
    }
    return setmetatable(instance, self)
end

function gun:set(id, url)
    self.id = id
    self.fx = url
end

function gun:cycle()
    if self.reloading or self.cycling or self.cocked then return end
    self.cycling = self.cycletime
end

function gun:fire(position, direction)
    if not self.cocked then return end
    direction.z = 0
    direction = vmath.normalize(direction) +
        self.noise * vmath.vector3(2 * math.random() - 1.0, 2 * math.random() - 1.0, 0)
    direction = vmath.normalize(direction)
    position = position + direction * self.offset
    if self.chambers[1] then
        self.chambers[1] = false
        self.cocked = false

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
        particlefx.play(self.fx)
        -- Kick off music, if not already going
        msg.post("main:/jukebox#jukebox", "combat")
    else
        -- Click!
        position = position + direction * 18
        position.z = 10
        factory.create("#popper", position, nil, { text = "CLICK" })
        self.cocked = false
    end
end

function gun:reload()
    if self.reloading then return end
    local delay = 0.5
    for index, _ in ipairs(self.chambers) do
        if self.chambers[index] == false then
            delay = delay + 0.5
        end
    end
    if delay <= 0.5 then return end
    self.reloading = delay
    self.cocked = false
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

function gun:update(dt)
    if self.cycling then
        self.cycling = self.cycling - dt
        if self.cycling <= 0 then
            self.cocked = true
            self.cycling = nil
        end
    end
    if self.reloading then
        self.reloading = self.reloading - dt
        if self.reloading <= 0 then
            for index, _ in ipairs(self.chambers) do
                self.chambers[index] = true
            end
            self.reloading = nil
        end
    end
end

-- Sixgun (single action revolver)
---@class Sixgun : Gun
local sixgun = setmetatable({}, { __index = gun })
sixgun.__index = sixgun

function sixgun:new()
    local instance = gun.new(self)
    instance.name = "sixgun"
    instance.speed = 900
    instance.chambers = { true, true, true, true, true, true }
    instance.noise = 0.1
    --instance.damage = 4
    instance.damage = 1
    return instance
end

function sixgun:update(dt)
    if self.cycling then
        self.cycling = self.cycling - dt
        if self.cycling <= 0 then
            table.insert(self.chambers, table.remove(self.chambers, 1))
            self.cocked = true
            self.cycling = nil
        end
    end
    if self.reloading then
        self.reloading = self.reloading - dt
        if self.reloading <= 0 then
            for index, _ in ipairs(self.chambers) do
                self.chambers[index] = true
            end
            self.reloading = nil
        end
    end
end

-- Singlegun (single shot rifle)
---@class Singlegun : Gun
local singlegun = setmetatable({}, { __index = gun })
singlegun.__index = singlegun

function singlegun:new()
    local instance = gun.new(self)
    instance.name = "singlegun"
    instance.speed = 1500
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
    instance.name = "shotgun"
    instance.speed = 800
    instance.chambers = { true, true }
    instance.noise = 0.2
    instance.damage = 2
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
            factory.create(self.factory, position, nil, props)
        end
        particlefx.play(self.fx)
    end
end

-- Empty (no weapons)
---@class Empty : Gun
local empty = setmetatable({}, { __index = gun })
empty.__index = empty

function empty:new()
    local instance = gun.new(self)
    instance.name = "empty"
    instance.chambers = {}
    return instance
end

function empty:cycle() end

function empty:fire() end

function empty:reload() end

-- The weapons module
local M = {}

function M.sixgun() return sixgun:new() end

function M.singlegun() return singlegun:new() end

function M.shotgun() return shotgun:new() end

function M.empty() return empty:new() end

return M
