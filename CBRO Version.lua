--///////////////////////////////////////////////////

-- Created by Ege
-- Yes I used ChatGPT to configure some stuff lol
-- Enjoy

--///////////////////////////////////////////////////

-- Extra
-- X-Ray Configuration

-- Table to store original transparency values
local originalTransparencies = {}

-- Function to enable X-ray vision across the entire game
local function enableXRay(transparencyLevel)
    for _, obj in pairs(game:GetDescendants()) do
        -- Check if the object is a part or mesh that can have transparency
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            -- Store original transparency if not already stored
            if originalTransparencies[obj] == nil then
                originalTransparencies[obj] = obj.Transparency
            end
            -- Set to desired transparency level (e.g., 0.5 for semi-transparent)
            obj.Transparency = transparencyLevel
        end
    end
end

-- Function to disable X-ray vision and restore original transparency
local function disableXRay()
    for obj, originalTransparency in pairs(originalTransparencies) do
        -- Restore the original transparency
        if obj and obj.Parent then  -- Check if the object still exists
            obj.Transparency = originalTransparency
        end
    end
    -- Clear the table after restoring transparencies
    originalTransparencies = {}
end

-- Tracers Configuration
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = game.Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local tracerColor = Color3.fromRGB(255, 0, 0) -- Red color for tracers
local tracerThickness = 1 -- Thickness of the tracer line

local tracers = {} -- Table to store tracers for each player
local toggleStateEnemy = false
local toggleStateEveryone = false

-- Function to create a tracer line
local function createTracer()
    local tracer = Drawing.new("Line")
    tracer.Color = tracerColor
    tracer.Thickness = tracerThickness
    tracer.Visible = false
    return tracer
end

-- Function to update tracers based on toggle states
local function updateTracers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local tracer = tracers[player]
            local character = player.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

            if not tracer then
                tracer = createTracer()
                tracers[player] = tracer
            end

            -- Determine if we should draw the tracer
            local showTracer = false
            if toggleStateEveryone then
                showTracer = true
            elseif toggleStateEnemy and player.Team ~= LocalPlayer.Team then
                showTracer = true
            end

            -- Project the position to the screen if we should show the tracer
            if showTracer then
                local screenPosition, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
                if onScreen then
                    tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) -- Center of screen
                    tracer.To = Vector2.new(screenPosition.X, screenPosition.Y) -- Player's position on screen
                    tracer.Visible = true
                else
                    tracer.Visible = false -- Hide if player goes off-screen
                end
            else
                tracer.Visible = false
            end
        end
    end
end

-- Function to clean up tracers for players who have left
local function removeTracer(player)
    if tracers[player] then
        tracers[player]:Remove()
        tracers[player] = nil
    end
end

-- Function to clean up all tracers
local function clearAllTracers()
    for _, tracer in pairs(tracers) do
        tracer:Remove()
    end
    tracers = {}
end

-- Connect to remove tracers when a player leaves
Players.PlayerRemoving:Connect(removeTracer)

-- Misc
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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
    TeamCheck = false, -- Default to true, meaning the aimbot will only target opposite team players
}

-- Essentials
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local localPlayer = players.LocalPlayer

-- Function to add highlight to a player
local function addHighlight(player)
    if player.Character then
        if not player.Character:FindFirstChild("Highlight") then
            local highlight = Instance.new("Highlight")
            highlight.Parent = player.Character
            highlight.FillColor = Color3.new(1, 0, 0) -- Red for enemy
            highlight.OutlineColor = Color3.new(1, 1, 1) -- White
        end
    end
end

-- Function to remove highlight from a player
local function removeHighlight(player)
    if player.Character and player.Character:FindFirstChild("Highlight") then
        player.Character.Highlight:Destroy()
    end
end

local connections = {}
local toggleState = false
local enemyToggleState = false

-- Function to update highlights for everyone
local function updateHighlights()
    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer then
            addHighlight(player)
        end

        -- Listen for character respawns
        if not connections[player] then
            connections[player] = player.CharacterAdded:Connect(function()
                if toggleState then
                    addHighlight(player)
                end
            end)
        end
    end
end

