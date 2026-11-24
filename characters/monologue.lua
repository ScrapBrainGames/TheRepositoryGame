local M = {}

M.empty = {
    -- Interludes
    intro = [[Boy it sure is nice to be a main character and not have to worry about dying.]],
    pots = [[Sure are some nice lookin' pots. Be a shame if something were to happen to 'em.]],
    barrels = [[There's nothing here yet...]],
    -- Kills
}

M.default = {
    -- Interludes
    intro = [[Your hero, Default.]],
    pots = [[Sure are some nice lookin' pots. Be a shame if something were to happen to 'em.]],
    barrels = [[There's nothing here yet...]],
    tomb = [[...]],
    -- Kills
    mook = [[unreachable]],
    empty = [[Default killed Empty]],
    default = [[Default killed Default]],
    sixgun = [[Default killed Sixgun]],
    shotgun = [[Default killed Shotgun]],
    singlegun = [[Default killed Singlegun]],
}

M.sixgun = {
    -- Interludes
    intro = [[Your hero, Sixgun.]],
    pots = [[Sure are some nice lookin' pots. Be a shame if something were to happen to 'em.]],
    barrels = [[There's nothing here yet...]],
    tomb = [[...]],
    -- Kills
    mook = [[unreachable]],
    empty = [[Sixgun killed Empty]],
    default = [[Sixgun killed Default]],
    sixgun = [[Sixgun killed Sixgun]],
    shotgun = [[Sixgun killed Shotgun]],
    singlegun = [[Sixgun killed Singlegun]],
}

M.shotgun = {
    -- Interludes
    intro = [[Your hero, Shotgun.]],
    pots = [[Sure are some nice lookin' pots. Be a shame if something were to happen to 'em.]],
    barrels = [[There's nothing here yet...]],
    tomb = [[...]],
    -- Kills
    mook = [[Who was that guy?]],
    empty = [[Shotgun killed Empty]],
    default = [[Shotgun killed Default]],
    sixgun = [[Shotgun killed Sixgun]],
    shotgun = [[Shotgun killed Shotgun]],
    singlegun = [[Shotgun killed Singlegun]],
}

M.singlegun = {
    -- Interludes
    intro = [[Your hero, Singlegun.]],
    pots = [[Sure are some nice lookin' pots. Be a shame if something were to happen to 'em.]],
    barrels = [[There's nothing here yet...]],
    tomb = [[...]],
    -- Kills
    mook = [[unreachable]],
    empty = [[Singlegun killed Empty]],
    default = [[Singlegun killed Default]],
    sixgun = [[Singlegun killed Sixgun]],
    shotgun = [[Singlegun killed Shotgun]],
    singlegun = [[Singlegun killed Singlegun]],
}

M.dynamite = {
    -- Interludes
    intro = [[Howdy y'all!]],
    tomb = [[...]],
    -- Kills
    empty = [[lolol git gud]]
}

M.mook = {
    -- Interludes
    intro = [[Mook.]],
    pots = [[Mook mook.]],
    barrels = [[Mook mook mook.]],
    -- Kills
    mook = [[unreachable]],
    empty = [[Mook killed Empty]],
    default = [[Mook killed Default]],
    sixgun = [[Mook killed Sixgun]],
    shotgun = [[Mook killed Shotgun]],
    singlegun = [[Mook killed Singlegun]],
}

function M.get(speaker, context)
    if M[speaker][context] then
        local text = M[speaker][context]
        M[speaker][context] = nil
        return text
    end
end

return M
