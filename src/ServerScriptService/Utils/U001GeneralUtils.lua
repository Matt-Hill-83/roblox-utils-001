local Sss = game:GetService("ServerScriptService")
local Constants = require(Sss.Source.Constants.Constants)
local module = {}
local collectionService = game:GetService("CollectionService")
-- 
-- 

function module.setPropsByTag(props)
    local tag = props.tag
    local theProps = props.props

    local items = collectionService:GetTagged(tag)

    for i, item in ipairs(items) do
        mergeTables(item, theProps)
        -- 
    end

end

function getFirstDescendantByName(parent, name)
    local model = parent:GetDescendants()
    for i = 1, #model do
        if model[i].Name == name then
            return model[i]
            -- 
        end
    end
end

function getDescendantsByName(parent, name)
    local items = parent:GetDescendants()

    local output = {}
    for i, item in ipairs(items) do
        if item.Name == name then
            table.insert(output, item)
            -- 
        end
    end
    return output
end

function module.getDescendantsByType(parent, type)
    local items = parent:GetDescendants()
    local output = {}

    for i, item in pairs(items) do
        if item:IsA(type) then
            table.insert(output, item)
            -- 
        end
    end
    return output
end

function module.getDescendantsByNameMatch(parent, name)
    local descendants = parent:GetDescendants()
    local output = {}
    for i = 1, #descendants do
        local child = descendants[i]
        local match = string.match(child.Name, name)
        if match then
            table.insert(output, child)
            -- 
        end
    end
    return output
end

-- 
-- 

function hideItem(part, hide)
    local transparency = hide and 1 or 0
    local visible = not hide
    local enabled = not hide

    if part:IsA("BasePart") then part.Transparency = transparency end
    if part:IsA("Decal") then part.Transparency = transparency end

    if part:IsA("ScrollingFrame") then part.Visible = visible end
    if part:IsA("TextLabel") then part.Visible = visible end
    if part:IsA("TextButton") then part.Visible = visible end

    if part:IsA("SurfaceGui") then part.Enabled = enabled end
end

function setChildrenProps(parent, props)
    if parent:IsA("BasePart") then mergeTables(parent, props) end

    local children = parent:GetDescendants()
    for i, item in ipairs(children) do
        if item:IsA("BasePart") then mergeTables(item, props) end
    end
end

function hideItemAndChildren(props)
    local parent = props.item
    local hide = props.hide

    hideItem(parent, hide)
    local children = parent:GetDescendants()
    for i, item in ipairs(children) do hideItem(item, hide) end
end

function sizeWalls(props)
    local parent = props.item
    local height = props.height

    local children = parent:GetDescendants()
    for i, item in ipairs(children) do
        if item:isA("Part") then item.CanCollide = false end
    end
    for i, item in ipairs(children) do
        if item:isA("Part") then
            local posY = item.Position.Y - item.Size.Y / 2
            local newPosY = posY + (height / 2)
            item.Size = Vector3.new(item.Size.X, height, item.Size.Z)
            item.Position = Vector3.new(item.Position.X, newPosY,
                                        item.Position.Z)

        end
    end
    for i, item in ipairs(children) do
        if item:isA("Part") then

            item.CanCollide = true
            item.Anchored = true
        end
    end
end

function sizeWalls2(props)
    local items = props.items
    local height = props.height

    -- local children = parent:GetDescendants()
    for i, item in ipairs(items) do
        if item:isA("Part") then item.CanCollide = false end
    end
    for i, item in ipairs(items) do
        if item:isA("Part") then
            local posY = item.Position.Y - item.Size.Y / 2
            local newPosY = posY + (height / 2)
            item.Size = Vector3.new(item.Size.X, height, item.Size.Z)
            item.Position = Vector3.new(item.Position.X, newPosY,
                                        item.Position.Z)

        end
    end
    for i, item in ipairs(items) do
        if item:isA("Part") then

            item.CanCollide = true
            item.Anchored = true
        end
    end
end

function module.hideItemAndChildrenByName(props)
    local name = props.name
    local hide = props.hide

    local myStuff = workspace:FindFirstChild("MyStuff")
    local item = getFirstDescendantByName(myStuff, name)
    hideItemAndChildren({item = item, hide = hide})
end

function module.setWallHeightByList(props)
    local items = props.items
    local height = props.height

    sizeWalls2({items = items, height = height})

end

function module.setWallHeightbyParentModelName(props)
    local name = props.name
    local height = props.height

    local myStuff = workspace:FindFirstChild("MyStuff")
    -- local item = getFirstDescendantByName(myStuff, name)
    local items = getDescendantsByName(myStuff, name)

    for i, item in ipairs(items) do
        sizeWalls({item = item, height = height})
        -- 
    end
end

function module.setItemAndChildrenPropsByName(myProps)
    local name = myProps.name
    local props = myProps.props

    local myStuff = workspace:FindFirstChild("MyStuff")
    local item = getFirstDescendantByName(myStuff, name)
    setChildrenProps(item, props)
end

function module.setItemAndChildrenPropsByInst(myProps)
    local item = myProps.item
    local props = myProps.props

    setChildrenProps(item, props)
end