-- Function to update highlights for enemies (opposite team)
local function updateEnemyHighlights()
    for _, player in ipairs(players:GetPlayers()) do
        if player.Team ~= localPlayer.Team then  -- Check if they are on the opposite team
            addHighlight(player)
        end

        -- Listen for character respawns
        if not connections[player] then
            connections[player] = player.CharacterAdded:Connect(function()
                if enemyToggleState then
                    addHighlight(player)
                end
            end)
        end
    end
end

-- Cleanup function for connections
local function cleanConnections()
    for player, conn in pairs(connections) do
        if conn then
            conn:Disconnect()
        end
        connections[player] = nil
    end
end

--///////////////////////////////////////////////////

-- Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Main Window
local Window = OrionLib:MakeWindow({Name = "★ Legacy", HidePremium = false, SaveConfig = true, IntroIcon = "rbxassetid://1264515756", IntroText = "Legacy", ConfigFolder = "OrionTest"})

-- Notifications
OrionLib:MakeNotification({
	Name = "Legacy",
	Content = "Legacy is set! Made by Ege.",
	Image = "rbxassetid://1264515756",
	Time = 69420
})

-- Main Tab
local Main = Window:MakeTab({
	Name = "● Main",
	Icon = "rbxassetid://170940873",
	PremiumOnly = false
})

local Section = Main:AddSection({
	Name = "Information"
})

Main:AddParagraph("Message from Ege:","Hi, Legacy is a script that contains a bunch of other scripts for most of the games on Roblox and it also has bunch of extra universal stuff in it.")
Main:AddParagraph("What is Legacy for?","Its mainly for easy access to everything. I created a single script that contains bunch of scripts and features to easily access them from a single script and before you ask, yes I skidded a bunch of stuff to put in here and easily acces them. I guess you can call me a loser but yeah, I hope you enjoy it.")
Main:AddParagraph("About Script Hub Scripts:","None of the scripts in the script hub belongs to me and they all are open source scripts meaning you can find them in the internet by doing enough research.")
Main:AddParagraph("Important Note from Ege:","I do not claim any responsibility if anything happens to your Roblox account. Use it at your own risk.")

local Section = Main:AddSection({
	Name = "Miscellaneous"
})

Main:AddButton({
	Name = "Re-Execute Legacy",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Loader.lua'))()
  	end    
})

-- Player Tab
local Player = Window:MakeTab({
	Name = "● Player",
	Icon = "rbxassetid://12823489098",
	PremiumOnly = false
})

local Section = Player:AddSection({
	Name = "Utilites"
})

Player:AddButton({
	Name = "Fly [ X ]",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Essentials/Fly.lua'))()
  	end    
})

Player:AddButton({
	Name = "NoClip [ Z ]",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Essentials/NoClip.lua'))()
  	end    
})

Player:AddButton({
	Name = "Click Teleport [ CTRL + LCLICK ]",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Essentials/ClickTP.lua'))()
  	end    
})

Player:AddButton({
	Name = "Infinite Jump",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Essentials/Infinite%20Jump.lua'))()
  	end    
})

Player:AddButton({
	Name = "Wall Walk",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Essentials/Wall%20Walk.lua'))()
  	end    
})

Player:AddToggle({
	Name = "Anti AFK",
	Default = false,
	Callback = function(antiafk1)
		print("1", antiafk1)
		if antiafk1 then
			-- Start
			while antiafk1 do
				antiafkfc()
				wait(2) -- Repeat every 2 seconds
			end
		end
	end    
})

-- Visuals Tab
local Visuals = Window:MakeTab({
	Name = "● Visuals",
	Icon = "rbxassetid://13321848320",
	PremiumOnly = false
})

local Section = Visuals:AddSection({
	Name = "Box ESP"
})

Visuals:AddToggle({
	Name = "Box ESP [ ENEMY ]",
	Default = false,
	Callback = function(Value)
		_G.BoxESP = Value
	end    
})

Visuals:AddToggle({
	Name = "Box ESP [ EVERYONE ]",
	Default = false,
	Callback = function(Value)
		_G.BoxESP2 = Value
	end    
})

local Section = Visuals:AddSection({
	Name = "Highlight ESP"
})

Visuals:AddToggle({
    Name = "Highlight ESP [ ENEMY ]",
    Default = false,
    Callback = function(Value)
        enemyToggleState = Value
        if Value then
            -- Add highlights to enemies
            updateEnemyHighlights()

            -- Listen for new players joining
            connections["PlayerAdded"] = players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Wait()
                if enemyToggleState and player.Team ~= localPlayer.Team then
                    addHighlight(player)
                end
            end)
        else
            -- Remove all enemy highlights and cleanup
            for _, player in ipairs(players:GetPlayers()) do
                if player.Team ~= localPlayer.Team then
                    removeHighlight(player)
                end
            end
            cleanConnections()
        end
    end    
})

