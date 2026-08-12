-- Ultimate_RunEngine_V18_FullDeveloperMode_Fixed.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Robust UI Parent Failsafe (Forces PlayerGui if CoreGui/gethui fails)
local UI_PARENT
pcall(function()
    if gethui then
        UI_PARENT = gethui()
    else
        UI_PARENT = CoreGui
    end
end)

if not UI_PARENT then
    UI_PARENT = PlayerGui
end

-- Cleanup prior instances
for _, child in ipairs(UI_PARENT:GetChildren()) do
    if child.Name == "RunEngine_MasterUI" then child:Destroy() end
end
for _, child in ipairs(PlayerGui:GetChildren()) do
    if child.Name == "RunEngine_MasterUI" then child:Destroy() end
end

-- ============================================================================
-- 1. CONFIG & DEVELOPER_MODE HOOK SYSTEM
-- ============================================================================
local SaveFileName = "RunEngine_ConfigV18_Developer.json"
local Cheats = {
    GodMode = false,
    InfiniteRerolls = false,
    CustomDamageMult = 1,
    CustomSpeedMult = 1,
    SpatialAura = false,
    AuraRadius = 50,
    SickleRadiusOverride = false,
    InfiniteLancePierce = false,
    InfiniteDashes = false,
    NoCooldowns = false,
    MagnetPullsAll = false,
    AutoCollectLoot = false,
    InstantKillBosses = false,
    GlobalHitscanKill = false,
    
    ESPEnabled = false,
    ChamsESP = false,
    XrayWalls = false,
    HitboxExpander = false,
    HitboxScale = 3,
    Fullbright = false,
    CustomFOV = false,
    FOVValue = 90,
    
    CustomWalkSpeed = false,
    WalkSpeedOverride = 16,
    CustomJumpPower = false,
    JumpPowerOverride = 50,
    InfiniteJumps = false,
    Noclip = false,
    FlyMode = false,
    FlySpeed = 50,
    BhopSpeedBoost = false,
    
    Timescale = 1,
    AutoFarmLoop = false,
    AntiAFK = false,
    
    DeveloperMode = false,
    BypassChecks = false,
    UnlockAllChests = false,
    InfiniteCurrency = false,
    DebugConsolePrint = false
}

local function SaveConfig()
    pcall(function()
        if writefile then
            writefile(SaveFileName, HttpService:JSONEncode(Cheats))
        end
    end)
end

local function LoadConfig()
    pcall(function()
        if readfile and isfile and isfile(SaveFileName) then
            local data = HttpService:JSONDecode(readfile(SaveFileName))
            if type(data) == "table" then
                for k, v in pairs(data) do
                    if Cheats[k] ~= nil then Cheats[k] = v end
                end
            end
        end
    end)
end

LoadConfig()

-- ============================================================================
-- 2. MASTER UI CREATION
-- ============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RunEngine_MasterUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 2147483647
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

-- Try parenting to CoreGui/gethui first, fallback to PlayerGui instantly if it errors
local successParent = pcall(function()
    ScreenGui.Parent = UI_PARENT
end)
if not successParent then
    ScreenGui.Parent = PlayerGui
end

local MobileToggleButton = Instance.new("TextButton")
MobileToggleButton.Name = "MobileToggle"
MobileToggleButton.Size = UDim2.new(0, 56, 0, 56)
MobileToggleButton.Position = UDim2.new(0.02, 0, 0.2, 0)
MobileToggleButton.BackgroundColor3 = Color3.fromRGB(15, 17, 24)
MobileToggleButton.Text = "👑"
MobileToggleButton.TextColor3 = Color3.fromRGB(0, 255, 170)
MobileToggleButton.TextSize = 24
MobileToggleButton.Font = Enum.Font.GothamBold
MobileToggleButton.ZIndex = 10
MobileToggleButton.Active = true
MobileToggleButton.Draggable = true
MobileToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 28)
ToggleCorner.Parent = MobileToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 2
ToggleStroke.Color = Color3.fromRGB(0, 255, 170)
ToggleStroke.Parent = MobileToggleButton

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 380)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
MainFrame.ZIndex = 2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.8
MainStroke.Color = Color3.fromRGB(0, 255, 170)
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(16, 19, 27)
Header.ZIndex = 3
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "👑 RUN ENGINE V18 (DEV MODE UNLOCKED)"
Title.TextColor3 = Color3.fromRGB(0, 255, 170)
Title.TextSize = 10
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 4
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 60)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.ZIndex = 4
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
MobileToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- Emergency Keybind Toggle (RightShift or Insert)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 110, 1, -50)
Sidebar.Position = UDim2.new(0, 6, 0, 46)
Sidebar.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
Sidebar.ScrollBarThickness = 2
Sidebar.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 170)
Sidebar.ZIndex = 3
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 4)
SidebarList.Parent = Sidebar

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -126, 1, -50)
ContentFrame.Position = UDim2.new(0, 120, 0, 46)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ZIndex = 3
ContentFrame.Parent = MainFrame