function module.getOrCreateFolder(props)
    local name = props.name
    local parent = props.parent

    local runtimeQuestsFolder = getFirstDescendantByName(parent, name)

    if not runtimeQuestsFolder then
        runtimeQuestsFolder = Instance.new("Folder", parent)
        runtimeQuestsFolder.Name = name
        runtimeQuestsFolder = getFirstDescendantByName(parent, name)
    end

    return runtimeQuestsFolder
end

function module.reportPlayerLocation()
    local Players = game:GetService("Players")
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            while humanoidRootPart do
                local test2 = workspace.CurrentCamera.CFrame.Position
                print(test2);
                print(player.Name, "is at", tostring(humanoidRootPart.Position))
                wait(4)
            end
        end)
    end)
end

function module.getDecalIdFromName(props)
    local name = props.name
    if (Constants.characters[name] and Constants.characters[name]["decalId"]) then
        return Constants.characters[name]["decalId"]
    else

        if (name ~= "blank" and name ~= "empty" and name ~= "") then
            print("----------------- decalId not found: ------------" .. name)
        end
        return '5999465084'
    end
end

function module.getDisplayNameFromName(props)
    local name = props.name
    if (Constants.characters[name] and Constants.characters[name]["displayName"]) then
        return Constants.characters[name]["displayName"]
    else
        print("---------------------- name not found: ------------" .. name)
        return name
    end
end

function module.deleteChildrenByName(props)
    local parent = props.parent
    local childName = props.childName
    local children = parent:GetDescendants()
    for i, item in pairs(children) do
        if item.Name == childName then
            item:Destroy()
            --
        end
    end
end

function getFromMyStuff(name)
    local myStuff = workspace:FindFirstChild("MyStuff")
    return getFirstDescendantByName(myStuff, name)
end

function module.getFromTemplates(name)
    local myStuff = workspace:FindFirstChild("MyStuff")
    local myTemplates = myStuff:FindFirstChild("MyTemplates")
    return getFirstDescendantByName(myTemplates, name)
end

function module.unAttachAllChildParts(parent)
    local items = parent:GetDescendants()
    local output = {}
    for i = 1, #items do
        if items[i]:IsA('Part') then
            local item = items[i]
            if item.Anchored == true then table.insert(output, item) end
            --
        end

    end
    return output
end

function addcfv3(a, b)
    local x, y, z, m11, m12, m13, m21, m22, m23, m31, m32, m33 = a:components()
    return CFrame.new(x + b.x, y + b.y, z + b.z, m11, m12, m13, m21, m22, m23,
                      m31, m32, m33);
end

function cloneModel(props)
    local model = props.model
    local position = props.position
    local suffix = props.suffix

    local modelClone = model:Clone()
    modelClone.Parent = model.Parent
    modelClone.Name = model.Name .. (suffix or "-Clone")
    if (position) then
        modelClone:SetPrimaryPartCFrame(position)
        -- 
    end
    return modelClone
end

local function getNames(tab, name, res, lev)
    res = res or {[tab] = "ROOT"}
    local pls = {}
    lev = lev or 0
    for k, v in pairs(tab) do
        if type(v) == "table" and not res[v] then
            local n = name .. "." .. tostring(k)
            res[v] = n
            pls[v] = n
        end
    end
    for k, v in pairs(pls) do
        getNames(k, v, res)
        pls[k] = lev
    end
    return res, pls
end

function tableToString(tab, a, b, c, d)
    a, b = a or 0, b or {[tab] = true}
    local name = b[tab]
    local white = ("\t"):rep(a + 1)
    if not c then c, d = getNames(tab, "ROOT") end
    local res = {"{"}
    for k, v in pairs(tab) do
        local value
        if type(v) == "table" then
            if d[v] == a and not b[v] then
                b[v] = true
                value = tableToString(v, a + 1, b, c, d)
            else
                value = c[v]
            end
        elseif type(v) == "string" then
            value = '"' .. v:gsub("\n", "\\n"):gsub("\t", "\\t") .. '"'
        else
            value = tostring(v)
        end
        table.insert(res, white .. tostring(k) .. " = " .. value)
    end
    white = white:sub(2)
    table.insert(res, white .. "}")
    return table.concat(res, "\n")
end

local test = {
    str = "Result:\n\t- Unknown",
    number = 12345,
    child = {a = "b"},
    cyclic = {}
}
test.child.cyclic = test.cyclic
test.another = test.child

function mergeTables(t1, t2) for k, v in pairs(t2) do t1[k] = v end end

addPadding = function(props)
    local parent = props.parent
    local paddingPct = props.paddingPct

    local UIPadding = Instance.new("UIPadding", parent)

    UIPadding.PaddingBottom = UDim.new(paddingPct, 0)
    UIPadding.PaddingTop = UDim.new(paddingPct, 0)
    UIPadding.PaddingLeft = UDim.new(paddingPct, 0)
    UIPadding.PaddingRight = UDim.new(paddingPct, 0)
end

setMaterialPebble = function(part)
    part.Material = Enum.Material.Pebble
    part.BrickColor = BrickColor.new("Institutional white")
end

module.addcfv3 = addcfv3
module.addPadding = addPadding
module.cloneModel = cloneModel
module.getFirstDescendantByName = getFirstDescendantByName
module.getFromMyStuff = getFromMyStuff
module.setMaterialPebble = setMaterialPebble
module.tableToString = tableToString
module.hideItemAndChildren = hideItemAndChildren
module.mergeTables = mergeTables
module.getDescendantsByName = getDescendantsByName

return module
