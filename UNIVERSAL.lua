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
    SettingsTab = Window:Tab({ Title = gradient("SETTINGS", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "code" }),
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
        local character = LocalPlayer
        if character and character.Character and character.Character:FindFirstChild("HumanoidRootPart") then
            local pos = character.Character.HumanoidRootPart.Position
            setclipboard(string.format("X: %.1f, Y: %.1f, Z: %.1f", pos.X, pos.Y, pos.Z))
            WindUI:Notify({Title = "Coordinates", Content = "Coordinates copied to clipboard", Icon = "check-circle"})
        else
            WindUI:Notify({Title = "Coordinates", Content = "Cannot copy coordinates: No character found", Icon = "x-circle"})
        end
    end
})

local coordDropdown
coordDropdown = Tabs.TeleportTab:Dropdown({
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
        coordDropdown:Refresh(ListCoordinateFiles())
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
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Configuration storage
local ESPConfig = {
    Highlight = false,
    Distance = false,
    Names = false,
    Tracers = false,
    HighlightTransparency = 0.5,
    HighlightColor = Color3.new(1, 0, 0),
    DistanceTransparency = 0.5,
    DistanceTextSize = 14,
    DistanceColor = Color3.new(1, 0, 0),
    NamesTransparency = 0.5,
    NamesTextSize = 14,
    NamesColor = Color3.new(1, 0, 0),
    TracersTransparency = 0.5,
    TracersThickness = 0.05,
    TracersColor = Color3.new(1, 0, 0)
}

-- Cache for player ESP data
local ESPData = {}
local Connections = {}

-- Create Drawing objects pool for optimization
local DrawingPool = {
    Lines = {},
    Texts = {},
    Active = {},
    Available = {}
}

-- Initialize Drawing pool
local function createDrawingObject(type)
    local obj
    if #DrawingPool.Available > 0 then
        obj = table.remove(DrawingPool.Available)
    else
        obj = type == "Line" and Drawing.new("Line") or Drawing.new("Text")
    end
    DrawingPool.Active[obj] = true
    return obj
end

local function releaseDrawingObject(obj)
    if DrawingPool.Active[obj] then
        obj.Visible = false
        DrawingPool.Active[obj] = nil
        table.insert(DrawingPool.Available, obj)
    end
end

-- Main ESP update function
local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local humanoid = player.Character:FindFirstChild("Humanoid")
            
            if not ESPData[player] then
                ESPData[player] = {
                    Highlight = Instance.new("Highlight"),
                    DistanceText = createDrawingObject("Text"),
                    NameText = createDrawingObject("Text"),
                    TracerLine = createDrawingObject("Line")
                }
                ESPData[player].Highlight.Adornee = player.Character
                ESPData[player].Highlight.Parent = player.Character
            end

            local esp = ESPData[player]
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

            -- Update Highlight
            esp.Highlight.Enabled = ESPConfig.Highlight and onScreen
            esp.Highlight.FillTransparency = ESPConfig.HighlightTransparency
            esp.Highlight.FillColor = ESPConfig.HighlightColor

            -- Update Distance
            if ESPConfig.Distance and onScreen then
                local distance = (LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart and 
                    (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or 0)
                
                esp.DistanceText.Visible = true
                esp.DistanceText.Position = Vector2.new(screenPos.X, screenPos.Y + 20)
                esp.DistanceText.Text = math.floor(distance) .. " studs"
                esp.DistanceText.Size = ESPConfig.DistanceTextSize
                esp.DistanceText.Color = ESPConfig.DistanceColor
                esp.DistanceText.Transparency = ESPConfig.DistanceTransparency
            else
                esp.DistanceText.Visible = false
            end

            -- Update Names
            if ESPConfig.Names and onScreen then
                esp.NameText.Visible = true
                esp.NameText.Position = Vector2.new(screenPos.X, screenPos.Y - 20)
                esp.NameText.Text = player.Name
                esp.NameText.Size = ESPConfig.NamesTextSize
                esp.NameText.Color = ESPConfig.NamesColor
                esp.NameText.Transparency = ESPConfig.NamesTransparency
            else
                esp.NameText.Visible = false
            end

            -- Update Tracers
            if ESPConfig.Tracers and onScreen then
                esp.TracerLine.Visible = true
                esp.TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                esp.TracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
                esp.TracerLine.Color = ESPConfig.TracersColor
                esp.TracerLine.Transparency = ESPConfig.TracersTransparency
                esp.TracerLine.Thickness = ESPConfig.TracersThickness * 10
            else
                esp.TracerLine.Visible = false
            end
        else
            if ESPData[player] then
                ESPData[player].Highlight.Enabled = false
                ESPData[player].DistanceText.Visible = false
                ESPData[player].NameText.Visible = false
                ESPData[player].TracerLine.Visible = false
            end
        end
    end
end

-- Cleanup when player leaves
local function onPlayerRemoving(player)
    if ESPData[player] then
        ESPData[player].Highlight:Destroy()
        releaseDrawingObject(ESPData[player].DistanceText)
        releaseDrawingObject(ESPData[player].NameText)
        releaseDrawingObject(ESPData[player].TracerLine)
        ESPData[player] = nil
    end
end

-- ESP Tab
Tabs.EspTab:Section({Title = gradient("ESP", Color3.fromHex("#ff0000"), Color3.fromHex("#300000"))})

Tabs.EspTab:Toggle({
    Title = "Highlight",
    Default = false,
    Callback = function(state)
        ESPConfig.Highlight = state
    end
})

Tabs.EspTab:Toggle({
    Title = "Distance",
    Default = false,
    Callback = function(state)
        ESPConfig.Distance = state
    end
})

Tabs.EspTab:Toggle({
    Title = "Names",
    Default = false,
    Callback = function(state)
        ESPConfig.Names = state
    end
})

Tabs.EspTab:Toggle({
    Title = "Tracers",
    Default = false,
    Callback = function(state)
        ESPConfig.Tracers = state
    end
})

-- ESP Settings
Tabs.EspTab:Section({Title = gradient("SETTINGS", Color3.fromHex("#001aff"), Color3.fromHex("#020524"))})

Tabs.EspTab:Slider({
    Title = "Highlight Transparency",
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.5},
    Callback = function(value)
        ESPConfig.HighlightTransparency = value
    end
})

Tabs.EspTab:Colorpicker({
    Title = "Highlight Color",
    Default = Color3.new(1, 0, 0),
    Callback = function(col)
        ESPConfig.HighlightColor = col
    end
})

Tabs.EspTab:Slider({
    Title = "Distance Transparency",
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.5},
    Callback = function(value)
        ESPConfig.DistanceTransparency = value
    end
})

Tabs.EspTab:Slider({
    Title = "Distance Text Size",
    Value = {Min = 10, Max = 30, Default = 14},
    Callback = function(value)
        ESPConfig.DistanceTextSize = value
    end
})

Tabs.EspTab:Colorpicker({
    Title = "Distance Color",
    Default = Color3.new(1, 0, 0),
    Callback = function(col)
        ESPConfig.DistanceColor = col
    end
})

Tabs.EspTab:Slider({
    Title = "Names Transparency",
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.5},
    Callback = function(value)
        ESPConfig.NamesTransparency = value
    end
})

