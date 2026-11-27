local M = {}

M.empty = {
    -- Interludes
    intro = [[I'm first! I'm first! Nobody else knows where the gold is!]],
    pots = [[Sure are some nice lookin' pots. Be a shame if something were to happen to 'em.]],
    barrels = [[There's nothing here yet...]],
    -- Kills
}

M.default = {
    -- Interludes
    intro = [[Six shots, should be enough for this job.]],
    pots = [[Sure are some nice lookin' pots. Be a shame if something were to happen to 'em.]],
    barrels = [[There's nothing here yet...]],
    tomb = [[...]],
    -- Kills
    mook = [[Who was that guy?]],
    empty = [[Sorry shorty, I'm not one for going halvsies.]],
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
    mook = [[I'm gettin' awful tired of you lot.]],
    empty = [[What a waste of a bullet.]],
    default = [[Sixgun killed Default]],
    sixgun = [[...]],
    shotgun = [[I'da killed you slower if I had the time.]],
    singlegun = [[Hmph. That was almost a fair fight.]],
    dynamite = [[Quiet down, now.]],
}

M.shotgun = {
    -- Interludes
    intro = [[Wooo-eee, I'mma itchin' for that gold!]],
    pots = [[Sure are some nice lookin' pots. Be a shame if something were to happen to 'em.]],
    barrels = [[There's nothing here yet...]],
    tomb = [[...]],
    -- Kills
    mook = [[Tough luck, gettin' between me and my gold!]],
    empty = [[I just shot an unarmed man! Wooo-eee!]],
    default = [[You gotta aim better than that if you wanna be taken seriously!]],
    sixgun = [[Six shots aren't worth a damn if you can't hit 'em!]],
    shotgun = [[Stop lookin' like me!]],
    singlegun = [[How's your "precision" workin' for you now, rifleboy?]],
    dynamite = [[DYNAMITE! Wish I'd thought of that!]],
}

M.singlegun = {
    -- Interludes
    intro = [[]],
    pots = [[Sure are some nice lookin' pots. Be a shame if something were to happen to 'em.]],
    barrels = [[There's nothing here yet...]],
    tomb = [[...]],
    -- Kills
    mook = [[What a waste.]],
    empty = [[Singlegun killed Empty]],
    default = [[Singlegun killed Default]],
    sixgun = [[At what point are you just wasting bullets?]],
    shotgun = [[What's the point of a scattershot if none of them hit?]],
    singlegun = [[He almost looks like me.]],
    dynamite = [[Dynamite? Now you're just getting lazy.]],
}

M.dynamite = {
    -- Interludes
    intro = [[Howdy y'all!]],
    tomb = [[...]],
    -- Kills
    mook = [[Sorry buddy, but there's gold on the line!]],
    empty = [[lolol git gud]],
    default = [[testet]],
    sixgun = [[Shoulda ducked, sucker!]],
    shotgun = [[Not enough boom, buddy!]],
    singlegun = [[All that range and you still couldn't hit the dynamite girl?]],
    dynamite = [[Aw man, did I just kill my twin sister?]],
}

M.mook = {
    -- Interludes
    intro = [[Nothin' this way, boss!]],
    pots = [[I forget, was the gold in a pot?]],
    barrels = [[Actually I think the gold was in a barrel. I think?]],
    -- Kills
    mook = [[Finally killed that deserter, boss!]],
    empty = [[Gottem boss! Oh man, he wasn't even armed. I feel a bit bad about that.]],
    default = [[One more drifter down, boss!]],
    sixgun = [[There's a lot more of these guys around than you said there would be, boss!]],
    shotgun = [[Woah! When we get the gold can I get a shotgun, boss?]],
    singlegun = [[Rifles are cool, but six bullets are always gonna be better than two.]],
    dynamite = [[Boss! She was using dynamite as a weapon! You said I couldn't do that!]],
}

function M.get(speaker, context)
    if M[speaker][context] then
        local text = M[speaker][context]
        M[speaker][context] = nil
        return text
    end
end

return M
