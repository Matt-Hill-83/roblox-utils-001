local module = {
    buffer = 0,
    -- singleScene = true,
    singleScene = false,
    -- 
    entered = {value = false},
    baseWallHeight = 16,
    walkSpeed = 30,
    -- walkSpeed = 16,
    questWallHeight = 24,
    sceneHeight = 50
    -- 
}

module.tagNames = {WordLetter = "WordLetter", LetterBlock = "LetterBlock"}

module.dialogColors = {
    Color3.fromRGB(253, 158, 240), Color3.fromRGB(225, 253, 158),
    Color3.fromRGB(253, 228, 158), Color3.fromRGB(158, 253, 179),
    Color3.fromRGB(158, 215, 253)
}

return module