Visuals:AddToggle({
	Name = "Highlight ESP [ EVERYONE ]",
	Default = false,
	Callback = function(Value)
        toggleState = Value
        if Value then
            -- Add highlights to all players
            updateHighlights()

            -- Listen for new players joining
            connections["PlayerAdded"] = players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Wait()
                if toggleState then
                    addHighlight(player)
                end
            end)
        else
            -- Remove all highlights and cleanup
            for _, player in ipairs(players:GetPlayers()) do
                removeHighlight(player)
            end
            cleanConnections()
        end
    end    
})

local Section = Visuals:AddSection({
	Name = "Tracers"
})

Visuals:AddToggle({
    Name = "Tracers [ ENEMY ]",
    Default = false,
    Callback = function(Value)
        toggleStateEnemy = Value
        toggleStateEveryone = false -- Disable all-player mode if enemy toggle is active
        if Value then
            -- Update tracers for enemy players only
            updateTracers()
        else
            clearAllTracers() -- Clear tracers if toggle is turned off
        end
    end
})

Visuals:AddToggle({
    Name = "Tracers [ EVERYONE ]",
    Default = false,
    Callback = function(Value)
        toggleStateEveryone = Value
        toggleStateEnemy = false -- Disable enemy-only mode if all-players toggle is active
        if Value then
            -- Update tracers for all players
            updateTracers()
        else
            clearAllTracers() -- Clear tracers if toggle is turned off
        end
    end
})

local Section = Visuals:AddSection({
	Name = "FOV"
})

Visuals:AddSlider({
	Name = "Field Of View",
	Min = 0,
	Max = 120,
	Default = 70,
	Color = Color3.fromRGB(60,60,60),
	Increment = 1,
	ValueName = "FOV",
	Callback = function(FOV1)
		game.Workspace.Camera.FieldOfView = FOV1
	end    
})

local Section = Visuals:AddSection({
	Name = "Graphics"
})

Visuals:AddButton({
	Name = "Super Low GFX [ FPS BOOSTER ]",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Essentials/Low%20GFX.lua'))()
  	end    
})

Visuals:AddToggle({
    Name = "X-Ray",
    Default = false,
    Callback = function(Value)
        local transparencyLevel = 0.5 -- Set your preferred transparency level here
        if Value then
            enableXRay(transparencyLevel) -- Enable X-ray when toggle is on
        else
            disableXRay() -- Disable X-ray and restore transparency when toggle is off
        end
    end    
})

-- Game Scripts Tab
local Combat = Window:MakeTab({
	Name = "● Combat",
	Icon = "rbxassetid://813297130",
	PremiumOnly = false
})

local Section = Combat:AddSection({
	Name = "Aimbot"
})

Combat:AddToggle({
	Name = "Aimbot [ RCLICK ]",
	Default = false,
	Callback = function(Value)
		getgenv().Aimbot.Status = Value
	end    
})

local Section = Combat:AddSection({
	Name = "Aimbot Configuration"
})

Combat:AddToggle({
    Name = "Team Check",
    Default = false,
    Callback = function(Value)
        getgenv().Aimbot.TeamCheck = Value
    end    
})

Combat:AddSlider({
	Name = "Smoothness",
	Min = 0,
	Max = 20,
	Default = 0,
	Color = Color3.fromRGB(255,255,255),
	Increment = 0.1,
	ValueName = "Smoothness",
	Callback = function(Value)
		getgenv().Aimbot.Smoothness = Value
	end    
})

Combat:AddSlider({
	Name = "Prediction X",
	Min = 0,
	Max = 20,
	Default = 0,
	Color = Color3.fromRGB(255,255,255),
	Increment = 0.01,
	ValueName = "PredictionX",
	Callback = function(Value)
		getgenv().Aimbot.Prediction.X = Value
	end    
})

