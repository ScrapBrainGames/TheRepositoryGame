local M = {}

M.choose = function(...)
    local vars = { ... }
    if #vars > 0 then return vars[math.random(#vars)] end
end

M.range = function(a, b)
    return a + math.random() * (b - a)
end

return M