local Tabs, TabButtons = {}, {}

local function CreateTab(name, layoutOrder)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 32)
    tabBtn.BackgroundColor3 = Color3.fromRGB(20, 23, 32)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(160, 160, 170)
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.TextSize = 10
    tabBtn.LayoutOrder = layoutOrder
    tabBtn.ZIndex = 4
    tabBtn.Parent = Sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.ScrollBarThickness = 3
    tabContent.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 170)
    tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.Visible = false
    tabContent.ZIndex = 4
    tabContent.Parent = ContentFrame

    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 6)
    list.Parent = tabContent

    Tabs[name] = tabContent
    TabButtons[name] = tabBtn

    tabBtn.MouseButton1Click:Connect(function()
        for tName, tFrame in pairs(Tabs) do
            local isTarget = (tName == name)
            tFrame.Visible = isTarget
            TweenService:Create(TabButtons[tName], TweenInfo.new(0.2), {
                BackgroundColor3 = isTarget and Color3.fromRGB(0, 180, 120) or Color3.fromRGB(20, 23, 32),
                TextColor3 = isTarget and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170)
            }):Play()
        end
    end)

    return tabContent
end

local CombatTab  = CreateTab("⚔️ Combat", 1)
local VisualsTab = CreateTab("👁️ Visuals", 2)
local PerksTab   = CreateTab("🌸 Perks", 3)
local PlayerTab  = CreateTab("🏃 Player", 4)
local WorldTab   = CreateTab("🌍 World", 5)
local DevTab     = CreateTab("🛠️ Dev", 6)

Tabs["⚔️ Combat"].Visible = true
TabButtons["⚔️ Combat"].BackgroundColor3 = Color3.fromRGB(0, 180, 120)
TabButtons["⚔️ Combat"].TextColor3 = Color3.fromRGB(255, 255, 255)

local function AddToggle(parent, text, keyName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(20, 23, 32)
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 5
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local initialVal = Cheats[keyName]
    local badge = Instance.new("TextLabel")
    badge.Size = UDim2.new(0, 36, 0, 20)
    badge.Position = UDim2.new(1, -40, 0.5, -10)
    badge.BackgroundColor3 = initialVal and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(35, 38, 48)
    badge.Text = initialVal and "ON" or "OFF"
    badge.TextColor3 = initialVal and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 170, 170)
    badge.Font = Enum.Font.GothamBold
    badge.TextSize = 9
    badge.ZIndex = 6
    badge.Parent = btn

    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(0, 4)
    badgeCorner.Parent = badge

    btn.MouseButton1Click:Connect(function()
        Cheats[keyName] = not Cheats[keyName]
        local state = Cheats[keyName]
        badge.Text = state and "ON" or "OFF"
        TweenService:Create(badge, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(35, 38, 48),
            TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 170, 170)
        }):Play()
        SaveConfig()
    end)
end

local function AddTextBox(parent, text, keyName, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(20, 23, 32)
    frame.ZIndex = 5
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.55, 0, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "  " .. text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 6
    label.Parent = frame

    local actualVal = Cheats[keyName] ~= nil and Cheats[keyName] or defaultVal
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 64, 0, 24)
    textBox.Position = UDim2.new(1, -70, 0.5, -12)
    textBox.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
    textBox.Text = tostring(actualVal)
    textBox.TextColor3 = Color3.fromRGB(0, 255, 170)
    textBox.Font = Enum.Font.GothamBold
    textBox.TextSize = 10
    textBox.ClearTextOnFocus = false
    textBox.ZIndex = 6
    textBox.Parent = frame

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent = textBox

    textBox.FocusLost:Connect(function()
        local num = tonumber(textBox.Text)
        if num then 
            Cheats[keyName] = num
            SaveConfig()
            callback(num) 
        else
            textBox.Text = tostring(actualVal)
        end
    end)
end

