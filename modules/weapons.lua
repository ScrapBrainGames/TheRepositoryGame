local sixgun = {}

function sixgun:new(id, factory)
    local instance = {
        factory = factory or "#factory",
        speed = 600,
        damage = 1,
        offset = 32,
        id = id,
    }
    instance.chambers = { true, true, true, true, true, true }
    instance.cocked = false

    setmetatable(instance, self)
    self.__index = self
    return instance
end

function sixgun:cycle()
    table.insert(self.chambers, 7, self.chambers[1])
    table.remove(self.chambers, 1)
    self.cocked = true
end

function sixgun:fire(position, direction)
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

function sixgun:reload()
    for index, _ in ipairs(self.chambers) do
        self.chambers[index] = true
    end
end

function sixgun:rounds()
    local count = 0
    for _, value in ipairs(self.chambers) do
        count = value and count + 1 or count
    end
    return count
end

local M = {}
function M.get(id, factory)
    return sixgun:new(id, factory)
end

return M
