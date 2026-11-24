local M = {}
setmetatable(M, M)
M.__index = camera

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
    table.insert(shakes, 1, shake(intensity, duration))
end

function M.shake(dt)
    local total = 0
    for i, s in ipairs(shakes) do
        local add = s(dt) or 0
        if add <= 0 then
            shakes[i] = nil
        else
            total = total + add
        end
    end
    return vmath.vector3((math.random() - 0.5) * 2 * total, (math.random() - 0.5) * 2 * total, 0)
end

return M