local function AddSlider(parent, text, keyName, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(20, 23, 32)
    frame.ZIndex = 5
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local actualVal = Cheats[keyName] ~= nil and Cheats[keyName] or defaultVal
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 18)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(actualVal)
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 6
    label.Parent = frame

    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, -16, 0, 10)
    sliderTrack.Position = UDim2.new(0, 8, 0, 24)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
    sliderTrack.ZIndex = 6
    sliderTrack.Parent = frame

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 5)
    trackCorner.Parent = sliderTrack

    local sliderFill = Instance.new("Frame")
    local defaultScale = math.clamp((actualVal - minVal) / (maxVal - minVal), 0, 1)
    sliderFill.Size = UDim2.new(defaultScale, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
    sliderFill.ZIndex = 7
    sliderFill.Parent = sliderTrack

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 5)
    fillCorner.Parent = sliderFill

    local dragging = false
    local function UpdateInput(input)
        local posX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(posX, 0, 1, 0)
        local val = math.floor(minVal + (maxVal - minVal) * posX)
        label.Text = text .. ": " .. tostring(val)
        Cheats[keyName] = val
        SaveConfig()
        callback(val)
    end

    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; UpdateInput(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateInput(input) end
    end)
end

-- Tab Bindings
AddToggle(CombatTab, "God Mode", "GodMode")
AddTextBox(CombatTab, "Damage Multiplier", "CustomDamageMult", 1, function(v) Cheats.CustomDamageMult = v end)
AddTextBox(CombatTab, "Speed Multiplier", "CustomSpeedMult", 1, function(v) Cheats.CustomSpeedMult = v end)
AddToggle(CombatTab, "Kill Aura (2D)", "SpatialAura")
AddSlider(CombatTab, "Aura Radius", "AuraRadius", 10, 300, 50, function(v) Cheats.AuraRadius = v end)
AddToggle(CombatTab, "Instant Kill Bosses", "InstantKillBosses")
AddToggle(CombatTab, "Global Hitscan Kill", "GlobalHitscanKill")
AddToggle(CombatTab, "Infinite Dashes", "InfiniteDashes")
AddToggle(CombatTab, "No Cooldowns", "NoCooldowns")

AddToggle(VisualsTab, "ESP Highlights", "ESPEnabled")
AddToggle(VisualsTab, "Chams ESP", "ChamsESP")
AddToggle(VisualsTab, "X-Ray Wallhack", "XrayWalls")
AddToggle(VisualsTab, "Hitbox Expander", "HitboxExpander")
AddSlider(VisualsTab, "Hitbox Scale", "HitboxScale", 1, 10, 3, function(v) Cheats.HitboxScale = v end)
AddToggle(VisualsTab, "Fullbright", "Fullbright")
AddToggle(VisualsTab, "Custom FOV", "CustomFOV")
AddSlider(VisualsTab, "FOV Value", "FOVValue", 70, 120, 90, function(v) Cheats.FOVValue = v end)

AddToggle(PerksTab, "Infinite Rerolls", "InfiniteRerolls")
AddToggle(PerksTab, "Sickle Radius", "SickleRadiusOverride")
AddToggle(PerksTab, "Lance Pierce", "InfiniteLancePierce")
AddToggle(PerksTab, "Magnet Pulls All", "MagnetPullsAll")
AddToggle(PerksTab, "Auto Collect Loot", "AutoCollectLoot")

AddToggle(PlayerTab, "Custom WalkSpeed", "CustomWalkSpeed")
AddSlider(PlayerTab, "WalkSpeed Value", "WalkSpeedOverride", 16, 300, 50, function(v) Cheats.WalkSpeedOverride = v end)
AddToggle(PlayerTab, "Custom JumpPower", "CustomJumpPower")
AddSlider(PlayerTab, "JumpPower Value", "JumpPowerOverride", 50, 300, 50, function(v) Cheats.JumpPowerOverride = v end)
AddToggle(PlayerTab, "Infinite Jumps", "InfiniteJumps")
AddToggle(PlayerTab, "Noclip Mode", "Noclip")
AddToggle(PlayerTab, "Fly Mode (Mobile/PC)", "FlyMode")
AddSlider(PlayerTab, "Fly Speed", "FlySpeed", 20, 150, 50, function(v) Cheats.FlySpeed = v end)
AddToggle(PlayerTab, "Bhop Speed Boost", "BhopSpeedBoost")

AddSlider(WorldTab, "Game Timescale", "Timescale", 1, 5, 1, function(v) Cheats.Timescale = v end)
AddToggle(WorldTab, "Auto-Farm Target Loop", "AutoFarmLoop")
AddToggle(WorldTab, "Anti-AFK Protection", "AntiAFK")

