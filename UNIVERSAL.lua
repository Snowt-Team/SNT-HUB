-- WindUI Universal Script v3.0
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

-- Global Configuration
local Config = {
    DebounceTime = 0.1,
    NotificationDuration = 3,
    TeleportOffset = Vector3.new(0, 3, 0),
    FolderPath = "WindUI",
}

-- Locals
local Debounces = {}
local function SetDebounce(action, time)
    if Debounces[action] and tick() - Debounces[action] < time then return false end
    Debounces[action] = tick()
    return true
end

makefolder(Config.FolderPath)

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
    Title = gradient("SNT&MIRROZZ HUB v3.0", Color3.fromHex("#eb1010"), Color3.fromHex("#1023eb")),
    Icon = "info",
    Content = gradient("Created by SnowT & Mirrozz", Color3.fromHex("#10eb3c"), Color3.fromHex("#67c97a")),
    Buttons = {
        { Title = gradient("Cancel", Color3.fromHex("#e80909"), Color3.fromHex("#630404")), Callback = function() end, Variant = "Tertiary" },
        { Title = gradient("Load", Color3.fromHex("#90f09e"), Color3.fromHex("#13ed34")), Callback = function() Confirmed = true end, Variant = "Secondary" }
    }
})

repeat task.wait() until Confirmed

WindUI:Notify({
    Title = gradient("SNT&MIRROZZ HUB", Color3.fromHex("#eb1010"), Color3.fromHex("#1023eb")),
    Content = "Script successfully loaded!",
    Icon = "check-circle",
    Duration = Config.NotificationDuration,
})