Tabs.EspTab:Slider({
    Title = "Names Text Size",
    Value = {Min = 10, Max = 30, Default = 14},
    Callback = function(value)
        ESPConfig.NamesTextSize = value
    end
})

Tabs.EspTab:Colorpicker({
    Title = "Names Color",
    Default = Color3.new(1, 0, 0),
    Callback = function(col)
        ESPConfig.NamesColor = col
    end
})

Tabs.EspTab:Slider({
    Title = "Tracers Transparency",
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.5},
    Callback = function(value)
        ESPConfig.TracersTransparency = value
    end
})

Tabs.EspTab:Slider({
    Title = "Tracers Thickness",
    Step = 0.01,
    Value = {Min = 0.01, Max = 0.2, Default = 0.05},
    Callback = function(value)
        ESPConfig.TracersThickness = value
    end
})

Tabs.EspTab:Colorpicker({
    Title = "Tracers Color",
    Default = Color3.new(1, 0, 0),
    Callback = function(col)
        ESPConfig.TracersColor = col
    end
})

-- Initialize
local function espinit()
    -- Setup connections
    Connections.RenderStepped = RunService.RenderStepped:Connect(updateESP)
    Connections.PlayerRemoving = Players.PlayerRemoving:Connect(onPlayerRemoving)
