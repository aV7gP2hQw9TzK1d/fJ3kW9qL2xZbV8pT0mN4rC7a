--///////////////////////////////////////////////////

-- Created by Ege
-- Yes I used ChatGPT to configure some stuff lol
-- Enjoy

--///////////////////////////////////////////////////

-- Extra
-- Username ESP Configuration
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local enemyEspEnabled = false
local everyoneEspEnabled = false
local enemyBillboards = {}
local everyoneBillboards = {}

-- Function to create a BillboardGui for a player
local function createBillboardGui(player)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 80, 0, 50)
    billboard.Adornee = player.Character:WaitForChild("Head")
    billboard.AlwaysOnTop = true
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextScaled = true
    nameLabel.Parent = billboard
    
    billboard.Parent = player.Character:WaitForChild("Head")
    return billboard
end

-- Function to update ESP for the enemy team players only
local function updateEnemyEsp()
    -- Clear any existing ESP
    for _, billboard in pairs(enemyBillboards) do
        billboard:Destroy()
    end
    enemyBillboards = {}

    -- Add ESP only for enemy team players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character and player.Character:FindFirstChild("Head") then
            local billboard = createBillboardGui(player)
            table.insert(enemyBillboards, billboard)
        end
    end
end

-- Function to update ESP for all players
local function updateEveryoneEsp()
    -- Clear any existing ESP
    for _, billboard in pairs(everyoneBillboards) do
        billboard:Destroy()
    end
    everyoneBillboards = {}

    -- Add ESP for all players
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Head") then
            local billboard = createBillboardGui(player)
            table.insert(everyoneBillboards, billboard)
        end
    end
end

-- Rejoin Configuration
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local currentPlaceId = game.PlaceId -- Get the current game PlaceId

-- Get the current server's instance ID
local currentServerId = game.JobId

-- Function to kick and rejoin the player in the same server
local function kickAndRejoin()
    local player = Players.LocalPlayer

    -- Ensure the player is valid before proceeding
    if player then
        -- Inform the player they're rejoining
        player:Kick("\n★ Legacy | Rejoining...")

        -- Wait for the player to be kicked out of the game
        wait(0)

        -- Teleport the player to the same game instance (same server)
        TeleportService:TeleportToPlaceInstance(currentPlaceId, currentServerId, player)
    end
end

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

-- Separate connection tables for each toggle
local enemyConnections = {}
local allConnections = {}

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

local function removeHighlight(player)
    if player.Character and player.Character:FindFirstChild("Highlight") then
        player.Character.Highlight:Destroy()
    end
end

local function updateEnemyHighlights()
    for _, player in ipairs(players:GetPlayers()) do
        if player.Team ~= localPlayer.Team and enemyToggleState then
            addHighlight(player)
        end

        -- Listen for character respawns for enemies only
        if enemyToggleState and not enemyConnections[player] then
            enemyConnections[player] = player.CharacterAdded:Connect(function()
                if enemyToggleState and player.Team ~= localPlayer.Team then
                    addHighlight(player)
                end
            end)
        end
    end
end

local function updateHighlights()
    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer and toggleState then
            addHighlight(player)
        end

        -- Listen for character respawns for everyone
        if toggleState and not allConnections[player] then
            allConnections[player] = player.CharacterAdded:Connect(function()
                if toggleState then
                    addHighlight(player)
                end
            end)
        end
    end
end

local function cleanEnemyConnections()
    for player, conn in pairs(enemyConnections) do
        if conn then conn:Disconnect() end
        enemyConnections[player] = nil
    end
end

local function cleanAllConnections()
    for player, conn in pairs(allConnections) do
        if conn then conn:Disconnect() end
        allConnections[player] = nil
    end
end

--///////////////////////////////////////////////////

-- Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Main Window
local Window = OrionLib:MakeWindow({Name = "★ Legacy", HidePremium = false, SaveConfig = true, IntroIcon = "rbxassetid://1264515756", IntroText = "Legacy", ConfigFolder = "OrionTest"})