-- Create Window
local Window = WindUI:CreateWindow({
    Title = gradient("SNT&MIRROZZ HUB", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Icon = "infinity",
    Author = gradient("Universal | Version: 3.0", Color3.fromHex("#1bf2b2"), Color3.fromHex("#1bcbf2")),
    Folder = Config.FolderPath,
    Size = UDim2.fromOffset(350, 300),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 220,
    ScrollBarEnabled = true,
})

-- Tabs
local Tabs = {
    MainTab = Window:Tab({ Title = gradient("MAIN", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "terminal" }),
    CharacterTab = Window:Tab({ Title = gradient("CHARACTER", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "file-cog" }),
    TeleportTab = Window:Tab({ Title = gradient("TELEPORT", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "user" }),
    EspTab = Window:Tab({ Title = gradient("ESP", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "eye" }),
    AimbotTab = Window:Tab({ Title = gradient("AIMBOT", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "arrow-right" }),
    FlyTab = Window:Tab({ Title = gradient("FLY", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "rocket" }),
    TrollTab = Window:Tab({ Title = gradient("TROLL", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "user" }),
    ServerTab = Window:Tab({ Title = gradient("SERVER", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "atom" }),
    SettingsTab = Window:Tab({ Title = gradient("SETTINGS", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "code" }),
    SocialsTab = Window:Tab({ Title = gradient("SOCIALS", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")), Icon = "star" }),
}

-- Helper Functions
local function Notify(title, content, icon, duration)
    WindUI:Notify({
        Title = gradient(title, Color3.fromHex("#ffffff"), Color3.fromHex("#636363")),
        Content = content,
        Icon = icon or "info",
        Duration = duration or Config.NotificationDuration,
    })
end

local function IsAlive(player)
    return player and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
end

local function GetRootPart(player)
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

-- File Management
local function SaveFile(fileName, data)
    local filePath = Config.FolderPath .. "/" .. fileName .. ".json"
    pcall(function()
        writefile(filePath, HttpService:JSONEncode(data))
    end)
end

local function LoadFile(fileName)
    local filePath = Config.FolderPath .. "/" .. fileName .. ".json"
    if isfile(filePath) then
        return HttpService:JSONDecode(readfile(filePath))
    end
end

local function ListFiles()
    local files = {}
    for _, file in ipairs(listfiles(Config.FolderPath)) do
        local fileName = file:match("([^/]+)%.json$")
        if fileName then table.insert(files, fileName) end
    end
    return files
end

-- Fly System
local FlySettings = {
    Enabled = false,
    Speed = 50,
    VerticalSpeed = 50,
    ToggleKey = Enum.KeyCode.F,
    Connection = nil,
}

local function ToggleFly(state)
    FlySettings.Enabled = state
    local character = LocalPlayer.Character
    local root = character and GetRootPart(LocalPlayer)
    if not root then return

    if state then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Parent = root
        FlySettings.Connection = bodyVelocity

        RunService:BindToRenderStep("Fly", 100, function()
            if not FlySettings.Enabled then return end
            local moveDirection = Vector3.new()
            local camera = CurrentCamera
            local forward = camera.CFrame.LookVector
            local right = camera.CFrame.RightVector
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection += forward end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection -= forward end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection -= right end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection += right end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection -= Vector3.new(0, 1, 0) end
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
                bodyVelocity.Velocity = moveDirection * (moveDirection.Y == 0 and FlySettings.Speed or FlySettings.VerticalSpeed)
            else
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        if FlySettings.Connection then
            FlySettings.Connection:Destroy()
            FlySettings.Connection = nil
        end
        RunService:UnbindFromRenderStep("Fly")
    end
end

Tabs.FlyTab:Section({ Title = gradient("Fly Controls", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")) })
Tabs.FlyTab:Toggle({
    Title = "Enable Fly",
    Callback = ToggleFly
})
Tabs.FlyTab:Slider({
    Title = "Fly Speed",
    Value = { Min = 10, Max = 200, Default = 50 },
    Callback = function(value) FlySettings.Speed = value end
})
Tabs.FlyTab:Slider({
    Title = "Vertical Speed",
    Value = { Min = 10, Max = 200, Default = 50 },
    Callback = function(value) FlySettings.VerticalSpeed = value end
})
Tabs.FlyTab:Keybind({
    Title = "Fly Toggle Key",
    Default = FlySettings.ToggleKey,
    Callback = function(key)
        FlySettings.ToggleKey = key
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == FlySettings.ToggleKey and SetDebounce("FlyToggle", Config.DebounceTime) then
                ToggleFly(not FlySettings.Enabled)
            end
        end)
    end
})

-- Enhanced ESP System
local ESPSettings = {
    Names = false,
    Distance = false,
    Tracers = false,
    Boxes = false,
    Health = false,
    Color = Color3.fromRGB(255, 0, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    TextSize = 16,
    TracerOrigin = "Bottom",
    Transparency = 0.5,
}

local espObjects = {}
local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer or not IsAlive(player) then
            if espObjects[player] then
                for _, obj in pairs(espObjects[player]) do obj:Remove() end
                espObjects[player] = nil
            end
            continue
        end

        local character = player.Character
        local root = GetRootPart(player)
        if not root then continue end

        if not espObjects[player] then espObjects[player] = {} end
        local objects = espObjects[player]

        -- Name/Distance/Health Text
        if ESPSettings.Names or ESPSettings.Distance or ESPSettings.Health then
            if not objects.Text then
                objects.Text = Drawing.new("Text")
                objects.Text.Outline = true
                objects.Text.Center = true
            end
            local head = character:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = CurrentCamera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.5, 0))
                if onScreen then
                    local text = ""
                    if ESPSettings.Names then text = player.Name end
                    if ESPSettings.Distance then
                        local distance = (LocalPlayer.Character and GetRootPart(LocalPlayer) and (GetRootPart(LocalPlayer).Position - head.Position).Magnitude) or 0
                        text = text .. (text ~= "" and " " or "") .. "[" .. math.floor(distance) .. "]"
                    end
                    if ESPSettings.Health then
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        text = text .. (text ~= "" and " " or "") .. "[" .. math.floor(humanoid.Health) .. "/" .. humanoid.MaxHealth .. "]"
                    end
                    objects.Text.Text = text
                    objects.Text.Position = Vector2.new(screenPos.X, screenPos.Y)
                    objects.Text.Color = ESPSettings.TextColor
                    objects.Text.Size = ESPSettings.TextSize
                    objects.Text.Visible = true
                else
                    objects.Text.Visible = false
                end
            end
        elseif objects.Text then
            objects.Text.Visible = false
        end

        -- Tracers
        if ESPSettings.Tracers then
            if not objects.Tracer then
                objects.Tracer = Drawing.new("Line")
                objects.Tracer.Thickness = 1
            end
            local origin = ESPSettings.TracerOrigin == "Bottom" and Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y) or Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
            local screenPos, onScreen = CurrentCamera:WorldToViewportPoint(root.Position)
            if onScreen then
                objects.Tracer.From = origin
                objects.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                objects.Tracer.Color = ESPSettings.Color
                objects.Tracer.Transparency = 1 - ESPSettings.Transparency
                objects.Tracer.Visible = true
            else
                objects.Tracer.Visible = false
            end
        elseif objects.Tracer then
            objects.Tracer.Visible = false
        end

        -- Boxes
        if ESPSettings.Boxes then
            if not objects.Box then
                objects.Box = Drawing.new("Quad")
                objects.Box.Thickness = 1
            end
            local top, bottom = CurrentCamera:WorldToViewportPoint(root.Position + Vector3.new(0, 2.5, 0)), CurrentCamera:WorldToViewportPoint(root.Position - Vector3.new(0, 2.5, 0))
            local left, right = CurrentCamera:WorldToViewportPoint(root.Position - Vector3.new(1.5, 0, 0)), CurrentCamera:WorldToViewportPoint(root.Position + Vector3.new(1.5, 0, 0))
            if top.Z > 0 then
                objects.Box.PointA = Vector2.new(right.X, top.Y)
                objects.Box.PointB = Vector2.new(right.X, bottom.Y)
                objects.Box.PointC = Vector2.new(left.X, bottom.Y)
                objects.Box.PointD = Vector2.new(left.X, top.Y)
                objects.Box.Color = ESPSettings.Color
                objects.Box.Transparency = 1 - ESPSettings.Transparency
                objects.Box.Visible = true
            else
                objects.Box.Visible = false
            end
        elseif objects.Box then
            objects.Box.Visible = false
        end
    end
end

RunService.RenderStepped:Connect(UpdateESP)
Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do obj:Remove() end
        espObjects[player] = nil
    end
end)

Tabs.EspTab:Section({ Title = gradient("ESP Features", Color3.fromHex("#ff0000"), Color3.fromHex("#300000")) })
Tabs.EspTab:Toggle({ Title = "Name ESP", Callback = function(state) ESPSettings.Names = state end })
Tabs.EspTab:Toggle({ Title = "Distance ESP", Callback = function(state) ESPSettings.Distance = state end })
Tabs.EspTab:Toggle({ Title = "Health ESP", Callback = function(state) ESPSettings.Health = state end })
Tabs.EspTab:Toggle({ Title = "Tracers", Callback = function(state) ESPSettings.Tracers = state end })
Tabs.EspTab:Toggle({ Title = "Boxes", Callback = function(state) ESPSettings.Boxes = state end })

Tabs.EspTab:Section({ Title = gradient("ESP Settings", Color3.fromHex("#ff0000"), Color3.fromHex("#300000")) })
Tabs.EspTab:Colorpicker({ Title = "ESP Color", Default = ESPSettings.Color, Callback = function(color) ESPSettings.Color = color end })
Tabs.EspTab:Colorpicker({ Title = "Text Color", Default = ESPSettings.TextColor, Callback = function(color) ESPSettings.TextColor = color end })
Tabs.EspTab:Slider({ Title = "Text Size", Value = { Min = 12, Max = 24, Default = 16 }, Callback = function(value) ESPSettings.TextSize = value end })
Tabs.EspTab:Slider({ Title = "Transparency", Value = { Min = 0, Max = 1, Default = 0.5 }, Callback = function(value) ESPSettings.Transparency = value end })
Tabs.EspTab:Dropdown({ Title = "Tracer Origin", Values = {"Bottom", "Center"}, Value = "Bottom", Callback = function(value) ESPSettings.TracerOrigin = value end })

-- Teleport System with Coordinate Saving
local TeleportSettings = {
    TargetPlayer = nil,
    Coordinates = Vector3.new(0, 0, 0),
    SavedPositions = LoadFile("TeleportPositions") or {},
}

local function UpdateTeleportPlayers()
    local list = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then table.insert(list, player.Name) end
    end
    return list
end

Tabs.TeleportTab:Section({ Title = gradient("Player Teleport", Color3.fromHex("#00b7eb"), Color3.fromHex("#003087")) })
local teleportDropdown = Tabs.TeleportTab:Dropdown({
    Title = "Select Player",
    Values = UpdateTeleportPlayers(),
    Callback = function(name) TeleportSettings.TargetPlayer = Players:FindFirstChild(name) end
})
Tabs.TeleportTab:Button({
    Title = "Teleport to Player",
    Callback = function()
        if TeleportSettings.TargetPlayer and IsAlive(TeleportSettings.TargetPlayer) then
            local root = GetRootPart(TeleportSettings.TargetPlayer)
            if root then
                GetRootPart(LocalPlayer).CFrame = root.CFrame + Config.TeleportOffset
                Notify("Teleport", "Teleported to " .. TeleportSettings.TargetPlayer.Name, "check-circle")
            end
        else
            Notify("Teleport", "Invalid target", "x-circle")
        end
    end
})
Tabs.TeleportTab:Button({
    Title = "Refresh Players",
    Callback = function()
        teleportDropdown:Set("Values", UpdateTeleportPlayers())
    end
})

Tabs.TeleportTab:Section({ Title = gradient("Coordinate Teleport", Color3.fromHex("#00b7eb"), Color3.fromHex("#003087")) })
Tabs.TeleportTab:Input({
    Title = "X Coordinate",
    Placeholder = "X",
    Callback = function(value) TeleportSettings.Coordinates.X = TeleportSettings.Coordinates.X = tonumber(value) or 0 end
})
Tabs.Input({
    Title = "Y Coordinate",
    Placeholder = "Y",
    Callback = function(value) TeleportSettings.Coordinates.Y = tonumber(value) or 0 end
})
Tabs.TTeleportTab:Input({
    Title = "Z Coordinate",
    Placeholder = "Z",
    Callback = function(value) TeleportSettings.Coordinates.Z = tonumber(value) or 0 end
})
Tabs.TTeleportTab:Button({
    Title = "Teleport to Coordinates",
    Callback = function()
        if GetRootPart(LocalPlayer) then
            GetRootPart(LocalPlayer).CFrame = CFrame.new(TeleportSettings.Coordinates + Config.TeleportOffset)
            Notify("Teleport", "Teleported to coordinates", "check-circle")
        end
    end
})

Tabs.TTeleportTab:Section({ Title = gradient("Save Position", Color3.fromHex("#00b7eb"), Color3.fromHex("#003087")) })
local positionName = ""
Tabs.TTeleportTab:Input({
    Title = "Position Name",
    Placeholder = "Enter position name",
    Callback = function(name)
        positionName = name
    end
})
Tabs.TTeleportTab:Button({
    Title = "Save Current Position",
    Callback = function()
        if positionName ~= "" and GetRootPart(LocalPlayer) then
            TeleportSettings.SavedPositions[positionName] = GetRootPart(LocalPlayer).Position
            SaveFile("TeleportPositions", TeleportSettings.SavedPositions)
            Notify("Teleport", "Position saved as " .. positionName, "check-circle")
        else
            Notify("Teleport", "Enter a valid name", "x-circle")
        end
    end
})
local positionDropdown = Tabs.TTeleportTab:Dropdown({
    Title = "Saved Positions",
    Values = {table.unpack(table.keys(TeleportSettings.SavedPositions))},
    Callback = function(name)
        if TeleportSettings.SavedPositions[name] then
            TeleportSettings.Coordinates = TeleportSettings.SavedPositions[name]
            Notify("Teleport", "Loaded position " .. name, "check-circle")
        end
    end
})
Tabs.TTeleportTab:Button({
    Title = "Teleport to Saved Position",
    Callback = function()
        if TeleportSettings.Coordinates and GetRootPart(LocalPlayer) then
            GetRootPart(LocalPlayer).CFrame = CFrame.new(TeleportSettings.Coordinates + Config.TeleportOffset)
            Notify("Teleport", "Teleported to saved position", "check-circle")
        end
    end
    end
        Notify("Teleport", "No position selected", "x-circle")
    end
})

Players.PlayerAdded:Connect(function()
    teleportDropdown:Set("Values", UpdateTeleportPlayers())
end)
Players.PlayerRemoving:Connect(function()
    teleportDropdown:Set("Values", UpdateTeleportPlayers())
end)

-- Aimbot System
local AimbotSettings = {
    Enabled = false,
    LockTarget = nil,
    Fov = 100,
    ShowFov = true,
    LockInFov = true,
    FovColor = Color3.fromRGB(255, 0, 255),
    FovSize = 100,
    FovTransparency = 0.5,
    Smoothing = 0.2,
    ShiftLock = false,
    BodyGyro = nil,
    TargetPart = "Head",
}
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 0.2
fovCircle.NumSides = 100
fovCircle.Radius = AimbotSettings.FovSize
fovCircle.Position = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
fovCircle.Color = AimbotSettings.FovColor
fovCircle.Transparency = 1 - AimbotSettings.FovTransparency

local function IsInFov(targetPos)
    local screenPos = CurrentCamera:WorldToViewportPoint(targetPos.Position)
    local center = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
    return (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude <= AimbotSettings.FovSize
end

local function UpdateAimbotPlayers()
    local list = {"None"}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) then table.insert(list, player.Name) end
    end
    return list
end

local function GetClosestPlayer()
    local closest = nil
    local minDist = math.huge
    local root = GetRootPart(LocalPlayer)
    if not root then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) then
            local targetRoot = GetRootPart(player)
            if targetRoot and (not AimbotSettings.LockInFov or IsInFov(targetRoot)) then
                local dist = (root.Position - targetRoot.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

Tabs.AimbotTab:Section({ Title = gradient("Aimbot Controls", Color3.fromHex("#ff3333"), Color3.fromHex("#330000")) })
local aimbotDropdown = Tabs.AimbotTab:Dropdown({
    Title = "Select Player",
    Values = UpdateAimbotPlayers(),
    Value = "None",
    Callback = function(name)
        AimbotSettings.LockTarget = name ~= "None" and Players:FindFirstChild(name) or nil
    end
})
Tabs.AimbotTab:Toggle({
    Title = "Enable Aimbot",
    Callback = function(state)
        AimbotSettings.Enabled = state
        fovCircle.Visible = state and AimbotSettings.ShowFov
        CurrentCamera.CameraType = state and Enum.CameraType.Scriptable or Enum.CameraType.Custom
        if not state and AimbotSettings.BodyGyro then
            AimbotSettings.BodyGyro:Destroy()
            AimbotSettings.BodyGyro = nil
        end
    end
})
Tabs.AimbotTab:Toggle({
    Title = "Show FOV Circle",
    Default = true,
    Callback = function(state)
        AimbotSettings.ShowFov = state
        fovCircle.Visible = state and AimbotSettings.Enabled
    end
})
Tabs.AimbotTab:Toggle({
    Title = "Lock in FOV",
    Default = true,
    Callback = function(state) AimbotSettings.LockInFov = state end
})
Tabs.AimbotTab:Toggle({
    Title = "ShiftLock Rotation",
    Callback = function(state) AimbotSettings.ShiftLock = state end)
})

Tabs.AimbotTab:Section({ Title = gradient("Aimbot Settings", Color3.fromHex("#ff3333"), Color3.fromHex("#330000")) })
Tabs.AimbotTab:Slider({
    Title = "FOV Size",
    Value = { Min = 50, Max = 500, Default = 100 },
    Callback = function(value)
        AimbotSettings.FovSize = value
        fovCircle.Radius = value
    end
})
Tabs.AimbotTab:Slider({
    Title = "Smoothing",
    Value = { Min = 0, Max = 1, Default = 0.2 },
    Callback = function(value) AimbotSettings.Smoothing = value end
})
Tabs.AimbotTab:Colorpicker({
    Title = "FOV Color",
    Default = AimbotSettings.FovColor,
    Callback = function(color)
        AimbotSettings.FovColor = color
        fovCircle.Color = color
    end
})
Tabs.AimbotTab:Slider({
    Title = "FOV Transparency",
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Callback = function(value)
        AimbotSettings.FovTransparency = value
        fovCircle.Transparency = 1 - value
    end
})
Tabs.AimbotTab:Dropdown({
    Title = "Target Part",
    Values = {"Head", "Torso", "Random"},
    Value = "Head",
    Callback = function(value) AimbotSettings.TargetPart = value end
})
Tabs.AimbotTab:Button({
    Title = "Refresh Players",
    Callback = function()
        aimbotDropdown:Set("Values", UpdateAimbotPlayers())
    end
})

RunService.RenderStepped:Connect(function()
    if AimbotSettings.Enabled then
        local target = AimbotSettings.LockTarget or GetClosestPlayer()
        if target and IsAlive(target) then
            local targetPart = target.Character:FindFirstChild(AimbotSettings.TargetPart == "Random" and (math.random() > 0.5 and "Head" or "Torso") or AimbotSettings.TargetPart)
            if targetPart then
                CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(CFrame.new(CurrentCamera.CFrame.Position, targetPart.Position), AimbotSettings.Smoothing)
                if AimbotSettings.ShiftLock then
                    if not AimbotSettings.BodyGyro then
                        AimbotSettings.BodyGyro = Instance.new("BodyGyro")
                        AimbotSettings.BodyGyro.MaxTorque = Vector3.new(0, math.huge, 0)
                        AimbotSettings.BodyGyro.P = 1500
                        AimbotSettings.BodyGyro.Parent = GetRootPart(LocalPlayer)
                    end
                    AimbotSettings.BodyGyro.CFrame = CFrame.new(GetRootPart(LocalPlayer).Position, targetPart.Position)
                end
            end
        end
    end
end)

-- Troll Tab
local TrollSettings = {
    FlingTarget = nil,
}

local function FlingPlayer(player)
    if not player or not IsAlive(player) or not IsAlive(LocalPlayer) then return end
    local root = GetRootPart(LocalPlayer)
    local targetRoot = GetRootPart(player)
    if root and targetRoot then
        root.CFrame = targetRoot.CFrame
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(0, 1000, 0)
        bodyVelocity.Parent = targetRoot
        task.wait(0.1)
        bodyVelocity:Destroy()
        Notify("Troll", "Flung " .. player.Name, "check-circle")
    end
end

local function FlingAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) then
            FlingPlayer(player)
            task.wait(0.2)
        end
    end
end

Tabs.TrollTab:Section({ Title = gradient("Fling Controls", Color3.fromHex("#ff00ff"), Color3.fromHex("#330033")) })
local flingDropdown = Tabs.TrollTab:Dropdown({
    Title = "Select Player",
    Values = UpdateTeleportPlayers(),
    Callback = function(name) TrollSettings.FlingTarget = Players:FindFirstChild(name) end
})
Tabs.TrollTab:Button({
    Title = "Fling Player",
    Callback = function()
        if TrollSettings.FlingTarget then
            FlingPlayer(TrollSettings.FlingTarget)
        else
            Notify("Troll", "No player selected", "x-circle")
        end
    end
})
Tabs.TrollTab:Button({
    Title = "Fling All Players",
    Callback = FlingPlayerAll
})
Tabs.TrollTab:TButton({
    Title = "Refresh Players",
    Callback = function()
        flingDropdown:Set("Values", UpdateTeleportPlayers())
    end
    end
})

-- Auto Inject
local AutoInjectSettings = AutoInject {
    Title = gradient("Enabled", = false,
    ScriptURL = "https://raw.githubusercontent.com/Snowt-Team/SNT-HUB/MHUBS/TREBS.HUB/SNSNT-MIRROZZ.lua"
})

local function SetupAutoInject()
    if not AutoInjectSettings.Enabled then return end
    SaveFile("auto_inject", { Enabled = true, ScriptURL = AutoInjectSettings.ScriptURL })
        spawn(function()
        task.wait(2)
        pcall(function()
            loadstring(game:HttpGet(AutoInjectSettings.ScriptScriptURL))()
        end)
    end)

    LocalPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Started then
            queue_on_teleport([[
                wait(2)
                loadstring(game:HttpGet("]] .. AutoInjectSettings.ScriptURL .. [["))()
            ]])
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        if player == LocalPlayer then
            queue_on_teleport([[
                wait(2)
                loadstring(game:HttpGet("]] .. AutoInjectSettings.ScriptURL .. [["))()
            ]])
        end
    end)
end

Tabs.SettingsTab:Section({ Title = gradient("Auto Execute", Color3.fromHex("#00ff40"), Color3.fromHex("#003333")) })
Tabs.SettingsTab:Toggle({
    Title = "Auto Inject on Rejoin/Hop",
    Callback = function(state)
        AutoInjectSettings.Enabled = state
        if state then
            SetupAutoInject()
            Notify("Auto Inject", "Auto inject enabled", "check-circle")
        else
            Notify("Auto Inject", "Auto inject disabled", "x-circle")
        end
    end
})
Tabs.SettingsTab:Button({
    Title = "Manual Inject",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet(AutoInjectSettings.ScriptURL))()
            Notify("Auto Inject", "Script executed", "check-circle")
        end)
    end)
})

-- Initialize Auto Inject
local autoInjectData = LoadFile("auto_inject_settings")
if autoInjectData and autoInjectData.Enabled then
    AutoInjectSettings.Enabled = true
    AutoInjectSettings.ScriptURL = autoInjectData.ScriptURL
    SetupAutoInject()
end

-- Socials and Changelogs
Tabs.SocialsTab:Paragraph({
    Title = gradient("SnowT", Color3.fromHex("#001e80"), Color3.fromHex("#16f2d9")),
    Desc = "My socials",
    Image = "bird",
    Color = "Green",
    Buttons = {
        { Title = "TG Channel", Icon = "circle", Callback = function() setclipboard("t.me/supreme_scripts") end }
    }
})

Tabs.SocialsTab:Paragraph({
    Title = gradient("Mirrozz", Color3.fromHex("#ffffff"), Color3.fromHex("#363636")),
    Desc = "My Friend's Socials",
    Image = "bird",
    Color = "Green",
    Buttons = {
        { Title = "TG Channel", Icon = "circle", Callback = function() },
 setclipboard("t.me/mirrozzscript") end }
    end
})

-- Changelogs Tab
Tabs.ChangelogsTab:Code({
    Title = "Changelogs v3.0:",
    Code = [[
        - Revamped fly system with configurable speed and toggle key
        - Enhanced ESP with tracers, boxes, and health display
        - Added coordinate-based teleport with position saving
        - Improved aimbot with FOV circle, smoothing, and target part selection
        - New Troll tab with fling player and fling all functionality
        - Optimized auto-inject with persistent settings
        - Added configuration saving/loading for script settings
        - Improved UI with theme customization and window settings
    ]]
})

Tabs.ChangelogsTab:Code({
    Title = "Next Update (v3.1):",
    Code = [[
        - Additional ESP settings (team-based filtering)
        - Advanced aimbot prediction for moving targets
        - Auto-farm functionality for popular games
        - Enhanced troll features (chat spam, visual effects)
        - Bug fixes and performance optimizations
    ]]
})

-- Server Tab
Tabs.ServerTab:Section({ Title = gradient("Server Controls", Color3.fromHex("#00b7eb"), Color3.fromHex("#003087")) })

Tabs.ServerTab:Button({
    Title = "Rejoin",
    Callback = function()
        if SetDebounce("Rejoin", Config.DebounceTime) then
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                Notify("Server", "Rejoining server...", "check-circle")
            end)
        end
    end
})

Tabs.ServerTab:Button({
    Title = "Server Hop",
    Callback = function()
        if SetDebounce("ServerHop", Config.DebounceTime) then
            local placeId = game.PlaceId
            local currentJobId = game.JobId
            pcall(function()
                local servers = HttpService:JSONDecode(HttpService:GetAsync("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")).data
                local validServers = {}
                for _, server in ipairs(servers) do
                    if server.id ~= currentJobId then
                        table.insert(validServers, server)
                    end
                end
                if #validServers > 0 then
                    TeleportService:TeleportToPlaceInstance(placeId, validServers[math.random(#validServers)].id)
                    Notify("Server", "Hopping to a new server...", "check-circle")
                else
                    TeleportService:Teleport(placeId)
                    Notify("Server", "No servers found, joining new server...", "check-circle")
                end
            end)
        end
    end
})

Tabs.ServerTab:Button({
    Title = "Join Lowest Player Server",
    Callback = function()
        if SetDebounce("LowServer", Config.DebounceTime) then
            local placeId = game.PlaceId
            local currentJobId = game.JobId
            pcall(function()
                local servers = HttpService:JSONDecode(HttpService:GetAsync("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")).data
                local validServers = {}
                for _, server in ipairs(servers) do
                    if server.id ~= currentJobId and server.playing < server.maxPlayers then
                        table.insert(validServers, server)
                    end
                end
                table.sort(validServers, function(a, b) return a.playing < b.playing end)
                if #validServers > 0 then
                    TeleportService:TeleportToPlaceInstance(placeId, validServers[1].id)
                    Notify("Server", "Joining server with lowest players...", "check-circle")
                else
                    TeleportService:Teleport(placeId)
                    Notify("Server", "No servers found, joining new server...", "check-circle")
                end
            end)
        end
    end
})

-- Settings Tab
local Settings = {
    Hitbox = { Enabled = false, Size = 5, Color = Color3.new(1, 0, 0), Adornments = {}, Connection = nil },
    Noclip = { Enabled = false, Connection = nil },
    AntiAFK = { Enabled = false, Connection = nil },
    Config = { CurrentConfigName = "Default", SelectedConfig = "Default", AutoLoad = false },
}

local function ToggleNoclip(state)
    Settings.Noclip.Enabled = state
    if state then
        Settings.Noclip.Connection = RunService.Stepped:Connect(function()
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        Notify("Settings", "Noclip enabled", "check-circle")
    else
        if Settings.Noclip.Connection then
            Settings.Noclip.Connection:Disconnect()
            Settings.Noclip.Connection = nil
        end
        Notify("Settings", "Noclip disabled", "x-circle")
    end
end

local function UpdateHitboxes()
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local character = player.Character
        local root = GetRootPart(player)
        local box = Settings.Hitbox.Adornments[player]
        if character and Settings.Hitbox.Enabled and root then
            if not box then
                box = Instance.new("BoxHandleAdornment")
                box.Adornee = root
                box.Size = Vector3.new(Settings.Hitbox.Size, Settings.Hitbox.Size, Settings.Hitbox.Size)
                box.Color3 = Settings.Hitbox.Color
                box.Transparency = 0.4
                box.ZIndex = 10
                box.Parent = root
                Settings.Hitbox.Adornments[player] = box
            else
                box.Size = Vector3.new(Settings.Hitbox.Size, Settings.Hitbox.Size, Settings.Hitbox.Size)
                box.Color3 = Settings.Hitbox.Color
            end
        elseif box then
            box:Destroy()
            Settings.Hitbox.Adornments[player] = nil
        end
    end
end

local function ToggleAntiAFK(state)
    Settings.AntiAFK.Enabled = state
    if state then
        Settings.AntiAFK.Connection = RunService.Heartbeat:Connect(function()
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end)
        Notify("Settings", "Anti-AFK enabled", "check-circle")
    else
        if Settings.AntiAFK.Connection then
            Settings.AntiAFK.Connection:Disconnect()
            Settings.AntiAFK.Connection = nil
        end
        Notify("Settings", "Anti-AFK disabled", "x-circle")
    end
end

-- Config Management
local function SaveConfig()
    if Settings.Config.CurrentConfigName == "" then
        Notify("Config", "Please enter a config name", "x-circle")
        return
    end
    local configData = {
        FlySettings = FlySettings,
        ESPSettings = ESPSettings,
        AimbotSettings = AimbotSettings,
        TeleportSettings = TeleportSettings,
        Settings = Settings,
    }
    local filePath = Config.FolderPath .. "/" .. Settings.Config.CurrentConfigName .. ".json"
    pcall(function()
        writefile(filePath, HttpService:JSONEncode(configData))
        Notify("Config", "Config '" .. Settings.Config.CurrentConfigName .. "' saved!", "check-circle")
    end)
end

local function LoadConfig(configName)
    local filePath = Config.FolderPath .. "/" .. configName .. ".json"
    if isfile(filePath) then
        local data = pcall(function()
            return HttpService:JSONDecode(readfile(filePath))
        end)
        if data then
            FlySettings = data.FlySettings or FlySettings
            ESPSettings = data.ESPSettings or ESPSettings
            AimbotSettings = data.AimbotSettings or AimbotSettings
            TeleportSettings = data.TeleportSettings or TeleportSettings
            Settings = data.Settings or Settings
            Notify("Config", "Config '" .. configName .. "' loaded!", "check-circle")
            return true
        else
            Notify("Config", "Failed to load config: Invalid file", "x-circle")
        end
    else
        Notify("Config", "Config '" .. configName .. "' not found", "x-circle")
    end
    return false
end

local function ListConfigFiles()
    local files = {}
    for _, file in ipairs(listfiles(Config.FolderPath)) do
        local fileName = file:match("([^/]+)%.json$")
        if fileName then
            table.insert(files, fileName)
        end
    end
    return files
end

Tabs.SettingsTab:Section({ Title = gradient("Character Modifications", Color3.fromHex("#00eaff"), Color3.fromHex("#002a2e")) })
Tabs.SettingsTab:Toggle({
    Title = "Noclip",
    Callback = function(state) ToggleNoclip(state) end
})
Tabs.SettingsTab:Toggle({
    Title = "Anti-AFK",
    Callback = function(state) ToggleAntiAFK(state) end
})

Tabs.SettingsTab:Section({ Title = gradient("Hitboxes", Color3.fromHex("#ff0000"), Color3.fromHex("#300000")) })
Tabs.SettingsTab:Toggle({
    Title = "Enable Hitboxes",
    Callback = function(state)
        Settings.Hitbox.Enabled = state
        if state then
            Settings.Hitbox.Connection = RunService.Heartbeat:Connect(UpdateHitboxes)
        else
            for _, box in pairs(Settings.Hitbox.Adornments) do
                if box then box:Destroy() end
            end
            Settings.Hitbox.Adornments = {}
            if Settings.Hitbox.Connection then
                Settings.Hitbox.Connection:Disconnect()
                Settings.Hitbox.Connection = nil
            end
        end
    end
})
Tabs.SettingsTab:Slider({
    Title = "Hitbox Size",
    Value = { Min = 1, Max = 10, Default = 5 },
    Callback = function(value)
        Settings.Hitbox.Size = value
        UpdateHitboxes()
    end
})
Tabs.SettingsTab:Colorpicker({
    Title = "Hitbox Color",
    Default = Settings.Hitbox.Color,
    Callback = function(color)
        Settings.Hitbox.Color = color
        UpdateHitboxes()
    end
})

Tabs.SettingsTab:Section({ Title = gradient("Script Configs", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")) })
local configDropdown
configDropdown = Tabs.SettingsTab:Dropdown({
    Title = "Select Config",
    Values = ListConfigFiles(),
    Value = Settings.Config.SelectedConfig,
    Callback = function(option)
        Settings.Config.SelectedConfig = option
        if Settings.Config.AutoLoad then
            LoadConfig(option)
        end
    end
})
Tabs.SettingsTab:Input({
    Title = "Config Name",
    Value = Settings.Config.CurrentConfigName,
    Placeholder = "Enter config name...",
    Callback = function(name)
        Settings.Config.CurrentConfigName = name
    end
})
Tabs.SettingsTab:Button({
    Title = "Save Config",
    Callback = function()
        SaveConfig()
        configDropdown:Refresh(ListConfigFiles())
    end
})
Tabs.SettingsTab:Button({
    Title = "Load Config",
    Callback = function()
        if Settings.Config.SelectedConfig ~= "" then
            LoadConfig(Settings.Config.SelectedConfig)
        else
            Notify("Config", "No config selected", "x-circle")
        end
    end
})
Tabs.SettingsTab:Toggle({
    Title = "Auto Load Config",
    Default = Settings.Config.AutoLoad,
    Callback = function(state)
        Settings.Config.AutoLoad = state
        Notify("Config", "Auto load " .. (state and "enabled" or "disabled"), "check-circle")
    end
})

-- Window Tab
Tabs.WindowTab:Section({ Title = gradient("Window Settings", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")) })
local themeValues = {}
for name, _ in pairs(WindUI:GetThemes()) do
    table.insert(themeValues, name)
end

local themeDropdown = Tabs.WindowTab:Dropdown({
    Title = "Select Theme",
    Values = themeValues,
    Value = WindUI:GetCurrentTheme(),
    Callback = function(theme)
        WindUI:SetTheme(theme)
        Notify("Window", "Theme set to " .. theme, "check-circle")
    end
})

Tabs.WindowTab:Toggle({
    Title = "Toggle Transparency",
    Default = WindUI:GetTransparency(),
    Callback = function(state)
        Window:ToggleTransparency(state)
        Notify("Window", "Transparency " .. (state and "enabled" or "disabled"), "check-circle")
    end
})

Tabs.WindowTab:Section({ Title = gradient("File Management", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")) })
local fileNameInput = ""
Tabs.WindowTab:Input({
    Title = "File Name",
    Placeholder = "Enter file name...",
    Callback = function(text)
        fileNameInput = text
    end
})

local filesDropdown
filesDropdown = Tabs.WindowTab:Dropdown({
    Title = "Select File",
    Values = ListFiles(),
    Callback = function(selectedFile)
        fileNameInput = selectedFile
    end
})

Tabs.WindowTab:Button({
    Title = "Save Window Settings",
    Callback = function()
        if fileNameInput ~= "" then
            SaveFile(fileNameInput, { Transparent = WindUI:GetTransparency(), Theme = WindUI:GetCurrentTheme() })
            Notify("Window", "Settings saved to " .. fileNameInput, "check-circle")
            filesDropdown:Refresh(ListFiles())
        else
            Notify("Window", "Enter a file name", "x-circle")
        end
    end
})

Tabs.WindowTab:Button({
    Title = "Load Window Settings",
    Callback = function()
        if fileNameInput ~= "" then
            local data = LoadFile(fileNameInput)
            if data then
                if data.Transparent then
                    Window:ToggleTransparency(data.Transparent)
                end
                if data.Theme then
                    WindUI:SetTheme(data.Theme)
                    themeDropdown:Select(data.Theme)
                end
                Notify("Window", "Settings loaded from " .. fileNameInput, "check-circle")
            else
                Notify("Window", "Failed to load file", "x-circle")
            end
        else
            Notify("Window", "No file selected", "x-circle")
        end
    end
})

Tabs.WindowTab:Button({
    Title = "Refresh File List",
    Callback = function()
        filesDropdown:Refresh(ListFiles())
    end
})

-- Themes Tab
local ThemeSettings = {
    Name = WindUI:GetCurrentTheme(),
    Accent = Color3.fromHex(WindUI:GetThemes()[WindUI:GetCurrentTheme()].Accent),
    Outline = Color3.fromHex(WindUI:GetThemes()[WindUI:GetCurrentTheme()].Outline),
    Text = Color3.fromHex(WindUI:GetThemes()[WindUI:GetCurrentTheme()].Text),
    PlaceholderText = Color3.fromHex(WindUI:GetThemes()[WindUI:GetCurrentTheme()].PlaceholderText),
}

Tabs.CreateThemeTab:Section({ Title = gradient("Theme Customization", Color3.fromHex("#ffffff"), Color3.fromHex("#636363")) })
Tabs.CreateThemeTab:Input({
    Title = "Theme Name",
    Value = ThemeSettings.Name,
    Placeholder = "Enter theme name...",
    Callback = function(name)
        ThemeSettings.Name = name
    end
})

Tabs.CreateThemeTab:Colorpicker({
    Title = "Accent Color",
    Default = ThemeSettings.Accent,
    Callback = function(color)
        ThemeSettings.Accent = color
    end
})

Tabs.CreateThemeTab:Colorpicker({
    Title = "Outline Color",
    Default = ThemeSettings.Outline,
    Callback = function(color)
        ThemeSettings.Outline = color
    end
})

Tabs.CreateThemeTab:Colorpicker({
    Title = "Text Color",
    Default = ThemeSettings.Text,
    Callback = function(color)
        ThemeSettings.Text = color
    end
})

Tabs.CreateThemeTab:Colorpicker({
    Title = "Placeholder Text Color",
    Default = ThemeSettings.PlaceholderText,
    Callback = function(color)
        ThemeSettings.PlaceholderText = color
    end
})

Tabs.CreateThemeTab:Button({
    Title = "Apply Theme",
    Callback = function()
        if ThemeSettings.Name ~= "" then
            WindUI:AddTheme({
                Name = ThemeSettings.Name,
                Accent = ThemeSettings.Accent,
                Outline = ThemeSettings.Outline,
                Text = ThemeSettings.Text,
                PlaceholderText = ThemeSettings.PlaceholderText
            })
            WindUI:SetTheme(ThemeSettings.Name)
            themeDropdown:Refresh(themeValues)
            themeDropdown:Select(ThemeSettings.Name)
            Notify("Theme", "Theme '" .. ThemeSettings.Name .. "' applied!", "check-circle")
        else
            Notify("Theme", "Enter a theme name", "x-circle")
        end
    end
})

-- Auto-Apply Saved Config
if Settings.Config.AutoLoad and Settings.Config.SelectedConfig ~= "" then
    LoadConfig(Settings.Config.SelectedConfig)
end