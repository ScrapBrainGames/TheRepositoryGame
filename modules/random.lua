local M = {}

M.choose = function(...)
    local vars = { ... }
    if #vars > 0 then return vars[math.random(#vars)] end
end

return M
