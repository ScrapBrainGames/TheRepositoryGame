local M = {}

M.empty = {
    intro = [[Boy it sure is nice to be a main character and not have to worry about dying.]],
}

M.default = {
    empty = [[Default killed Empty]],
    default = [[Default killed Default]],
    sixgun = [[Default killed Sixgun]],
    shotgun = [[Default killed Shotgun]],
    singlegun = [[Default killed Singlegun]],
}

M.sixgun = {
    empty = [[Sixgun killed Empty]],
    default = [[Sixgun killed Default]],
    sixgun = [[Sixgun killed Sixgun]],
    shotgun = [[Sixgun killed Shotgun]],
    singlegun = [[Sixgun killed Singlegun]],
}

M.shotgun = {
    empty = [[Shotgun killed Empty]],
    default = [[Shotgun killed Default]],
    sixgun = [[Shotgun killed Sixgun]],
    shotgun = [[Shotgun killed Shotgun]],
    singlegun = [[Shotgun killed Singlegun]],
}

M.singlegun = {
    empty = [[Singlegun killed Empty]],
    default = [[Singlegun killed Default]],
    sixgun = [[Singlegun killed Sixgun]],
    shotgun = [[Singlegun killed Shotgun]],
    singlegun = [[Singlegun killed Singlegun]],
}

return M