end

-- Cleanup
local function cleanup()
    for _, connection in pairs(Connections) do
        connection:Disconnect()
    end
    for player, data in pairs(ESPData) do
        data.Highlight:Destroy()
        releaseDrawingObject(data.DistanceText)
        releaseDrawingObject(data.NameText)
        releaseDrawingObject(data.TracerLine)
    end
    ESPData = {}
    Connections = {}
end

-- Start ESP
espinit()

-- Return cleanup function for external use

-- Aimbot Tab
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Aimbot configuration
local AimbotConfig = {
    Enabled = false,
    Target = "Select player",
    LockCamera = false,
    Spectate = false,
    Smoothness = 0.2,
    Wallcheck = false,
    ShowFOVCircle = true,
    LockInFOV = true,
    FOVRadius = 150,
    FOVColor = Color3.new(1, 1, 1),
    FOVTransparency = 0.5
}

-- Cache for aimbot data
local AimbotData = {
    FOVCircle = nil,
    Connections = {},
    TargetPlayer = nil,
    DebugEnabled = true -- Toggle for debug output
}

-- Debug notification helper
local function debugNotify(message)
    if AimbotData.DebugEnabled then
        WindUI:Notify({
            Title = "Aimbot Debug",
            Content = message,
            Icon = "info",
            Duration = 3
        })
    end
end

-- Initialize FOV circle (optional)
local function initFOVCircle()
    local success, err = pcall(function()
        AimbotData.FOVCircle = Drawing.new("Circle")
        AimbotData.FOVCircle.Visible = false
        AimbotData.FOVCircle.Thickness = 1
        AimbotData.FOVCircle.NumSides = 64
        AimbotData.FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end)
    if not success then
        debugNotify("FOV Circle failed: " .. tostring(err))
        AimbotData.FOVCircle = nil
    else
        debugNotify("FOV Circle initialized")
    end
end

-- Update FOV circle
local function updateFOVCircle()
    if AimbotData.FOVCircle then
        AimbotData.FOVCircle.Visible = AimbotConfig.ShowFOVCircle and AimbotConfig.Enabled
        AimbotData.FOVCircle.Radius = AimbotConfig.FOVRadius
        AimbotData.FOVCircle.Color = AimbotConfig.FOVColor
        AimbotData.FOVCircle.Transparency = AimbotConfig.FOVTransparency
        AimbotData.FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
end