AddToggle(DevTab, "Force Developer Mode", "DeveloperMode")
AddToggle(DevTab, "Bypass Server Checks", "BypassChecks")
AddToggle(DevTab, "Unlock All Chests/Loot", "UnlockAllChests")
AddToggle(DevTab, "Infinite Currency/Gold", "InfiniteCurrency")
AddToggle(DevTab, "Debug Console Prints", "DebugConsolePrint")

-- ============================================================================
-- 3. EXECUTION BACKEND
-- ============================================================================
local SpatialHash = {}
SpatialHash.__index = SpatialHash
function SpatialHash.new(cellSize) return setmetatable({_cellSize = cellSize or 8, _cells = {}}, SpatialHash) end
function SpatialHash:Clear() for _, bucket in pairs(self._cells) do table.clear(bucket) end end
function SpatialHash:Insert(entityId, posX, posZ)
    local cellX, cellZ = math.floor(posX / self._cellSize), math.floor(posZ / self._cellSize)
    local cellKey = (cellX + 512) * 1024 + (cellZ + 512)
    if not self._cells[cellKey] then self._cells[cellKey] = {} end
    table.insert(self._cells[cellKey], entityId)
end
function SpatialHash:Query(centerX, centerZ, radius)
    local results, count, cellSize = {}, 0, self._cellSize
    local minX, maxX = math.floor((centerX - radius) / cellSize), math.floor((centerX + radius) / cellSize)
    local minZ, maxZ = math.floor((centerZ - radius) / cellSize), math.floor((centerZ + radius) / cellSize)
    for x = minX, maxX do
        local xOffset = (x + 512) * 1024 + 512
        for z = minZ, maxZ do
            local bucket = self._cells[xOffset + z]
            if bucket then
                for i = 1, #bucket do count += 1; results[count] = bucket[i] end
            end
        end
    end
    return results
end

local AdminGrid = SpatialHash.new(8)
local RunController = nil

task.spawn(function()
    pcall(function()
        local clientScripts = LocalPlayer:WaitForChild("PlayerScripts", 5)
        if clientScripts then
            local client = clientScripts:WaitForChild("Client", 5)
            if client and client:FindFirstChild("Run") then
                RunController = require(client.Run.RunController)
            end
        end
    end)
end)

local function GetRunData()
    if not RunController then return nil end
    local getupvaluesFunc = debug and (debug.getupvalues or getupvalues)
    if not getupvaluesFunc or not RunController.RerollDraft then return nil end
    local success, result = pcall(function()
        for _, uv in ipairs(getupvaluesFunc(RunController.RerollDraft)) do
            if type(uv) == "table" and uv.hp ~= nil then return uv end
        end
        return nil
    end)
    return success and result or nil
end

local function GetSpringInstance()
    if not RunController then return nil end
    local getupvaluesFunc = debug and (debug.getupvalues or getupvalues)
    if not getupvaluesFunc or not RunController.RerollDraft then return nil end
    local success, result = pcall(function()
        for _, uv in ipairs(getupvaluesFunc(RunController.RerollDraft)) do
            if type(uv) == "table" and uv.Target ~= nil and uv.Position ~= nil then return uv end
        end
        return nil
    end)
    return success and result or nil
end

local ActiveHighlights = {}
local function UpdateVisuals(targets)
    local currentTargets = {}
    for _, target in ipairs(targets) do
        if target and target:IsA("Model") and target.Parent then
            currentTargets[target] = true
            if Cheats.ESPEnabled or Cheats.ChamsESP then
                if not ActiveHighlights[target] then
                    local hl = Instance.new("Highlight")
                    hl.Name = "RunEngine_ESP"
                    hl.FillColor = Cheats.ChamsESP and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 50, 50)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = Cheats.ChamsESP and 0.2 or 0.5
                    hl.Adornee = target
                    hl.Parent = target
                    ActiveHighlights[target] = hl
                end
            end
        end
    end

    for model, hl in pairs(ActiveHighlights) do
        if not currentTargets[model] or not model.Parent or (not Cheats.ESPEnabled and not Cheats.ChamsESP) then
            if hl then hl:Destroy() end
            ActiveHighlights[model] = nil
        end
    end
end

task.spawn(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        if Cheats.AntiAFK then
            vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        end
    end)
end)

local FlyBodyVelocity, FlyBodyGyro

