-- Load the Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--serv
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Misc
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--vars
local Camera = workspace.CurrentCamera
local Weapons = ReplicatedStorage.Weapons
local Debris = workspace.Debris
local RayIgnore = workspace.Ray_Ignore
local LocalPlayer = Players.LocalPlayer

local CurrentCamera = Camera
local WorldToViewportPoint = CurrentCamera.WorldToViewportPoint

-- Aimbot Settings
getgenv().Aimbot = {
    Status = false, -- Initially set to false
    Keybind = 'RightClick',
    Hitpart = 'Head',
    Prediction = {
        X = 0,
        Y = 0,
    },
    Smoothness = 0, 
}

-- Main Window Creation
local Window = Rayfield:CreateWindow({
    Name = "Ethereal | Counter Blox",
    LoadingTitle = "Ethereal | One Step Ahead",
    LoadingSubtitle = "by wasundefined",
    Theme = "Amethyst",
    DisableRayfieldPrompts = false,
    ConfigurationSaving = {
       Enabled = false,
       FolderName = nil,
       FileName = "Big Hub"
    },
})

-- Aimbot Tab
local AimbotTab = Window:CreateTab("Aimbot", 10181263678)

local Section = AimbotTab:CreateSection("Aim")

-- Toggle for Aimbot Activation
local Toggle = AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Flag = "EnableAimbot",
    Callback = function(Value)
        getgenv().Aimbot.Status = Value -- Activates or deactivates aimbot based on the toggle
    end,
})

local Section = AimbotTab:CreateSection("Modifiers")

-- Prediction X Slider
local PredictionXSlider = AimbotTab:CreateSlider({
    Name = "Prediction X",
    Range = {0, 3},
    Increment = 0.01,
    Suffix = "Units",
    CurrentValue = 0,
    Flag = "PredictionX",
    Callback = function(Value)
        getgenv().Aimbot.Prediction.X = Value
    end,
})

-- Prediction Y Slider
local PredictionYSlider = AimbotTab:CreateSlider({
    Name = "Prediction Y",
    Range = {0, 3},
    Increment = 0.01,
    Suffix = "Units",
    CurrentValue = 0,
    Flag = "PredictionY",
    Callback = function(Value)
        getgenv().Aimbot.Prediction.Y = Value
    end,
})

-- Smoothness Slider
local SmoothnessSlider = AimbotTab:CreateSlider({
    Name = "Smoothness",
    Range = {0, 20},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 0,
    Flag = "Smoothness",
    Callback = function(Value)
        getgenv().Aimbot.Smoothness = Value
    end,
})

-- Optimized Aimbot Code Implementation
local RunService = game:GetService('RunService')
local Players = game:GetService('Players')
local UserInputService = game:GetService('UserInputService')
local Camera = game.Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Player = nil
local isAiming = false

-- Function to Find Closest Player with Team Check
local function GetClosestPlayer()
    local ClosestDistance, ClosestPlayer = math.huge, nil
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer and otherPlayer.Team ~= LocalPlayer.Team and otherPlayer.Character and otherPlayer.Character:FindFirstChild(getgenv().Aimbot.Hitpart) then
            local Head = otherPlayer.Character[getgenv().Aimbot.Hitpart]
            local ScreenPosition, onScreen = Camera:WorldToViewportPoint(Head.Position)
            if onScreen then
                local Distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(ScreenPosition.X, ScreenPosition.Y)).Magnitude
                if Distance < ClosestDistance then
                    ClosestPlayer = otherPlayer
                    ClosestDistance = Distance
                end
            end
        end
    end
    return ClosestPlayer
end

-- Input Handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isAiming = true
        Player = GetClosestPlayer()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isAiming = false
        Player = nil
    end
end)