-- Notifications
OrionLib:MakeNotification({
	Name = "★ Legacy",
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
        OrionLib:Destroy()
        wait(0.1)
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

local Section = Player:AddSection({
	Name = "Modifiers"
})

Player:AddSlider({
	Name = "WalkSpeed Changer",
	Min = 16,
	Max = 1000,
	Default = 16,
	Color = Color3.fromRGB(60,60,60),
	Increment = 1,
	ValueName = "WalkSpeed",
	Callback = function(ws1)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = ws1
		getgenv().WalkSpeedValue = ws1
	end    
})

Player:AddSlider({
	Name = "JumpPower Changer",
	Min = 50,
	Max = 1000,
	Default = 50,
	Color = Color3.fromRGB(60,60,60),
	Increment = 1,
	ValueName = "JumpPower",
	Callback = function(jp1)
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = jp1
		getgenv().JumpPowerValue = jp1
	end    
})

getgenv().WalkSpeedValue = 16
getgenv().JumpPowerValue = 50

local loopActive = false
local function updateHumanoidValues()
	while loopActive do
		local character = game.Players.LocalPlayer.Character
		if character and character:FindFirstChild("Humanoid") then
			character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue
			character.Humanoid.JumpPower = getgenv().JumpPowerValue
		end
		wait(0.5)
	end
end

Player:AddToggle({
	Name = "Lock Multiplier Values",
	Default = false,
	Callback = function(Value)
		loopActive = Value
		if loopActive then
			spawn(updateHumanoidValues)
		end
	end    
})

Player:AddParagraph("Lock Multiplier Values Toggle","When its turned on, it will prevent your walkspeed/jumppower to be changed automaticly by the game once you reset your character or die so you won't have to manually adjust the changes everytime after you reset/die.")

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
            updateEnemyHighlights()
            
            -- Listen for new enemies joining
            if not enemyConnections["PlayerAdded"] then
                enemyConnections["PlayerAdded"] = players.PlayerAdded:Connect(function(player)
                    player.CharacterAdded:Wait()
                    if enemyToggleState and player.Team ~= localPlayer.Team then
                        addHighlight(player)
                    end
                end)
            end
        else
            -- Remove highlights for enemies and clean connections
            for _, player in ipairs(players:GetPlayers()) do
                if player.Team ~= localPlayer.Team then
                    removeHighlight(player)
                end
            end
            cleanEnemyConnections()
        end
    end
})

Visuals:AddToggle({
    Name = "Highlight ESP [ EVERYONE ]",
    Default = false,
    Callback = function(Value)
        toggleState = Value
        if Value then
            updateHighlights()
            
            -- Listen for new players joining
            if not allConnections["PlayerAdded"] then
                allConnections["PlayerAdded"] = players.PlayerAdded:Connect(function(player)
                    player.CharacterAdded:Wait()
                    if toggleState then
                        addHighlight(player)
                    end
                end)
            end
        else
            -- Remove highlights for everyone and clean connections
            for _, player in ipairs(players:GetPlayers()) do
                removeHighlight(player)
            end
            cleanAllConnections()
        end
    end
})

local Section = Visuals:AddSection({
	Name = "Username ESP"
})

Visuals:AddToggle({
    Name = "Username ESP [ ENEMY ]",
    Default = false,
    Callback = function(Value)
        enemyEspEnabled = Value
        if enemyEspEnabled then
            updateEnemyEsp()
        else
            for _, billboard in pairs(enemyBillboards) do
                billboard:Destroy()
            end
            enemyBillboards = {}
        end
    end
})

Visuals:AddToggle({
    Name = "Username ESP [ EVERYONE ]",
    Default = false,
    Callback = function(Value)
        everyoneEspEnabled = Value
        if everyoneEspEnabled then
            updateEveryoneEsp()
        else
            for _, billboard in pairs(everyoneBillboards) do
                billboard:Destroy()
            end
            everyoneBillboards = {}
        end
    end
})

-- Update ESP when a player joins, leaves, or changes team
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if enemyEspEnabled then
            updateEnemyEsp()
        end
        if everyoneEspEnabled then
            updateEveryoneEsp()
        end
    end)
end)

Players.PlayerRemoving:Connect(function()
    if enemyEspEnabled then
        updateEnemyEsp()
    end
    if everyoneEspEnabled then
        updateEveryoneEsp()
    end
end)

-- Update ESP if the local player changes teams
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
    if enemyEspEnabled then
        updateEnemyEsp()
    end
end)

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

-- Miscellaneous Tab
local Misc = Window:MakeTab({
	Name = "● Miscellaneous",
	Icon = "rbxassetid://18569843302",
	PremiumOnly = false
})