UserInputService.JumpRequest:Connect(function()
    if Cheats.InfiniteJumps and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Stepped:Connect(function()
    local runData = GetRunData()
    local spring = GetSpringInstance()
    local char = LocalPlayer.Character

    if runData then
        if Cheats.GodMode then runData.hp = runData.maxHP or 999999 end
        if Cheats.InfiniteRerolls then runData.rerollsLeft = 9999 end
        if Cheats.InfiniteDashes then runData.dashesLeft = 999 end
        if Cheats.NoCooldowns then runData.cooldown = 0 end

        if Cheats.DeveloperMode then
            runData.isDeveloper = true
            runData.godMode = true
        end

        if Cheats.InfiniteCurrency and runData.gold ~= nil then
            runData.gold = 9999999
        end

        if runData.mods then
            runData.mods.damageMult = Cheats.CustomDamageMult
            runData.mods.moveSpeedMult = Cheats.CustomSpeedMult
            if Cheats.SickleRadiusOverride then runData.mods.magnetRadius = 250 end
            if Cheats.MagnetPullsAll then runData.mods.globalMagnet = true end
            if Cheats.InfiniteLancePierce then runData.mods.lancePierce = 999 end
            if Cheats.AutoCollectLoot or Cheats.UnlockAllChests then runData.mods.magnetRadius = 9999 end
        end
    end

    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")

        if humanoid then
            if Cheats.CustomWalkSpeed then humanoid.WalkSpeed = Cheats.WalkSpeedOverride end
            if Cheats.CustomJumpPower then
                if humanoid.UseJumpPower then humanoid.JumpPower = Cheats.JumpPowerOverride
                else humanoid.JumpHeight = Cheats.JumpPowerOverride / 4 end
            end
        end

        if Cheats.Noclip then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
            end
        end

        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(char) then
                if Cheats.XrayWalls then
                    if part.Transparency < 0.5 then part.LocalTransparencyModifier = 0.5 end
                else
                    part.LocalTransparencyModifier = 0
                end
            end
        end

        if Cheats.FlyMode and hrp then
            if not FlyBodyVelocity then
                FlyBodyVelocity = Instance.new("BodyVelocity")
                FlyBodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
                FlyBodyVelocity.Parent = hrp
            end
            if not FlyBodyGyro then
                FlyBodyGyro = Instance.new("BodyGyro")
                FlyBodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
                FlyBodyGyro.Parent = hrp
            end
            
            local moveVector = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector += Camera.CFrame.RightVector end
            
            FlyBodyVelocity.Velocity = moveVector * Cheats.FlySpeed
            FlyBodyGyro.CFrame = Camera.CFrame
        else
            if FlyBodyVelocity then FlyBodyVelocity:Destroy(); FlyBodyVelocity = nil end
            if FlyBodyGyro then FlyBodyGyro:Destroy(); FlyBodyGyro = nil end
        end

        if hrp then
            AdminGrid:Clear()
            for _, model in ipairs(Workspace:GetChildren()) do
                if model:IsA("Model") and model ~= char and model:FindFirstChild("HumanoidRootPart") then
                    local targetHRP = model.HumanoidRootPart
                    local targetHum = model:FindFirstChildOfClass("Humanoid")
                    
                    if Cheats.HitboxExpander then
                        targetHRP.Size = Vector3.new(Cheats.HitboxScale, Cheats.HitboxScale, Cheats.HitboxScale)
                        targetHRP.Transparency = 0.6
                        targetHRP.CanCollide = false
                    end

                    if (Cheats.InstantKillBosses or Cheats.GlobalHitscanKill) and targetHum then
                        targetHum.Health = 0
                    end

                    AdminGrid:Insert(model, targetHRP.Position.X, targetHRP.Position.Z)
                end
            end

            local targets = AdminGrid:Query(hrp.Position.X, hrp.Position.Z, Cheats.AuraRadius)
            UpdateVisuals(targets)

            if Cheats.SpatialAura then
                for _, target in ipairs(targets) do
                    local hum = target:FindFirstChildOfClass("Humanoid")
                    if hum then hum.Health = 0 end
                end
            end

            if Cheats.AutoFarmLoop and #targets > 0 then
                local closestTarget = targets[1]
                if closestTarget and closestTarget:FindFirstChild("HumanoidRootPart") then
                    hrp.CFrame = CFrame.new(hrp.CFrame.Position, Vector3.new(closestTarget.HumanoidRootPart.Position.X, hrp.Position.Y, closestTarget.HumanoidRootPart.Position.Z))
                end
            end
        end
    end

    if Cheats.CustomFOV then
        Camera.FieldOfView = Cheats.FOVValue
    end

    if spring then spring.Target = Cheats.Timescale end
    if Cheats.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
    end
end)