-- Aimbot Functionality on RenderStepped
RunService.RenderStepped:Connect(function()
    if not (getgenv().Aimbot.Status and Player and Player.Character and Player.Character:FindFirstChild(getgenv().Aimbot.Hitpart)) then
        return
    end
    
    local Target = Player.Character[getgenv().Aimbot.Hitpart]
    local targetPosition = Target.Position + Target.Velocity * Vector3.new(getgenv().Aimbot.Prediction.X, getgenv().Aimbot.Prediction.Y, getgenv().Aimbot.Prediction.X)
    local currentPosition = Camera.CFrame.Position
    local targetDirection = (targetPosition - currentPosition).Unit

    if isAiming then
        local currentLookVector = Camera.CFrame.LookVector
        local smoothFactor = getgenv().Aimbot.Smoothness
        local newLookVector

        if smoothFactor == 0 then
            newLookVector = targetDirection
        else
            newLookVector = currentLookVector:Lerp(targetDirection, 1 / smoothFactor)
        end

        Camera.CFrame = CFrame.new(currentPosition, currentPosition + newLookVector)
    end
end)

local VS = Window:CreateTab("Viusals", 13321848320) -- Title, Image

local Section = VS:CreateSection("Players")

VS:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Flag = "ESPCFG",
    Callback = function(Value)
        _G.esp1 = Value
    end,
})

local Section = VS:CreateSection("Effects")

VS:CreateToggle({
    Name = "Disable Scope",
    CurrentValue = false,
    Flag = "RemoveScope",
    Callback = function(Value)
        _G.RemoveScope = Value
    end,
})

VS:CreateToggle({
    Name = "Disable Flash",
    CurrentValue = false,
    Flag = "RemoveFlash",
    Callback = function(Value)
        _G.RemoveFlash = Value
    end,
})

VS:CreateToggle({
    Name = "Disable Blood",
    CurrentValue = false,
    Flag = "RemoveBlood",
    Callback = function(Value)
        _G.RemoveBlood = Value
    end,
})

VS:CreateToggle({
    Name = "Disable Bullets Holes",
    CurrentValue = false,
    Flag = "RemoveBulletsHoles",
    Callback = function(Value)
        _G.RemoveBulletsHoles = Value
    end,
})

local Section = VS:CreateSection("FOV")
VS:CreateSlider({
    Name = "Field Of View",
    Range = {0, 120},
    Increment = 1,
    CurrentValue = 80,
    Flag = "BhopSpeed", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        _G.FieldOfView = Value
    end,
})
local Section = VS:CreateSection("Environment")
local ColorPicker = VS:CreateColorPicker({
    Name = "Ambience Color",
    Color = Color3.fromRGB(255,255,255),
    Flag = "AmbienceColor", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(ambcolor)
       game.Workspace.Camera.ColorCorrection.TintColor = ambcolor
    end
})

local ms = Window:CreateTab("Misc", 11797834387) -- Title, Image
local Section = ms:CreateSection("Movement")
ms:CreateToggle({
        Name = "Enable Bhop",
        CurrentValue = false,
        Flag = "Bhop", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Value)
             _G.Bhop = Value
            end,
})

ms:CreateSlider({
    Name = "Bhop Speed",
    Range = {0, 300},
    Increment = 1,
    CurrentValue = 100,
    Flag = "BhopSpeed", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
         _G.BhopSpeed = Value
        end,
})

local exp = Window:CreateTab("Exploits", 12487510294) -- Title, Image
local Section = exp:CreateSection("Guns")

exp:CreateButton({
    Name = "No Spread",
    Callback = function()
        for _, Weapon in ipairs(Weapons:GetChildren()) do
            if Weapon:FindFirstChild("Spread") then
                Weapon:FindFirstChild("Spread").Value = 0
                for _, Spread in ipairs(Weapon:FindFirstChild("Spread"):GetChildren()) do
                    Spread.Value = 0
                end
            end 
        end
    end,
})

exp:CreateButton({
    Name = "No Reload Cooldown",
    Callback = function()
        for _, Weapon in ipairs(Weapons:GetChildren()) do
            if Weapon:FindFirstChild("ReloadTime") then
                Weapon:FindFirstChild("ReloadTime").Value = 0.05
            end 
        end
    end,
})

exp:CreateButton({
    Name = "Rapid Fire",
    Callback = function()
        for _, Weapon in ipairs(Weapons:GetChildren()) do
            if Weapon:FindFirstChild("FireRate") then
                Weapon:FindFirstChild("FireRate").Value = 0
            end 
        end
    end,
})

