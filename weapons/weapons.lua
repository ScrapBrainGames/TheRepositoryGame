local camera = require "main.camera"
local state = require "main.state"
local random = require "utilities.random"

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
---@field sfx string
local gun = {}
gun.__index = gun

function gun:new()
    local instance = {
        name = "",
        speed = 500,
        damage = 1,
        offset = 48,
        chambers = { true },
        cocked = false,
        noise = 0.0,
        reloading = false,
        cycletime = 0.25,
        sfx = "#gunshot1",
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
    self.cocked = false
    direction.z = 0
    direction = vmath.normalize(direction) +
        self.noise * vmath.vector3(2 * math.random() - 1.0, 2 * math.random() - 1.0, 0)
    direction = vmath.normalize(direction)
    position = position + direction * self.offset
    if self.chambers[1] then
        self.chambers[1] = false

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
        factory.create("#factory", position, rotation, props)
        particlefx.play(self.fx)
        -- Bang!
        position = position + direction * 18
        position.z = 10
        factory.create("#popper", position, nil, { text = "BANG" })
        -- Shake
        local shake = 40000 / (vmath.length_sqr(position - state.player.position) + 10000)
        camera.add_shake(shake, 0.125)
        -- Kick off music, if not already going
        msg.post("main:/jukebox#jukebox", "combat")
        -- Gunshot
        local v = position - state.player.position
        local d = math.abs(v.x) + math.abs(v.y)
        sound.play(self.sfx, {
            gain = 500 / (d + 500),
            pan = v.x / (d + 500),
            speed = random.range(0.9, 1.1)
        })
    else
        -- Click!
        position = position + direction * 18
        position.z = 10
        factory.create("#popper", position, nil, { text = "CLICK" })
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
    instance.damage = 4
    instance.sfx = "#gunshot2"
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
    instance.sfx = "#gunshot3"
    return instance
end

function shotgun:fire(position, direction)
    if not self.cocked then return end
    self.cocked = false
    direction.z = 0
    direction = vmath.normalize(direction)
    position = position + direction * self.offset
    if self.chambers[1] then
        self.chambers[1] = false
    elseif self.chambers[2] then
        self.chambers[2] = false
    else
        -- Click!
        position = position + direction * 18
        position.z = 10
        factory.create("#popper", position, nil, { text = "CLICK" })
        return
    end

    local props = {
        direction = direction,
        speed = self.speed,
        damage = self.damage,
        sender = self.id
    }
    for i = 1, 8 do
        props.direction = direction +
            self.noise * vmath.vector3(2 * math.random() - 1.0, 2 * math.random() - 1.0, 0)
        factory.create("#shotgun", position, nil, props)
    end
    particlefx.play(self.fx)
    -- Bang!
    position = position + direction * 18
    position.z = 10
    factory.create("#popper", position, nil, { text = "BOOM" })
    -- Shake
    local shake = 80000 / (vmath.length_sqr(position - state.player.position) + 10000)
    camera.add_shake(shake, 0.125)
    -- Kick off music, if not already going
    msg.post("main:/jukebox#jukebox", "combat")
    -- Gunshot
    local v = position - state.player.position
    local d = math.abs(v.x) + math.abs(v.y)
    sound.play(self.sfx, {
        gain = 500 / (d + 500),
        pan = v.x / (d + 500),
        speed = random.range(0.9, 1.1)
    })
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

-- Dynamite (telekinetic prophetic)
--@class Dynamite : Gun
local dynamite = setmetatable({}, { __index = gun })
dynamite.__index = dynamite

function dynamite:new()
    local instance = gun.new(self)
    instance.name = "empty" -- don't draw anything in hand
    instance.chambers = {}
    instance:reload()       -- start by pulling one out
    return instance
end

function dynamite:reload()
    if self.reloading then return end
    if self.stick then return end
    self.reloading = 1
end

function dynamite:ready()
    return self.stick and self.cocked and not self.reloading
end

function dynamite:update(dt)
    if self.reloading then
        self.reloading = self.reloading - dt
        if self.reloading <= 0 then
            self.reloading = nil
            self.stick = factory.create("#dynamite", vmath.vector3(0, 7, 3))
            go.set_parent(self.stick, self.fx.path)
            self.cocked = true
        end
    end
end

function dynamite:cycle()
    if self.stick then
        msg.post(self.stick, "light")
    end
end

function dynamite:fire(position, direction)
    if self.stick then
        direction.z = 0
        go.set_parent(self.stick, nil, true)
        msg.post(self.stick, "launch", { position = position, direction = direction })
        -- Destroy the evidence
        self.cocked = false
        self.stick = nil
    end
end

function dynamite:set(id, url)
    self.id = id
    self.fx = url
    self.stick = nil
    self.cocked = false
    self.reloading = 0.5
end

-- The weapons module
local M = {}

function M.dynamite() return dynamite:new() end

function M.sixgun() return sixgun:new() end

function M.singlegun() return singlegun:new() end

function M.shotgun() return shotgun:new() end

function M.empty() return empty:new() end

return M
