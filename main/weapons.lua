local sixgun = {}

function sixgun:new()
    local instance = {}
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

function sixgun:fire()
    local current = self.chambers[1]
    self.chambers[1] = false
    self.cocked = false
    return current
end

function sixgun:reload()
    for index, _ in ipairs(self.chambers) do
        self.chambers[index] = true
    end
end

local M = {}
function M.get()
    return sixgun:new()
end

return M