exp:CreateButton({
    Name = "No Equip Cooldown",
    Callback = function()
        for _, Weapon in ipairs(Weapons:GetChildren()) do
            if Weapon:FindFirstChild("EquipTime") then
                Weapon:FindFirstChild("EquipTime").Value = 0.05
            end 
        end
    end,
})

exp:CreateButton({
    Name = "Infinite Ammo",
    Callback = function()
        for _, Weapon in ipairs(Weapons:GetChildren()) do
            if Weapon:FindFirstChild("Ammo") and Weapon:FindFirstChild("StoredAmmo") then
                Weapon:FindFirstChild("Ammo").Value = 9999999999
                Weapon:FindFirstChild("StoredAmmo").Value = 9999999999
            end 
        end
    end,
})

RunService.RenderStepped:Connect(function()
    if _G.Bhop == true then
        if LocalPlayer.Character ~= nil and UserInputService:IsKeyDown(Enum.KeyCode.Space) and LocalPlayer.PlayerGui.GUI.Main.GlobalChat.Visible == false then
            LocalPlayer.Character.Humanoid.Jump = true
            local Speed = _G.BhopSpeed or 100
            local Dir = Camera.CFrame.LookVector * Vector3.new(1,0,1)
            local Move = Vector3.new()

            Move = UserInputService:IsKeyDown(Enum.KeyCode.W) and Move + Dir or Move
            Move = UserInputService:IsKeyDown(Enum.KeyCode.S) and Move - Dir or Move
            Move = UserInputService:IsKeyDown(Enum.KeyCode.D) and Move + Vector3.new(-Dir.Z,0,Dir.X) or Move
            Move = UserInputService:IsKeyDown(Enum.KeyCode.A) and Move + Vector3.new(Dir.Z,0,-Dir.X) or Move
            if Move.Unit.X == Move.Unit.X then
                Move = Move.Unit
                LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(Move.X * Speed, LocalPlayer.Character.HumanoidRootPart.Velocity.Y, Move.Z * Speed)
            end
        end
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    if _G.RemoveScope == true then
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.ImageTransparency = 1
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.ImageTransparency = 1
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Size = UDim2.new(2,0,2,0)
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Position = UDim2.new(-0.5,0,-0.5,0)
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Blur.ImageTransparency = 1
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Blur.Blur.ImageTransparency = 1
        LocalPlayer.PlayerGui.GUI.Crosshairs.Frame1.Transparency = 1
        LocalPlayer.PlayerGui.GUI.Crosshairs.Frame2.Transparency = 1
        LocalPlayer.PlayerGui.GUI.Crosshairs.Frame3.Transparency = 1
        LocalPlayer.PlayerGui.GUI.Crosshairs.Frame4.Transparency = 1
    else
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.ImageTransparency = 0
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.ImageTransparency = 0
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Size = UDim2.new(1,0,1,0)
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Position = UDim2.new(0,0,0,0)
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Blur.ImageTransparency = 0
        LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Blur.Blur.ImageTransparency = 0
        LocalPlayer.PlayerGui.GUI.Crosshairs.Frame1.Transparency = 0
        LocalPlayer.PlayerGui.GUI.Crosshairs.Frame2.Transparency = 0
        LocalPlayer.PlayerGui.GUI.Crosshairs.Frame3.Transparency = 0
        LocalPlayer.PlayerGui.GUI.Crosshairs.Frame4.Transparency = 0
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    if _G.RemoveFlash == true then
        LocalPlayer.PlayerGui.Blnd.Enabled = false
    else
        LocalPlayer.PlayerGui.Blnd.Enabled = true
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    if _G.RemoveBulletsHoles == true then
        for i,v in pairs(Debris:GetChildren()) do
            if v.Name == "Bullet" then
                v:Remove()
            end
        end
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    if _G.RemoveBlood == true then
        for i,v in pairs(Debris:GetChildren()) do
            if v.Name == "SurfaceGui" then
                v:Remove()
            end
        end
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    for _, Player in ipairs(Players:GetChildren()) do
        if ESPSettings.Enabled == true then
            if ESPSettings.UseTeamColor == true then
                if Player.Character:FindFirstChild("Highlight") then
                    Player.Character.Highlight.FillColor = Player.TeamColor.Color
                else
                    local Highlight = Instance.new("Highlight", Player.Character)
                    Highlight.FillColor = Player.TeamColor.Color
                end
            else
                if Player.Character:FindFirstChild("Highlight") then
                    Player.Character.Highlight.FillColor = ESPSettings.ChamsColor or Color3.fromRGB(200,200,200)
                else
                    local Highlight = Instance.new("Highlight", Player.Character)
                    Highlight.FillColor = ESPSettings.ChamsColor or Color3.fromRGB(200,200,200)
                end
            end
        else
            if Player.Character:FindFirstChild("Highlight") then
                Player.Character.Highlight:Destroy()
            end
        end
    end
    task.wait()
end)

