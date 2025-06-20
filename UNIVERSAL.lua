-- WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Gradient Function
function gradient(text, startColor, endColor)
    local result = ""
    local length = #text

    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)

        local char = text:sub(i, i)
        result = result .. "<font color=\"rgb(" .. r ..", " .. g .. ", " .. b .. ")\">" .. char .. "</font>"
    end

    return result
end

-- Confirmation Popup
local Confirmed = false
WindUI:Popup({
    Title = gradient("SNT&MIRROZZ HUB", Color3.fromHex("#eb1010"), Color3.fromHex("#1023eb")),
    Icon = "info",
    Content = gradient("This script made by", Color3.fromHex("#10eb3c"), Color3.fromHex("#67c97a")) .. gradient(" SnowT", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Buttons = {
        {
            Title = gradient("Cancel", Color3.fromHex("#e80909"), Color3.fromHex("#630404")),
            Callback = function() end,
            Variant = "Tertiary",
        },
        {
            Title = gradient("Load", Color3.fromHex("#90f09e"), Color3.fromHex("#13ed34")),
            Callback = function() Confirmed = true end,
            Variant = "Secondary",
        }
    }
})

repeat task.wait() until Confirmed

WindUI:Notify({
    Title = gradient("SNT&MIRROZZ HUB", Color3.fromHex("#eb1010"), Color3.fromHex("#1023eb")),
    Content = "Script successfully loaded!",
    Icon = "check-circle",
    Duration = 3
})

-- Create Window
local Window = WindUI:CreateWindow({
    Title = gradient("SNT&MIRROZZ HUB", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Icon = "infinity",
    Author = gradient("UNIVERSAL | Version: 2.0", Color3.fromHex("#1bf2b2"), Color3.fromHex("#1bcbf2")),
    Folder = "WindUI",
    Size = UDim2.fromOffset(300, 270),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    Background = "", -- rbxassetid only
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },
})

-- Open Button
Window:EditOpenButton({
    Title = "Open UI",
    Icon = "monitor",
    CornerRadius = UDim.new(2, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("1E213D"), Color3.fromHex("1F75FE")),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

-- Tabs
local Tabs = {
    MainTab = Window:Tab({ Title = gradient("MAIN", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "terminal" }),
    CharacterTab = Window:Tab({ Title = gradient("CHARACTER", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "file-cog" }),
    TeleportTab = Window:Tab({ Title = gradient("TELEPORT", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "user" }),
    EspTab = Window:Tab({ Title = gradient("ESP", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "eye" }),
    AimbotTab = Window:Tab({ Title = gradient("AIMBOT", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "arrow-right" }),
    FlyTab = Window:Tab({ Title = gradient("FLY", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "rocket" }),
    TrollTab = Window:Tab({ Title = gradient("TROLL", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "box" }),
    bs = Window:Divider(),
    ServerTab = Window:Tab({ Title = gradient("SERVER", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "atom" }),
    SettingsTwab = Window:Tab({ Title = gradient("SETTINGS", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "code" }),
    ChangelogsTab = Window:Tab({ Title = gradient("CHANGELOGS", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "info"}),
    SocialsTab = Window:Tab({ Title = gradient("SOCIALS", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "star"}),
    be = Window:Divider(),
    WindowTab = Window:Tab({ Title = gradient("CONFIGURATION", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "settings", Desc = "Manage window settings and file configurations." }),
    CreateThemeTab = Window:Tab({ Title = gradient("THEMES", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "palette", Desc = "Design and apply custom themes." }),
}

-- Main
local MainTab = Tabs.MainTab
local StatsService = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Drawing = loadstring(game:HttpGet("https://raw.githubusercontent.com/Roblox/Core-Scripts/master/CoreScriptsRoot/Libraries/Drawing.lua"))()

local folderPath = "WindUI/Coordinates"
makefolder(folderPath)

-- Player Info
local PlayerInfo = {
    FPS = 0,
    Ping = 0,
    InjectTime = tick(),
    CurrentPlayers = 0,
    MaxPlayers = Players.MaxPlayers,
}

-- Helper: Get Local Time of Day
local function GetLocalTimeOfDay()
    local time = os.date("*t")
    local hour = time.hour
    local period = hour >= 12 and "PM" or "AM"
    hour = hour % 12
    if hour == 0 then hour = 12 end
    local timeOfDay
    if hour >= 6 and hour < 12 and period == "AM" then
        timeOfDay = "Morning"
    elseif hour >= 12 and hour < 6 and period == "PM" then
        timeOfDay = "Afternoon"
    elseif hour >= 6 and hour < 10 and period == "PM" then
        timeOfDay = "Evening"
    else
        timeOfDay = "Night"
    end
    return string.format("%02d:%02d:%02d %s (%s)", hour, time.min, time.sec, period, timeOfDay)
end

-- Helper: Format Time Since Inject
local function FormatTimeSinceInject()
    local elapsed = tick() - PlayerInfo.InjectTime
    local hours = math.floor(elapsed / 3600)
    local minutes = math.floor((elapsed % 3600) / 60)
    local seconds = math.floor(elapsed % 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

-- Helper: Save Telegram Username
local function SaveTelegramUsername(username)
    if username == "" then
        WindUI:Notify({Title = "Login", Content = "Please enter a Telegram username", Icon = "x-circle"})
        return
    end
    local filePath = "WindUI/Login/" .. username .. ".json"
    local data = { Username = username }
    local success, err = pcall(function()
        writefile(filePath, HttpService:JSONEncode(data))
    end)
    if success then
        WindUI:Notify({Title = "Login", Content = "Username '" .. username .. "' saved successfully!", Icon = "check-circle"})
    else
        WindUI:Notify({Title = "Login", Content = "Failed to save username: " .. tostring(err), Icon = "x-circle"})
    end
end

-- Helper: List Saved Usernames
local function ListSavedUsernames()
    local usernames = {}
    for _, file in ipairs(listfiles("WindUI/Login")) do
        local username = file:match("([^/]+)%.json$")
        if username then
            table.insert(usernames, username)
        end
    end
    return usernames
end

-- Helper: Verify Username
local function VerifyUsername(username)
    WindUI:Notify({Title = "Login", Content = "Verification for '" .. username .. "' is not yet implemented", Icon = "alert-circle"})
end

-- Player Information Section
Tabs.MainTab:Section({Title = gradient("Player Information", Color3.fromHex("#ffffff"), Color3.fromHex("#636363"))})

-- FPS Paragraph
local fpsParagraph = Tabs.MainTab:Paragraph({
    Title = gradient("FPS", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Desc = "FPS: Calculating...",
    Color = "Grey",
    Image = "info",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {}
})

-- Ping Paragraph
local pingParagraph = Tabs.MainTab:Paragraph({
    Title = gradient("Ping", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Desc = "Ping: Calculating...",
    Color = "Grey",
    Image = "info",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {}
})

-- Time Since Inject Paragraph
local injectTimeParagraph = Tabs.MainTab:Paragraph({
    Title = gradient("Time Since Inject", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Desc = "Time: 00:00:00",
    Color = "Grey",
    Image = "info",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {}
})

-- Local Time Paragraph
local localTimeParagraph = Tabs.MainTab:Paragraph({
    Title = gradient("Local Time", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Desc = "Time: Calculating...",
    Color = "Grey",
    Image = "info",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {}
})

-- Current Players Paragraph
local currentPlayersParagraph = Tabs.MainTab:Paragraph({
    Title = gradient("Current Players", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Desc = "Players: Calculating...",
    Color = "Grey",
    Image = "info",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {}
})

-- Max Players Paragraph
local maxPlayersParagraph = Tabs.MainTab:Paragraph({
    Title = gradient("Max Players", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")),
    Desc = string.format("Max Players: %d", PlayerInfo.MaxPlayers),
    Color = "Grey",
    Image = "info",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {}
})

-- Update Loop for Player Info
local lastUpdate = 0
RunService.Heartbeat:Connect(function()
    if tick() - lastUpdate < 0.5 then return end
    lastUpdate = tick()

    PlayerInfo.FPS = 1 / RunService.RenderStepped:Wait()
    PlayerInfo.Ping = StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
    PlayerInfo.CurrentPlayers = #Players:GetPlayers()

    fpsParagraph:SetDesc(string.format("FPS: %.1f", PlayerInfo.FPS))
    pingParagraph:SetDesc(string.format("Ping: %.1f ms", PlayerInfo.Ping))
    injectTimeParagraph:SetDesc(string.format("Time: %s", FormatTimeSinceInject()))
    localTimeParagraph:SetDesc(string.format("Time: %s", GetLocalTimeOfDay()))
    currentPlayersParagraph:SetDesc(string.format("Players: %d", PlayerInfo.CurrentPlayers))
end)

-- Character Tab
local CharacterSettings = {
    WalkSpeed = {Value = 16, Default = 16, Locked = false, Bypass = false},
    JumpPower = {Value = 50, Default = 50, Locked = false, Bypass = false},
    Gravity = {Value = 196.2, Default = 196.2, Locked = false, Bypass = false},
}

local function updateCharacter()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if not CharacterSettings.WalkSpeed.Locked then
            humanoid.WalkSpeed = CharacterSettings.WalkSpeed.Value
        end
        if not CharacterSettings.JumpPower.Locked then
            humanoid.JumpPower = CharacterSettings.JumpPower.Value
        end
    end
    if not CharacterSettings.Gravity.Locked then
        Workspace.Gravity = CharacterSettings.Gravity.Value
    end
end

-- Bypass Loop
RunService.Heartbeat:Connect(function()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if CharacterSettings.WalkSpeed.Bypass then
            humanoid.WalkSpeed = CharacterSettings.WalkSpeed.Value
        end
        if CharacterSettings.JumpPower.Bypass then
            humanoid.JumpPower = CharacterSettings.JumpPower.Value
        end
    end
    if CharacterSettings.Gravity.Bypass then
        Workspace.Gravity = CharacterSettings.Gravity.Value
    end
end)

-- Character Tab: Walkspeed Section
Tabs.CharacterTab:Section({Title = gradient("Walkspeed", Color3.fromHex("#ff0000"), Color3.fromHex("#300000"))})

Tabs.CharacterTab:Slider({
    Title = "Walkspeed",
    Value = {Min = 0, Max = 200, Default = 16},
    Callback = function(value)
        CharacterSettings.WalkSpeed.Value = value
        updateCharacter()
    end
})

Tabs.CharacterTab:Button({
    Title = "Reset Walkspeed",
    Callback = function()
        CharacterSettings.WalkSpeed.Value = CharacterSettings.WalkSpeed.Default
        updateCharacter()
    end
})

Tabs.CharacterTab:Toggle({
    Title = "Lock Walkspeed",
    Default = false,
    Callback = function(state)
        CharacterSettings.WalkSpeed.Locked = state
        updateCharacter()
    end
})

Tabs.CharacterTab:Toggle({
    Title = "Walkspeed Bypasser",
    Default = false,
    Callback = function(state)
        CharacterSettings.WalkSpeed.Bypass = state
        updateCharacter()
    end
})

-- Character Tab: JumpPower Section
Tabs.CharacterTab:Section({Title = gradient("JumpPower", Color3.fromHex("#001aff"), Color3.fromHex("#020524"))})

Tabs.CharacterTab:Slider({
    Title = "JumpPower",
    Value = {Min = 0, Max = 200, Default = 50},
    Callback = function(value)
        CharacterSettings.JumpPower.Value = value
        updateCharacter()
    end
})

Tabs.CharacterTab:Button({
    Title = "Reset JumpPower",
    Callback = function()
        CharacterSettings.JumpPower.Value = CharacterSettings.JumpPower.Default
        updateCharacter()
    end
})

Tabs.CharacterTab:Toggle({
    Title = "Lock JumpPower",
    Default = false,
    Callback = function(state)
        CharacterSettings.JumpPower.Locked = state
        updateCharacter()
    end
})

Tabs.CharacterTab:Toggle({
    Title = "JumpPower Bypasser",
    Default = false,
    Callback = function(state)
        CharacterSettings.JumpPower.Bypass = state
        updateCharacter()
    end
})

-- Character Tab: Gravity Section
Tabs.CharacterTab:Section({Title = gradient("Gravity", Color3.fromHex("#001aff"), Color3.fromHex("#020524"))})

Tabs.CharacterTab:Slider({
    Title = "Gravity",
    Value = {Min = 0, Max = 392.4, Default = 196.2, Step = 0.1},
    Callback = function(value)
        CharacterSettings.Gravity.Value = value
        updateCharacter()
    end
})

Tabs.CharacterTab:Button({
    Title = "Reset Gravity",
    Callback = function()
        CharacterSettings.Gravity.Value = CharacterSettings.Gravity.Default
        updateCharacter()
    end
})

Tabs.CharacterTab:Toggle({
    Title = "Lock Gravity",
    Default = false,
    Callback = function(state)
        CharacterSettings.Gravity.Locked = state
        updateCharacter()
    end
})

Tabs.CharacterTab:Toggle({
    Title = "Gravity Bypasser",
    Default = false,
    Callback = function(state)
        CharacterSettings.Gravity.Bypass = state
        updateCharacter()
    end
})

-- Teleport Tab
local TeleportPlayerList = {}
local function UpdatePlayerList()
    TeleportPlayerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(TeleportPlayerList, player.Name)
        end
    end
    return TeleportPlayerList
end

local function ListCoordinateFiles()
    local files = {}
    for _, file in ipairs(listfiles(folderPath)) do
        local filename = file:match("([^/]+)%.json$")
        if filename then
            table.insert(files, filename)
        end
    end
    return files
end

local function SaveCoordinates(filename, coords)
    if filename == "" then
        WindUI:Notify({Title = "Coordinates", Content = "Please enter a file name", Icon = "x-circle"})
        return
    end
    local filePath = folderPath .. "/" .. filename .. ".json"
    local data = { X = coords.X, Y = coords.Y, Z = coords.Z }
    local success, err = pcall(function()
        writefile(filePath, HttpService:JSONEncode(data))
    end)
    if success then
        WindUI:Notify({Title = "Coordinates", Content = "Coordinates saved to '" .. filename .. "'", Icon = "check-circle"})
    else
        WindUI:Notify({Title = "Coordinates", Content = "Failed to save coordinates: " .. tostring(err), Icon = "x-circle"})
    end
end

local function LoadCoordinates(filename)
    local filePath = folderPath .. "/" .. filename .. ".json"
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(filePath))
    end)
    if success then
        return Vector3.new(data.X, data.Y, data.Z)
    else
        WindUI:Notify({Title = "Coordinates", Content = "Failed to load coordinates: " .. tostring(data), Icon = "x-circle"})
        return nil
    end
end

Tabs.TeleportTab:Section({Title = gradient("Players", Color3.fromHex("#001aff"), Color3.fromHex("#020524"))})

local teleportDropdown = Tabs.TeleportTab:Dropdown({
    Title = "Players",
    Values = UpdatePlayerList(),
    Value = "Select Player",
    Callback = function(selected)
        -- Store selected player for teleport
    end
})

Tabs.TeleportTab:Button({
    Title = "Teleport to Player",
    Callback = function()
        local selected = teleportDropdown.Value
        if selected and selected ~= "Select Player" then
            local targetPlayer = Players:FindFirstChild(selected)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                WindUI:Notify({Title = "Teleport", Content = "Teleported to " .. selected, Icon = "check-circle"})
            else
                WindUI:Notify({Title = "Teleport", Content = "Player not found or invalid", Icon = "x-circle"})
            end
        else
            WindUI:Notify({Title = "Teleport", Content = "Please select a player", Icon = "x-circle"})
        end
    end
})

Tabs.TeleportTab:Button({
    Title = "Update Players List",
    Callback = function()
        teleportDropdown:Refresh(UpdatePlayerList())
    end
})

-- Coordinate Management Section
Tabs.TeleportTab:Section({Title = gradient("Coordinate Management", Color3.fromHex("#b914fa"), Color3.fromHex("#7023c2"))})

local currentFileName = ""
Tabs.TeleportTab:Input({
    Title = "Coordinate File Name",
    PlaceholderText = "Enter file name",
    Callback = function(text)
        currentFileName = text
    end
})

Tabs.TeleportTab:Button({
    Title = "Save Current Coordinates",
    Callback = function()
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local pos = character.HumanoidRootPart.Position
            SaveCoordinates(currentFileName, pos)
        else
            WindUI:Notify({Title = "Coordinates", Content = "Cannot save coordinates: No character found", Icon = "x-circle"})
        end
    end
})

Tabs.TeleportTab:Button({
    Title = "Copy Current Coordinates",
    Callback = function()
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local pos = character.HumanoidRootPart.Position
            setclipboard(string.format("X: %.1f, Y: %.1f, Z: %.1f", pos.X, pos.Y, pos.Z))
            WindUI:Notify({Title = "Coordinates", Content = "Coordinates copied to clipboard", Icon = "check-circle"})
        else
            WindUI:Notify({Title = "Coordinates", Content = "Cannot copy coordinates: No character found", Icon = "x-circle"})
        end
    end
})

local coordFilesDropdown
coordFilesDropdown = Tabs.TeleportTab:Dropdown({
    Title = "Saved Coordinates",
    Multi = false,
    AllowNone = true,
    Values = ListCoordinateFiles(),
    Callback = function(selected)
        if selected then
            local coords = LoadCoordinates(selected)
            if coords then
                Tabs.TeleportTab.XSlider:SetValue(coords.X)
                Tabs.TeleportTab.YSlider:SetValue(coords.Y)
                Tabs.TeleportTab.ZSlider:SetValue(coords.Z)
            end
        end
    end
})

Tabs.TeleportTab:Button({
    Title = "Refresh Coordinates List",
    Callback = function()
        coordFilesDropdown:Refresh(ListCoordinateFiles())
    end
})

Tabs.TeleportTab.XSlider = Tabs.TeleportTab:Slider({
    Title = "X Coordinate",
    Value = {Min = -10000, Max = 10000, Default = 0, Step = 0.1},
    Callback = function(value)
        -- Store X coordinate
    end
})

Tabs.TeleportTab.YSlider = Tabs.TeleportTab:Slider({
    Title = "Y Coordinate",
    Value = {Min = -10000, Max = 10000, Default = 0, Step = 0.1},
    Callback = function(value)
        -- Store Y coordinate
    end
})

Tabs.TeleportTab.ZSlider = Tabs.TeleportTab:Slider({
    Title = "Z Coordinate",
    Value = {Min = -10000, Max = 10000, Default = 0, Step = 0.1},
    Callback = function(value)
        -- Store Z coordinate
    end
})

Tabs.TeleportTab:Button({
    Title = "TP to Coordinates",
    Callback = function()
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local x = Tabs.TeleportTab.XSlider.Value
            local y = Tabs.TeleportTab.YSlider.Value
            local z = Tabs.TeleportTab.ZSlider.Value
            character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(x, y, z))
            WindUI:Notify({Title = "Teleport", Content = "Teleported to coordinates", Icon = "check-circle"})
        else
            WindUI:Notify({Title = "Teleport", Content = "Cannot teleport: No character found", Icon = "x-circle"})
        end
    end
})

-- ESP Tab
local ESPSettings = {
    Highlight = {Enabled = false, Transparency = 0.5, Color = Color3.new(1, 0, 0)},
    Distance = {Enabled = false, Transparency = 0.5, TextSize = 14, Color = Color3.new(1, 0, 0)},
    Names = {Enabled = false, Transparency = 0.5, TextSize = 14, Color = Color3.new(1, 0, 0)},
    Tracers = {Enabled = false, Transparency = 0.5, Thickness = 1, Color = Color3.new(1, 0, 0)},
    Boxes = {Enabled = false, Transparency = 0.5, Size = 1, Color = Color3.new(1, 0, 0)},
    Skeleton = {Enabled = false, Transparency = 0.5, Color = Color3.new(1, 0, 0)},
    ShowDistance = 1500
}

local ESPObjects = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    ESPObjects[player] = {
        Highlight = Instance.new("Highlight"),
        DistanceLabel = Drawing.new("Text"),
        NameLabel = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
        Box = {
            Top = Drawing.new("Line"),
            Bottom = Drawing.new("Line"),
            Left = Drawing.new("Line"),
            Right = Drawing.new("Line")
        },
        Skeleton = {
            Head = Drawing.new("Line"),
            Torso = Drawing.new("Line"),
            LeftArm = Drawing.new("Line"),
            RightArm = Drawing.new("Line"),
            LeftLeg = Drawing.new("Line"),
            RightLeg = Drawing.new("Line")
        }
    }
    
    ESPObjects[player].Highlight.Adornee = player.Character
    ESPObjects[player].Highlight.Parent = player.Character
    ESPObjects[player].Highlight.Enabled = false
end

local function RemoveESP(player)
    if ESPObjects[player] then
        ESPObjects[player].Highlight:Destroy()
        ESPObjects[player].DistanceLabel:Remove()
        ESPObjects[player].NameLabel:Remove()
        ESPObjects[player].Tracer:Remove()
        for _, line in pairs(ESPObjects[player].Box) do
            line:Remove()
        end
        for _, line in pairs(ESPObjects[player].Skeleton) do
            line:Remove()
        end
        ESPObjects[player] = nil
    end
end

local function UpdateESP()
    for player, esp in pairs(ESPObjects) do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not player.Character:FindFirstChild("Head") then
            for _, obj in pairs(esp.Box) do obj.Visible = false end
            for _, obj in pairs(esp.Skeleton) do obj.Visible = false end
            esp.Highlight.Enabled = false
            esp.DistanceLabel.Visible = false
            esp.NameLabel.Visible = false
            esp.Tracer.Visible = false
            continue
        end

        local rootPart = player.Character.HumanoidRootPart
        local head = player.Character.Head
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude

        if distance > ESPSettings.ShowDistance then
            for _, obj in pairs(esp.Box) do obj.Visible = false end
            for _, obj in pairs(esp.Skeleton) do obj.Visible = false end
            esp.Highlight.Enabled = false
            esp.DistanceLabel.Visible = false
            esp.NameLabel.Visible = false
            esp.Tracer.Visible = false
            continue
        end

        local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
        local headPos = Camera:WorldToViewportPoint(head.Position)
        local torsoPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 1, 0))

        -- Highlight
        esp.Highlight.Enabled = ESPSettings.Highlight.Enabled and onScreen
        esp.Highlight.FillTransparency = ESPSettings.Highlight.Transparency
        esp.Highlight.OutlineColor = ESPSettings.Highlight.Color
        esp.Highlight.FillColor = ESPSettings.Highlight.Color

        -- Distance
        esp.DistanceLabel.Visible = ESPSettings.Distance.Enabled and onScreen
        if esp.DistanceLabel.Visible then
            esp.DistanceLabel.Text = string.format("%.1f studs", distance)
            esp.DistanceLabel.Position = Vector2.new(rootPos.X, rootPos.Y + 20)
            esp.DistanceLabel.Size = ESPSettings.Distance.TextSize
            esp.DistanceLabel.Transparency = ESPSettings.Distance.Transparency
            esp.DistanceLabel.Color = ESPSettings.Distance.Color
            esp.DistanceLabel.Center = true
        end

        -- Names
        esp.NameLabel.Visible = ESPSettings.Names.Enabled and onScreen
        if esp.NameLabel.Visible then
            esp.NameLabel.Text = player.Name
            esp.NameLabel.Position = Vector2.new(headPos.X, headPos.Y - 20)
            esp.NameLabel.Size = ESPSettings.Names.TextSize
            esp.NameLabel.Transparency = ESPSettings.Names.Transparency
            esp.NameLabel.Color = ESPSettings.Names.Color
            esp.NameLabel.Center = true
        end
        -- Tracers
        esp.Tracer.Visible = ESPSettings.Tracers.Enabled and onScreen
        if esp.Tracer.Visible then
            esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            esp.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
            esp.Tracer.Thickness = ESPSettings.Tracers.Thickness
            esp.Tracer.Transparency = ESPSettings.Tracers.Transparency
            esp.Tracer.Color = ESPSettings.Tracers.Color
        end

        -- Boxes
        local boxSize = ESPSettings.Boxes.Size * 100
        local topLeft = Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(-1, 2, 0) * ESPSettings.Boxes.Size)
        local topRight = Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(1, 2, 0) * ESPSettings.Boxes.Size)
        local bottomLeft = Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(-1, -2, 0) * ESPSettings.Boxes.Size)
        local bottomRight = Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(1, -2, 0) * ESPSettings.Boxes.Size)
        
        esp.Box.Top.Visible = ESPSettings.Boxes.Enabled and onScreen
        esp.Box.Bottom.Visible = ESPSettings.Boxes.Enabled and onScreen
        esp.Box.Left.Visible = ESPSettings.Boxes.Enabled and onScreen
        esp.Box.Right.Visible = ESPSettings.Boxes.Enabled and onScreen

        if esp.Box.Top.Visible then
            esp.Box.Top.From = Vector2.new(topLeft.X, topLeft.Y)
            esp.Box.Top.To = Vector2.new(topRight.X, topRight.Y)
            esp.Box.Top.Thickness = ESPSettings.Boxes.Size
            esp.Box.Top.Transparency = ESPSettings.Boxes.Transparency
            esp.Box.Top.Color = ESPSettings.Boxes.Color

            esp.Box.Bottom.From = Vector2.new(bottomLeft.X, bottomLeft.Y)
            esp.Box.Bottom.To = Vector2.new(bottomRight.X, bottomRight.Y)
            esp.Box.Bottom.Thickness = ESPSettings.Boxes.Size
            esp.Box.Bottom.Transparency = ESPSettings.Boxes.Transparency
            esp.Box.Bottom.Color = ESPSettings.Boxes.Color

            esp.Box.Left.From = Vector2.new(topLeft.X, topLeft.Y)
            esp.Box.Left.To = Vector2.new(bottomLeft.X, bottomLeft.Y)
            esp.Box.Left.Thickness = ESPSettings.Boxes.Size
            esp.Box.Left.Transparency = ESPSettings.Boxes.Transparency
            esp.Box.Left.Color = ESPSettings.Boxes.Color

            esp.Box.Right.From = Vector2.new(topRight.X, topRight.Y)
            esp.Box.Right.To = Vector2.new(bottomRight.X, bottomRight.Y)
            esp.Box.Right.Thickness = ESPSettings.Boxes.Size
            esp.Box.Right.Transparency = ESPSettings.Boxes.Transparency
            esp.Box.Right.Color = ESPSettings.Boxes.Color
        end

        -- Skeleton
        local function drawBone(fromPart, toPart, bone)
            if not fromPart or not toPart then
                bone.Visible = false
                return
            end
            local fromPos = Camera:WorldToViewportPoint(fromPart.Position)
            local toPos = Camera:WorldToViewportPoint(toPart.Position)
            bone.Visible = ESPSettings.Skeleton.Enabled and onScreen
            if bone.Visible then
                bone.From = Vector2.new(fromPos.X, fromPos.Y)
                bone.To = Vector2.new(toPos.X, toPos.Y)
                bone.Thickness = 1
                bone.Transparency = ESPSettings.Skeleton.Transparency
                bone.Color = ESPSettings.Skeleton.Color
            end
        end

        if ESPSettings.Skeleton.Enabled and player.Character then
            local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
            local leftArm = player.Character:FindFirstChild("Left Arm") or player.Character:FindFirstChild("LeftUpperArm")
            local rightArm = player.Character:FindFirstChild("Right Arm") or player.Character:FindFirstChild("RightUpperArm")
            local leftLeg = player.Character:FindFirstChild("Left Leg") or player.Character:FindFirstChild("LeftUpperLeg")
            local rightLeg = player.Character:FindFirstChild("Right Leg") or player.Character:FindFirstChild("RightUpperLeg")

            drawBone(head, torso, esp.Skeleton.Head)
            drawBone(torso, rootPart, esp.Skeleton.Torso)
            drawBone(torso, leftArm, esp.Skeleton.LeftArm)
            drawBone(torso, rightArm, esp.Skeleton.RightArm)
            drawBone(rootPart, leftLeg, esp.Skeleton.LeftLeg)
            drawBone(rootPart, rightLeg, esp.Skeleton.RightLeg)
        else
            for _, bone in pairs(esp.Skeleton) do
                bone.Visible = false
            end
        end
    end
end

-- Initialize ESP for existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

-- Handle player joining
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end)

-- Handle player leaving
Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- Update ESP visuals
RunService.RenderStepped:Connect(UpdateESP)

-- ESP Tab
Tabs.EspTab:Section({Title = gradient("ESP", Color3.fromHex("#ff0000"), Color3.fromHex("#300000"))})

Tabs.EspTab:Toggle({
    Title = "Highlight",
    Default = false,
    Callback = function(state)
        ESPSettings.Highlight.Enabled = state
    end
})

Tabs.EspTab:Toggle({
    Title = "Distance",
    Default = false,
    Callback = function(state)
        ESPSettings.Distance.Enabled = state
    end
})

Tabs.EspTab:Toggle({
    Title = "Names",
    Default = false,
    Callback = function(state)
        ESPSettings.Names.Enabled = state
    end
})

Tabs.EspTab:Toggle({
    Title = "Tracers",
    Default = false,
    Callback = function(state)
        ESPSettings.Tracers.Enabled = state
    end
})

Tabs.EspTab:Toggle({
    Title = "Boxes",
    Default = false,
    Callback = function(state)
        ESPSettings.Boxes.Enabled = state
    end
})

Tabs.EspTab:Toggle({
    Title = "Skeleton [Beta]",
    Default = false,
    Callback = function(state)
        ESPSettings.Skeleton.Enabled = state
    end
})

-- ESP Settings
Tabs.EspTab:Section({Title = gradient("SETTINGS", Color3.fromHex("#001aff"), Color3.fromHex("#020524"))})

Tabs.EspTab:Slider({
    Title = "Highlight Transparency",
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.5},
    Callback = function(value)
        ESPSettings.Highlight.Transparency = value
    end
})

Tabs.EspTab:Colorpicker({
    Title = "Highlight Color",
    Default = Color3.new(1, 0, 0),
    Callback = function(col)
        ESPSettings.Highlight.Color = col
    end
})

Tabs.EspTab:Slider({
    Title = "Distance Transparency",
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.5},
    Callback = function(value)
        ESPSettings.Distance.Transparency = value
    end
})

Tabs.EspTab:Slider({
    Title = "Distance Text Size",
    Step = 1,
    Value = {Min = 10, Max = 30, Default = 14},
    Callback = function(value)
        ESPSettings.Distance.TextSize = value
    end
})

Tabs.EspTab:Colorpicker({
    Title = "Distance Color",
    Default = Color3.new(1, 0, 0),
    Callback = function(col)
        ESPSettings.Distance.Color = col
    end
})

Tabs.EspTab:Slider({
    Title = "Names Transparency",
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.5},
    Callback = function(value)
        ESPSettings.Names.Transparency = value
    end
})

Tabs.EspTab:Slider({
    Title = "Names Text Size",
    Step = 1,
    Value = {Min = 10, Max = 30, Default = 14},
    Callback = function(value)
        ESPSettings.Names.TextSize = value
    end
})

Tabs.EspTab:Colorpicker({
    Title = "Names Color",
    Default = Color3.new(1, 0, 0),
    Callback = function(col)
        ESPSettings.Names.Color = col
    end
})

Tabs.EspTab:Slider({
    Title = "Tracers Transparency",
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.5},
    Callback = function(value)
        ESPSettings.Tracers.Transparency = value
    end
})

Tabs.EspTab:Slider({
    Title = "Tracers Thickness",
    Step = 0.1,
    Value = {Min = 0.5, Max = 5, Default = 1},
    Callback = function(value)
        ESPSettings.Tracers.Thickness = value
    end
})

Tabs.EspTab:Colorpicker({
    Title = "Tracers Color",
    Default = Color3.new(1, 0, 0),
    Callback = function(col)
        ESPSettings.Tracers.Color = col
    end
})

Tabs.EspTab:Slider({
    Title = "Boxes Transparency",
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.5},
    Callback = function(value)
        ESPSettings.Boxes.Transparency = value
    end
})

Tabs.EspTab:Slider({
    Title = "Boxes Size",
    Step = 0.1,
    Value = {Min = 0.5, Max = 2, Default = 1},
    Callback = function(value)
        ESPSettings.Boxes.Size = value
    end
})

Tabs.EspTab:Colorpicker({
    Title = "Boxes Color",
    Default = Color3.new(1, 0, 0),
    Callback = function(col)
        ESPSettings.Boxes.Color = col
    end
})

Tabs.EspTab:Slider({
    Title = "Skeletons Transparency",
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.5},
    Callback = function(value)
        ESPSettings.Skeleton.Transparency = value
    end
})

Tabs.EspTab:Colorpicker({
    Title = "Skeletons Color",
    Default = Color3.new(1, 0, 0),
    Callback = function(col)
        ESPSettings.Skeleton.Color = col
    end
})

Tabs.EspTab:Slider({
    Title = "ESP Show Distance",
    Step = 10,
    Value = {Min = 200, Max = 10000, Default = 1500},
    Callback = function(value)
        ESPSettings.ShowDistance = value
    end
})