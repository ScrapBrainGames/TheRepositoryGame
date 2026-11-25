local M = {}
setmetatable(M, M)
M.__index = camera

local max = 25

local camera = nil

local shakes = {}

local function shake(intensity, duration)
    local m = intensity / duration
    return function(dt)
        intensity = intensity - m * dt
        return intensity
    end
end

function M.register(id)
    camera = id
    shakes = {}
end

function M.get()
    return camera
end

function M.add_shake(intensity, duration)
    table.insert(shakes, shake(intensity, duration))
end

function M.shake(dt)
    local total = 0
    for i = #shakes, 1, -1 do
        local add = s(dt) or 0
        if add <= 0 then
            table.remove(shakes, i)
        else
            total = total + add
        end
    end
    if total > max then
        total = max
    end
    return vmath.vector3((math.random() - 0.5) * 2 * total, (math.random() - 0.5) * 2 * total, 0)
end

return M