RunService.RenderStepped:Connect(function()
    Camera.FieldOfView = _G.FieldOfView or 80
    task.wait()
end)

--espcfg

_G.esp1 = false

function esp1()
    local lplr = game.Players.LocalPlayer
    local camera = game:GetService("Workspace").CurrentCamera
    local CurrentCamera = workspace.CurrentCamera
    local worldToViewportPoint = CurrentCamera.worldToViewportPoint

    local HeadOff = Vector3.new(0, 0.5, 0)
    local LegOff = Vector3.new(0, 3, 0)

    local function createBoxESP(v)
        local BoxOutline = Drawing.new("Square")
        BoxOutline.Visible = false
        BoxOutline.Color = Color3.new(0, 0, 0)
        BoxOutline.Thickness = 2
        BoxOutline.Transparency = 1
        BoxOutline.Filled = false

        local Box = Drawing.new("Square")
        Box.Visible = false
        Box.Color = Color3.new(1, 1, 1)
        Box.Thickness = 1
        Box.Transparency = 1
        Box.Filled = false

        -- Function to handle box drawing
        local function boxesp()
            game:GetService("RunService").RenderStepped:Connect(function()
                if v.Character ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v ~= lplr and v.Character.Humanoid.Health > 0 then
                    local Vector, onScreen = camera:worldToViewportPoint(v.Character.HumanoidRootPart.Position)

                    local RootPart = v.Character.HumanoidRootPart
                    local Head = v.Character.Head
                    local RootPosition, RootVis = worldToViewportPoint(CurrentCamera, RootPart.Position)
                    local HeadPosition = worldToViewportPoint(CurrentCamera, Head.Position + HeadOff)
                    local LegPosition = worldToViewportPoint(CurrentCamera, RootPart.Position - LegOff)

                    if onScreen then
                        BoxOutline.Size = Vector2.new(1000 / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
                        BoxOutline.Position = Vector2.new(RootPosition.X - BoxOutline.Size.X / 2, RootPosition.Y - BoxOutline.Size.Y / 2)

                        Box.Size = Vector2.new(1000 / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
                        Box.Position = Vector2.new(RootPosition.X - Box.Size.X / 2, RootPosition.Y - Box.Size.Y / 2)

                        if v.TeamColor == lplr.TeamColor then
                            BoxOutline.Visible = false
                            Box.Visible = false
                        else
                            -- Check the value of _G.esp1 to control visibility
                            if _G.esp1 then
                                BoxOutline.Visible = true
                                Box.Visible = true
                            else
                                BoxOutline.Visible = false
                                Box.Visible = false
                            end
                        end
                    else
                        BoxOutline.Visible = false
                        Box.Visible = false
                    end
                else
                    BoxOutline.Visible = false
                    Box.Visible = false
                end
            end)
        end

        coroutine.wrap(boxesp)()
    end

    -- This will be called when a new player joins
    game.Players.PlayerAdded:Connect(function(v)
        createBoxESP(v)

        -- If the player already has a character, we add the ESP box immediately
        if v.Character then
            createBoxESP(v)
        end
    end)

    -- Initializing the ESP boxes for players already in the game
    for _, v in pairs(game.Players:GetChildren()) do
        createBoxESP(v)
    end
end

esp1()