-- Get closest player to mouse
local function getClosestPlayerToMouse()
    local closestPlayer = nil
    local closestDistance = AimbotConfig.FOVRadius
    local mousePos = UserInputService:GetMouseLocation()
    
    debugNotify("Searching for closest player")

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local rootPart = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local screenVector = Vector2.new(screenPos.X, screenPos.Y)
                local distance = (mousePos - screenVector).Magnitude
                
                if AimbotConfig.LockInFOV and distance > AimbotConfig.FOVRadius then
                    continue
                end
                
                if distance < closestDistance then
                    if AimbotConfig.Wallcheck then
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character or {}}
                        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                        
                        local raycastResult = Workspace:Raycast(Camera.CFrame.Position, (rootPart.Position - Camera.CFrame.Position).Unit * 1000, raycastParams)
                        
                        if raycastResult and raycastResult.Instance:IsDescendantOf(player.Character) then
                            closestPlayer = player
                            closestDistance = distance
                            debugNotify("Found player: " .. player.Name .. " (wallcheck passed)")
                        end
                    else
                        closestPlayer = player
                        closestDistance = distance
                        debugNotify("Found player: " .. player.Name)
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Update aimbot logic
local function updateAimbot()
    if not AimbotConfig.Enabled or not AimbotConfig.LockCamera then
        AimbotData.TargetPlayer = nil
        updateFOVCircle()
        return
    end

    debugNotify("Aimbot update running")

    local target = AimbotConfig.Target == "Select player" and getClosestPlayerToMouse() or Players:FindFirstChild(AimbotConfig.Target)
    
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
        AimbotData.TargetPlayer = target
        debugNotify("Target set: " .. target.Name)
        
        if AimbotConfig.Spectate then
            local success, err = pcall(function()
                Camera.CameraSubject = target.Character.Humanoid
            end)
            if not success then
                debugNotify("Spectate failed: " .. tostring(err))
            end
        elseif Camera.CameraSubject ~= (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) then
            local success, err = pcall(function()
                Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or Camera.CameraSubject
            end)
            if not success then
                debugNotify("Camera subject reset failed: " .. tostring(err))
            end
        end

        local rootPart = target.Character.HumanoidRootPart
        local targetPos = rootPart.Position
        local currentCFrame = Camera.CFrame
        local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
        
        local success, err = pcall(function()
            Camera.CFrame = currentCFrame:Lerp(targetCFrame, 1 - AimbotConfig.Smoothness)
        end)
        if not success then
            debugNotify("Camera manipulation failed: " .. tostring(err))
        end
    else
        AimbotData.TargetPlayer = nil
        if AimbotConfig.Spectate and Camera.CameraSubject ~= (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) then
            local success, err = pcall(function()
                Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or Camera.CameraSubject
            end)
            if not success then
                debugNotify("Spectate reset failed: " .. tostring(err))
            end
        end
    end
    
    updateFOVCircle()
end

-- Mouse hold detection
local function setupMouseHold()
    if AimbotData.Connections.MouseConnection then
        AimbotData.Connections.MouseConnection:Disconnect()
    end
    
    AimbotData.Connections.MouseConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton2 and AimbotConfig.LockCamera then
            AimbotConfig.Enabled = true
            debugNotify("Aimbot enabled via mouse hold")
            updateFOVCircle()
        end
    end)
    
    AimbotData.Connections.MouseConnectionRelease = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            AimbotConfig.Enabled = false
            debugNotify("Aimbot disabled")
            updateFOVCircle()
        end
    end)
end

-- Cleanup when player leaves
local function onPlayerRemovingAimbot(player)
    if AimbotData.TargetPlayer == player then
        AimbotConfig.Target = "Select player"
        AimbotData.TargetPlayer = nil
        if AimbotConfig.Spectate then
            local success, err = pcall(function()
                Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or Camera.CameraSubject
            end)
            if not success then
                debugNotify("Player removal cleanup failed: " .. tostring(err))
            end
        end
        debugNotify("Target player removed: " .. player.Name)
    end
end

-- UI Setup
Tabs.AimbotTab:Section({
    Title = gradient("AIMBOT", Color3.fromHex("#ff0000"), Color3.fromHex("#300000"))
})

local function updatePlayerList()
    local players = {"Select player"}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    return players
end

local aimbotDropdown = Tabs.AimbotTab:Dropdown({
    Title = "Target",
    Values = updatePlayerList(),
    Value = "Select player",
    Callback = function(option)
        AimbotConfig.Target = option
        AimbotData.TargetPlayer = nil
        if AimbotConfig.Spectate and option == "Select player" then
            local success, err = pcall(function()
                Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or Camera.CameraSubject
            end)
            if not success then
                debugNotify("Target selection reset failed: " .. tostring(err))
            end
        end
        debugNotify("Target selected: " .. option)
    end
})

Players.PlayerAdded:Connect(function()
    aimbotDropdown:Refresh(updatePlayerList())
    debugNotify("Player list updated (player added)")
end)

Players.PlayerRemoving:Connect(function()
    aimbotDropdown:Refresh(updatePlayerList())
    debugNotify("Player list updated (player removed)")
end)

Tabs.AimbotTab:Toggle({
    Title = "Lock camera",
    Default = false,
    Callback = function(state)
        AimbotConfig.LockCamera = state
        AimbotConfig.Enabled = false
        updateFOVCircle()
        debugNotify("Lock camera toggled: " .. tostring(state))
    end
})