local Section = Misc:AddSection({
	Name = "Teleportation"
})


-- Function to get all players except the local player
local function getPlayers()
    local players = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    return players
end

-- Create a dropdown with all players except the local player
local selectedPlayerName = ""  -- Variable to store the selected player name
local playerDropdown = Misc:AddDropdown({
    Name = "Select a Player to Teleport",
    Default = "",  -- No one selected by default
    Options = getPlayers(),
    Callback = function(Value)
        selectedPlayerName = Value  -- Store the selected player's name
        print("Selected player:", selectedPlayerName)
    end    
})

-- Teleport button
Misc:AddButton({
    Name = "Teleport to the Selected Player",
    Callback = function()
        if selectedPlayerName == "" then
            warn("No player selected!")
            return
        end
        
        -- Find the selected player by name
        local selectedPlayer = game.Players:FindFirstChild(selectedPlayerName)
        
        if selectedPlayer and selectedPlayer.Character then
            -- Teleport the local player to the selected player's position
            local character = game.Players.LocalPlayer.Character
            if character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- Set the CFrame of the local player's HumanoidRootPart to the selected player's HumanoidRootPart
                character:SetPrimaryPartCFrame(selectedPlayer.Character.HumanoidRootPart.CFrame)
            end
        else
            warn("Selected player or their character is not available!")
        end
    end    
})


local Section = Misc:AddSection({
	Name = "Save Point"
})

local savedPosition = nil  -- Variable to store the saved position

-- Save Current Position Button
Misc:AddButton({
    Name = "Save Current Position",
    Callback = function()
        -- Get the LocalPlayer and its HumanoidRootPart
        local player = game.Players.LocalPlayer
        local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoidRootPart then
            -- Save the current CFrame of the HumanoidRootPart
            savedPosition = humanoidRootPart.CFrame
            print("Position saved!")
        else
            print("HumanoidRootPart not found!")
        end
    end
})

-- Teleport to the Saved Position Button
Misc:AddButton({
    Name = "Teleport to the Saved Position",
    Callback = function()
        -- Check if a saved position exists
        if savedPosition then
            -- Get the LocalPlayer and its HumanoidRootPart
            local player = game.Players.LocalPlayer
            local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoidRootPart then
                -- Teleport the player to the saved position
                humanoidRootPart.CFrame = savedPosition
                print("Teleported to saved position!")
            else
                print("HumanoidRootPart not found!")
            end
        else
            print("No saved position to teleport to!")
        end
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
        kickAndRejoin()
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
	Name = "Infinite Yield [ ADMIN COMMANDS ]",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source'))()
  	end    
})

US:AddButton({
	Name = "Dex Explorer",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Scripts/Dex.lua'))()
  	end    
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
	Name = "Fling GUI",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Scripts/Fling.lua'))()
  	end    
})

US:AddButton({
	Name = "Fling All",
	Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
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
	Name = "Flee The Facility Scripts"
})

GS:AddButton({
	Name = "Flee The Facility - ESP | Auto-Play | Never Fail",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/LeviTheOtaku/roblox-scripts/main/FTFHAX.lua",true))()
  	end    
})

local Section = GS:AddSection({
	Name = "Arsenal Scripts"
})

GS:AddButton({
	Name = "Arsenal - Aimbot | ESP | Infinite Ammo",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/tbao143/thaibao/main/ArsenalTbaoHubNew'))()
  	end    
})

local Section = GS:AddSection({
	Name = "Counter Blox Scripts"
})

GS:AddButton({
	Name = "Counter Blox - Aimbot | ESP | No-Spread | Infinite Ammo",
	Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Scripts/EtherealCB.lua'))()
  	end    
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

-- Function to update the dropdown list of players
local function updatePlayerDropdown()
    -- Get the updated list of players
    local playerNames = getPlayers()

    -- Update the dropdown options
    playerDropdown:SetOptions(playerNames)
end

-- Update the dropdown initially
updatePlayerDropdown()

-- Listen for players joining and update the dropdown
game.Players.PlayerAdded:Connect(function(player)
    -- Update dropdown when a new player joins
    updatePlayerDropdown()
end)

-- Listen for players leaving and update the dropdown
game.Players.PlayerRemoving:Connect(function(player)
    -- Update dropdown when a player leaves
    updatePlayerDropdown()
end)

--///////////////////////////////////////////////////