Combat:AddSlider({
	Name = "Prediction Y",
	Min = 0,
	Max = 20,
	Default = 0,
	Color = Color3.fromRGB(255,255,255),
	Increment = 0.01,
	ValueName = "PredictionY",
	Callback = function(Value)
		getgenv().Aimbot.Prediction.Y = Value
	end    
})
-- Game Tab
local Game = Window:MakeTab({
	Name = "● Game",
	Icon = "rbxassetid://96996641562298",
	PremiumOnly = false
})

local Section = Game:AddSection({
	Name = "Miscellaneous"
})

Game:AddButton({
	Name = "ReJoin",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/Legacy/refs/heads/main/Essentials/ReJoin.lua'))()
  	end    
})

Game:AddButton({
	Name = "Hop Server",
	Callback = function()
        local Http = game:GetService("HttpService") local TPS = game:GetService("TeleportService") local Api = "https://games.roblox.com/v1/games/" local _place = game.PlaceId local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100" function ListServers(cursor) local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or "")) return Http:JSONDecode(Raw) end local Server, Next; repeat local Servers = ListServers(Next) Server = Servers.data[1] Next = Servers.nextPageCursor until Server TPS:TeleportToPlaceInstance(_place,Server.id,game.Players.LocalPlayer)
  	end    
})

-- Useful Scripts Tab
local US = Window:MakeTab({
	Name = "● Useful Scripts",
	Icon = "rbxassetid://7414445494",
	PremiumOnly = false
})

local Section = US:AddSection({
	Name = "Scripts"
})

US:AddButton({
	Name = "Chat Spoofer",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Scripts/Chat%20Spoofer.lua'))()
  	end    
})

US:AddButton({
	Name = "Chat Bypasser",
	Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/keSD0xcp'))()
  	end    
})

US:AddButton({
	Name = "Anti AFK",
	Callback = function()
        loadstring(game:HttpGet('loadstring(game:HttpGet("https://raw.githubusercontent.com/luca5432/Roblox-ANTI-AFK-SCRIPT/refs/heads/main/Script"))()'))()
  	end    
})

-- Game Scripts Tab
local GS = Window:MakeTab({
	Name = "● Game Scripts",
	Icon = "rbxassetid://12684121161",
	PremiumOnly = false
})

local Section = GS:AddSection({
	Name = "Rivals Scripts"
})

GS:AddButton({
	Name = "Rivals - Aimbot | ESP | Silent Aim",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/tbao143/thaibao/refs/heads/main/TbaoHubRivals'))()
  	end    
})

local Section = GS:AddSection({
	Name = "Blade Ball Scripts"
})

GS:AddButton({
	Name = "Blade Ball - Auto Parry",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/begula-mqc/Benware/refs/heads/main/benhub"))()
  	end    
})

local Section = GS:AddSection({
	Name = "Murder Mystery 2 Scripts"
})

GS:AddButton({
	Name = "Murder Mystery 2 - Autofarm",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/itsnoctural/Utilities/refs/heads/main/MurderMystery2.lua"))()
  	end    
})

-- Extra Scripts
-- Box ESP Configuration
_G.BoxESP = false

function BoxESP()
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
                            -- Check the value of _G.BoxESP to control visibility
                            if _G.BoxESP then
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

BoxESP()

-- BoxESP2 Configuration
_G.BoxESP2 = false

function BoxESP2()
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
        local function boxesp2()
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

                        -- Check visibility condition for Box ESP
                        if _G.BoxESP2 then
                            BoxOutline.Visible = true
                            Box.Visible = true
                        else
                            BoxOutline.Visible = false
                            Box.Visible = false
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

        coroutine.wrap(boxesp2)()
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

BoxESP2()

-- Function for anti afk
local function antiafkfc()
	local mouseLocation = UserInputService:GetMouseLocation()
	local inputObject = Instance.new("InputObject")
	inputObject.UserInputType = Enum.UserInputType.MouseButton2
	inputObject.Position = mouseLocation

	UserInputService.InputBegan:Fire(inputObject, false)
end

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
        -- Check if the player is the local player, is on the same team, or has no character
        if otherPlayer ~= LocalPlayer and
           (not getgenv().Aimbot.TeamCheck or otherPlayer.Team ~= LocalPlayer.Team) and
           otherPlayer.Character and
           otherPlayer.Character:FindFirstChild(getgenv().Aimbot.Hitpart) then
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

-- Update tracers every frame
RunService.RenderStepped:Connect(updateTracers)

--///////////////////////////////////////////////////