Tabs.AimbotTab:Toggle({
    Title = "Spectate",
    Default = false,
    Callback = function(state)
        AimbotConfig.Spectate = state
        if not state then
            local success, err = pcall(function()
                Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or Camera.CameraSubject
            end)
            if not success then
                debugNotify("Spectate toggle off failed: " .. tostring(err))
            end
        end
        debugNotify("Spectate toggled: " .. tostring(state))
    end
})

Tabs.AimbotTab:Section({
    Title = gradient("SETTINGS", Color3.fromHex("#001aff"), Color3.fromHex("#020524"))
})

Tabs.AimbotTab:Slider({
    Title = "Smoothness",
    Step = 0.01,
    Value = {Min = 0, Max = 1, Default = 0.2},
    Callback = function(value)
        AimbotConfig.Smoothness = value
        debugNotify("Smoothness set to: " .. tostring(value))
    end
})

Tabs.AimbotTab:Toggle({
    Title = "Wallcheck",
    Default = false,
    Callback = function(state)
        AimbotConfig.Wallcheck = state
        debugNotify("Wallcheck toggled: " .. tostring(state))
    end
})

Tabs.AimbotTab:Section({
    Title = gradient("FOV Settings", Color3.fromHex("#00448c"), Color3.fromHex("#0affd6"))
})

Tabs.AimbotTab:Toggle({
    Title = "Show FOV Circle",
    Default = true,
    Callback = function(state)
        AimbotConfig.ShowFOVCircle = state
        updateFOVCircle()
        debugNotify("Show FOV Circle toggled: " .. tostring(state))
    end
})

Tabs.AimbotTab:Toggle({
    Title = "Lock in FOV",
    Default = true,
    Callback = function(state)
        AimbotConfig.LockInFOV = state
        debugNotify("Lock in FOV toggled: " .. tostring(state))
    end
})

Tabs.AimbotTab:Slider({
    Title = "FOV Radius",
    Step = 1,
    Value = {Min = 50, Max = 500, Default = 150},
    Callback = function(value)
        AimbotConfig.FOVRadius = value
        updateFOVCircle()
        debugNotify("FOV Radius set to: " .. tostring(value))
    end
})

Tabs.AimbotTab:Colorpicker({
    Title = "FOV Color",
    Default = Color3.new(1, 1, 1),
    Callback = function(color)
        AimbotConfig.FOVColor = color
        updateFOVCircle()
        debugNotify("FOV Color changed")
    end
})

Tabs.AimbotTab:Slider({
    Title = "FOV Transparency",
    Step = 0.1,
    Value = {Min = 0, Max = 1, Default = 0.5},
    Callback = function(value)
        AimbotConfig.FOVTransparency = value
        updateFOVCircle()
        debugNotify("FOV Transparency set to: " .. tostring(value))
    end
})

-- Initialize Aimbot
local function initAimbot()
    -- Wait for character to load
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") then
        debugNotify("Waiting for character to load")
        LocalPlayer.CharacterAdded:Wait()
    end
    
    initFOVCircle()
    AimbotData.Connections.RenderStepped = RunService.RenderStepped:Connect(updateAimbot)
    AimbotData.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(onPlayerRemovingAimbot)
    setupMouseHold()
    updateFOVCircle()
    debugNotify("Aimbot initialized")
end

-- Cleanup Aimbot
local function cleanupAimbot()
    for _, connection in pairs(AimbotData.Connections) do
        connection:Disconnect()
    end
    if AimbotData.FOVCircle then
        AimbotData.FOVCircle:Remove()
    end
    AimbotData.TargetPlayer = nil
    AimbotData.Connections = {}
    if AimbotConfig.Spectate then
        local success, err = pcall(function()
            Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or Camera.CameraSubject
        end)
        if not success then
            debugNotify("Aimbot cleanup failed: " .. tostring(err))
        end
    end
    debugNotify("Aimbot cleaned up")
end

-- Start Aimbot
initAimbot()

-- Combine cleanup functions
local originalCleanup = cleanup
local function combinedCleanup()
    originalCleanup()
    cleanupAimbot()
end

-- Return combined cleanup function
return combinedCleanup