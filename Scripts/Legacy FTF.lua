neverfailhack = true

spawn (function()
while true do
wait()
if neverfailhack == true then
game.ReplicatedStorage.RemoteEvent:FireServer("SetPlayerMinigameResult",true)
end
end
end)

local function resizeTriggers()
    local partNames = {
        ComputerTrigger1 = true,
        ComputerTrigger2 = true,
        ComputerTrigger3 = true,
        ExitDoorTrigger = true,
        PodTrigger = true
    }

    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and partNames[part.Name] then
            -- Keep the X and Z size, but change the Y size
            local currentSize = part.Size
            part.Size = Vector3.new(currentSize.X, 300, currentSize.Z)
        end
    end

    warn("🪐 [ EGE ] Trigger Part hitboxes are successfully extended.")
end


local function interact()
    game.ReplicatedStorage.RemoteEvent:FireServer("Input", "Action", true)
end

local function hackPC()
    local player = game.Players.LocalPlayer
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local humanoidRootPart = player.Character.HumanoidRootPart

    for _, computerTable in ipairs(workspace:GetDescendants()) do
        if computerTable:IsA("Model") and computerTable.Name == "ComputerTable" then
            local screen = computerTable:FindFirstChild("Screen")
            if screen and screen:IsA("BasePart") and screen.Color ~= Color3.fromRGB(40, 127, 71) then -- Undone PC
                
                local triggers = {"ComputerTrigger1", "ComputerTrigger2", "ComputerTrigger3"}
                for _, triggerName in ipairs(triggers) do
                    local trigger = computerTable:FindFirstChild(triggerName)
                    if trigger and trigger:IsA("BasePart") then
                        warn("🪐 [ EGE ] Successfully teleported to the computer.") -- Debug print
                        
                        -- Move the whole character to the trigger's position
                        humanoidRootPart.CFrame = trigger.CFrame + Vector3.new(0, 3, 0)
                        
                        task.wait(0.5) -- Wait 0.5 seconds before interacting
                        interact() -- Interact with the PC
                        
                        task.wait(0.5) -- Wait another 0.5 seconds after interaction
                        
                        -- Create a baseplate above the player
                        local baseplate = Instance.new("Part")
                        baseplate.Size = Vector3.new(10, 1, 10) -- Small baseplate
                        baseplate.Position = humanoidRootPart.Position + Vector3.new(0, 100, 0) -- 100 studs above
                        baseplate.Anchored = true
                        baseplate.CanCollide = true
                        baseplate.BrickColor = BrickColor.new("Bright blue")
                        baseplate.Parent = workspace

                        -- Move player onto the baseplate
                        humanoidRootPart.CFrame = CFrame.new(baseplate.Position + Vector3.new(0, 3, 0))

                        -- Keep checking the PC status
                        while screen and screen.Color ~= Color3.fromRGB(40, 127, 71) do
                            task.wait(1)
                            
                            -- If the PC errors (turns red), re-interact
                            if screen.Color == Color3.fromRGB(196, 40, 28) then
                                warn("🪐 [ EGE ] Computer Errored, reinteracting...") -- Debug print
                                
                                humanoidRootPart.CFrame = trigger.CFrame + Vector3.new(0, 3, 0) -- Teleport back
                                task.wait(0.5) -- Wait 0.5 seconds before interacting
                                interact() -- Re-interact with the PC
                                
                                task.wait(0.5) -- Wait another 0.5 seconds after interaction
                                humanoidRootPart.CFrame = CFrame.new(baseplate.Position + Vector3.new(0, 3, 0)) -- Return to baseplate
                            end
                        end

                        warn("🪐 [ EGE ] Computer successfully hacked, Waiting 15 seconds before going to the next...") -- Debug print
                        task.wait(15) -- Wait 15 seconds after completion

                        -- Remove the baseplate after the function ends
                        baseplate:Destroy()

                        return
                    end
                end
            end
        end
    end

    warn("🪐 [ EGE ] No Computers are found.") -- Debug print
end

local function hackOnePC()
    local player = game.Players.LocalPlayer
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local humanoidRootPart = player.Character.HumanoidRootPart
    -- Save the original position before teleporting
    local originalPosition = humanoidRootPart.Position

    for _, computerTable in ipairs(workspace:GetDescendants()) do
        if computerTable:IsA("Model") and computerTable.Name == "ComputerTable" then
            local screen = computerTable:FindFirstChild("Screen")
            if screen and screen:IsA("BasePart") and screen.Color ~= Color3.fromRGB(40, 127, 71) then -- Undone PC
                
                local triggers = {"ComputerTrigger1", "ComputerTrigger2", "ComputerTrigger3"}
                for _, triggerName in ipairs(triggers) do
                    local trigger = computerTable:FindFirstChild(triggerName)
                    if trigger and trigger:IsA("BasePart") then
                        warn("🪐 [ EGE ] Successfully teleported to the computer.") -- Debug print
                        
                        -- Move the whole character to the trigger's position
                        humanoidRootPart.CFrame = trigger.CFrame + Vector3.new(0, 3, 0)
                        
                        task.wait(0.5) -- Wait 0.5 seconds before interacting
                        interact() -- Interact with the PC
                        
                        task.wait(0.5) -- Wait another 0.5 seconds after interaction
                        
                        -- Create a baseplate above the player
                        local baseplate = Instance.new("Part")
                        baseplate.Size = Vector3.new(10, 1, 10) -- Small baseplate
                        baseplate.Position = humanoidRootPart.Position + Vector3.new(0, 100, 0) -- 100 studs above
                        baseplate.Anchored = true
                        baseplate.CanCollide = true
                        baseplate.BrickColor = BrickColor.new("Bright blue")
                        baseplate.Parent = workspace

                        -- Move player onto the baseplate
                        humanoidRootPart.CFrame = CFrame.new(baseplate.Position + Vector3.new(0, 3, 0))

                        -- Keep checking the PC status
                        while screen and screen.Color ~= Color3.fromRGB(40, 127, 71) do
                            task.wait(1)
                            
                            -- If the PC errors (turns red), re-interact
                            if screen.Color == Color3.fromRGB(196, 40, 28) then
                                warn("🪐 [ EGE ] Computer Errored, reinteracting...") -- Debug print
                                
                                humanoidRootPart.CFrame = trigger.CFrame + Vector3.new(0, 3, 0) -- Teleport back
                                task.wait(0.5) -- Wait 0.5 seconds before interacting
                                interact() -- Re-interact with the PC
                                
                                task.wait(0.5) -- Wait another 0.5 seconds after interaction
                                humanoidRootPart.CFrame = CFrame.new(baseplate.Position + Vector3.new(0, 3, 0)) -- Return to baseplate
                            end
                        end

                        warn("🪐 [ EGE ] Computer successfully hacked.") -- Debug print

                        -- Teleport back to the original position without waiting for the baseplate removal
                        humanoidRootPart.CFrame = CFrame.new(originalPosition)

                        -- Remove the baseplate after the function ends without waiting
                        baseplate:Destroy()

                        return
                    end
                end
            end
        end
    end

    warn("🪐 [ EGE ] No Computers are found.") -- Debug print
end

local function isTriggerOccupied(triggerPosition)
    local players = game.Players:GetPlayers()
    
    for _, otherPlayer in ipairs(players) do
        if otherPlayer ~= game.Players.LocalPlayer and otherPlayer.Character then
            local otherHRP = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if otherHRP then
                local distance = (otherHRP.Position - triggerPosition).Magnitude
                if distance < 5 then -- If another player is within 5 studs of the trigger
                    return true -- Someone is standing there
                end
            end
        end
    end
    return false -- Safe to teleport
end


local function checkComputersLeftOnce()
    local computersLeft = game.ReplicatedStorage.ComputersLeft.Value
    warn("🪐 [ EGE ] Computers Left: " .. computersLeft)  -- Print the current value

    if computersLeft <= 0 then
        warn("🪐 [ EGE ] All Computers have been hacked.")
    else
        print("")
    end
end

local function exitTask()
    -- Get the player and ensure they have a character
    local player = game.Players.LocalPlayer
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local humanoidRootPart = player.Character.HumanoidRootPart

    -- Find the ExitDoor model and its parts
    for _, exitDoor in ipairs(workspace:GetDescendants()) do
        if exitDoor:IsA("Model") and exitDoor.Name == "ExitDoor" then
            local exitDoorTrigger = exitDoor:FindFirstChild("ExitDoorTrigger")
            local exitArea = exitDoor:FindFirstChild("ExitArea")

            if exitDoorTrigger and exitArea then
                -- Teleport the player 40 studs above the ExitDoorTrigger
                humanoidRootPart.CFrame = exitDoorTrigger.CFrame + Vector3.new(0, 40, 0)

                -- Create a small baseplate for the player to stand on
                local baseplate = Instance.new("Part")
                baseplate.Size = Vector3.new(10, 1, 10)  -- Small baseplate
                baseplate.Position = humanoidRootPart.Position + Vector3.new(0, 20, 0)  -- Position it 40 studs above the trigger
                baseplate.Anchored = true
                baseplate.CanCollide = true
                baseplate.BrickColor = BrickColor.new("Bright blue")
                baseplate.Parent = workspace

                -- Teleport player onto the baseplate
                humanoidRootPart.CFrame = CFrame.new(baseplate.Position + Vector3.new(0, 3, 0))
                wait(0.5)
                -- Interact with the trigger
                interact()
                -- Wait until the ExitDoorTrigger disappears
                repeat
                    wait(0.5)  -- Check every 0.5 seconds
                until not exitDoorTrigger.Parent  -- Check if the ExitDoorTrigger has been removed from the game

                -- Once the ExitDoorTrigger disappears, teleport to the ExitArea
                humanoidRootPart.CFrame = exitArea.CFrame  -- Teleport to ExitArea part

                -- Optionally, remove the baseplate after finishing the teleportation
                baseplate:Destroy()

                warn("🪐 [ EGE ] Successfully escaped.")
                return
            end
        end
    end

    warn("🪐 [ EGE ] Couldnt find the exit door.")
end

local function autoFarmFTF()
    -- Step 1: Resize triggers and check the computers left
    resizeTriggers()
    checkComputersLeftOnce()

    -- Step 2: If there are computers left, start hacking
    while game.ReplicatedStorage.ComputersLeft.Value > 0 do
        hackPC() -- Hack a PC
        checkComputersLeftOnce() -- Check computers again after each hack
    end

    -- Step 3: Once all computers are hacked, exit
    exitTask()
end

local function checkAndSavePlayer()
    -- Get reference to LocalPlayer
    local localPlayer = game.Players.LocalPlayer
    
    -- Flag to track if someone is captured
    local capturedFound = false

    -- Variable to store the LocalPlayer's position before teleporting
    local originalPosition = localPlayer.Character.HumanoidRootPart.Position

    -- Loop through every player in the game
    for _, player in pairs(game.Players:GetPlayers()) do
        -- Check if the player has TempPlayerStatsModule and Captured value
        if player:FindFirstChild("TempPlayerStatsModule") and player.TempPlayerStatsModule:FindFirstChild("Captured") then
            -- Check if the Captured value is true for this player
            if player.TempPlayerStatsModule.Captured.Value == true then
                capturedFound = true

                -- Save the local player position before teleporting
                originalPosition = localPlayer.Character.HumanoidRootPart.Position
                
                -- Get the captured player's CFrame and move 100 studs above it
                local newCFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 100, 0)
                
                -- Create and anchor a small baseplate at the new position (100 studs above the captured player)
                local baseplate = Instance.new("Part")
                baseplate.Size = Vector3.new(10, 1, 10)  -- Small baseplate size
                baseplate.Position = newCFrame.Position  -- Position it 100 studs above the captured player
                baseplate.Anchored = true  -- Anchor the baseplate to prevent falling
                baseplate.Parent = workspace  -- Add the baseplate to the workspace
                
                -- Teleport the local player to the position of the baseplate, but slightly above it
                localPlayer.Character:SetPrimaryPartCFrame(newCFrame * CFrame.new(0, 3, 0))  -- Adjust Y position by 1.5 studs to ensure player is on top of the baseplate
                wait(0.1)

                -- Call the interact() function (make sure interact function is defined elsewhere)
                interact()
                wait(0.1)

                -- Return to the original position
                localPlayer.Character:SetPrimaryPartCFrame(CFrame.new(originalPosition))
                
                -- Remove the baseplate after the interaction is done
                baseplate:Destroy()

                -- Print message
                print("Captured player has been saved.")
                break  -- Exit the loop once we found and interacted with a captured player
            end
        end
    end
end


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

_G.ws1 = false

function ws1()
    while _G.ws1 do
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 30
        end
        wait(0.1) -- Updates every 0.1 seconds
    end
    -- When the loop stops, reset WalkSpeed to 16
    local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16
    end
end


local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "★ Legacy | Flee The Facility",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "★ Legacy | For Peak Quality",
    LoadingSubtitle = "by Ege",
    Theme = "Light", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "Big Hub"
    },
 
    Discord = {
       Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
       Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
 
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
       FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })


 -- Main Tab
local Main = Window:CreateTab("● Main", 170940873)

local Section = Main:CreateSection("Information")
local Paragraph = Main:CreateParagraph({Title = "Message from Ege:", Content = "Hi, Legacy is a script that contains a bunch of other scripts for most of the games on Roblox and it also has bunch of extra universal stuff in it."})
local Paragraph = Main:CreateParagraph({Title = "What is Legacy for?", Content = "Its mainly for easy access to everything. I created a single script that contains bunch of scripts and features to easily access them from a single script and before you ask, yes I skidded a bunch of stuff to put in here and easily access them. I guess you can call me a loser but yeah, I hope you enjoy it."})
local Paragraph = Main:CreateParagraph({Title = "About Script Hub Scripts:", Content = "None of the scripts in the script hub belongs to me and they all are open source scripts meaning you can find them in the internet by doing enough research."})
local Paragraph = Main:CreateParagraph({Title = "Important Note from Ege:", Content = "I do not claim any responsibility if anything happens to your Roblox account. Use it at your own risk."})
local Paragraph = Main:CreateParagraph({Title = "Update Information", Content = "Legacy was discontinued in 2024 but in recent days I wanted to update it and change everything in it. You are currently using Legacy [ 2025 Version ] and trust me it is optimized even more compared to the older version."})

local Section = Main:CreateSection("Miscellaneous")

local Button = Main:CreateButton({
    Name = "Re-Execute Legacy",
    Callback = function()
        Rayfield:Destroy()
        wait(0.1)
        loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Loader.lua'))()
    end,
 })

 
 local player = Window:CreateTab("● Player", 12823489098) -- Title, Image
 local Section = player:CreateSection("Features")
 local Button = player:CreateButton({
    Name = "Fly [ X ]",
    Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Essentials/Fly.lua'))()
    end,
 })

 local Button = player:CreateButton({
    Name = "NoClip [ Z ]",
    Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Essentials/NoClip.lua'))()
    end,
 })

 local Button = player:CreateButton({
    Name = "Hide Mode [ V ]",
    Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Scripts/FTFHideMode.lua'))()
    end,
 })

 local Button = player:CreateButton({
    Name = "Click Teleport [ CTRL + LCLICK ]",
    Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Essentials/ClickTP.lua'))()
    end,
 })

 local Button = player:CreateButton({
    Name = "Infinite Jump",
    Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Essentials/Infinite%20Jump.lua'))()
    end,
 })

 local Toggle = player:CreateToggle({
    Name = "Sprinting Mode",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        _G.ws1 = Value
        if Value then
            spawn(ws1) -- Runs the function in a separate thread
        end
    end
})

local Section = player:CreateSection("Extras")

local Button = player:CreateButton({
    Name = "Hop Servers",
    Callback = function()
        local Http = game:GetService("HttpService") local TPS = game:GetService("TeleportService") local Api = "https://games.roblox.com/v1/games/" local _place = game.PlaceId local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100" function ListServers(cursor) local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or "")) return Http:JSONDecode(Raw) end local Server, Next; repeat local Servers = ListServers(Next) Server = Servers.data[1] Next = Servers.nextPageCursor until Server TPS:TeleportToPlaceInstance(_place,Server.id,game.Players.LocalPlayer)
    end,
 })

 local visual = Window:CreateTab("● Visuals", 13321848320) -- Title, Image
 local Section = visual:CreateSection("ESP")
 local Toggle = visual:CreateToggle({
    Name = "Box ESP [ EVERYONE ]",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        _G.BoxESP2 = Value
    end,
 })

 local Toggle = visual:CreateToggle({
    Name = "Chams ESP [ EVERYONE ]",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
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
    end,
 })

 local Toggle = visual:CreateToggle({
    Name = "Username ESP [ EVERYONE ]",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
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
    end,
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

local Toggle = visual:CreateToggle({
    Name = "Tracers [ EVERYONE ]",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        toggleStateEveryone = Value
        toggleStateEnemy = false -- Disable enemy-only mode if all-players toggle is active
        if Value then
            -- Update tracers for all players
            updateTracers()
        else
            clearAllTracers() -- Clear tracers if toggle is turned off
        end
    end,
 })

 local ftf1 = Window:CreateTab("● Flee The Facility", 78105527764905) -- Title, Image

local RunService = game:GetService("RunService")

-- Function to smoothly change highlight color
local function updateHighlightColor(highlight)
    local hue = 0
    local speed = 1  -- Adjust speed if needed

    local connection
    connection = RunService.Heartbeat:Connect(function(deltaTime)
        hue = (hue + deltaTime * speed) % 1  -- Cycle hue smoothly
        local color = Color3.fromHSV(hue, 1, 1)  -- Convert HSV to RGB
        highlight.FillColor = color
    end)

    return connection
end

 -- Function to add highlight effect
local function addHighlightToComputerTables()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            if obj.Name == "ComputerTable" then
                if not obj:FindFirstChild("Highlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = obj
                    updateHighlightColor(highlight)  -- Start color transition
                end
            end
        end
    end
end

 local Section = ftf1:CreateSection("Computer Features")

 local Button = ftf1:CreateButton({
    Name = "Computer ESP",
    Callback = function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("Part") then
                if obj.Name == "ComputerTable" then
                    if not obj:FindFirstChild("Highlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = obj
                        updateHighlightColor(highlight)  -- Start color transition
                    end
                end
            end
        end
        print("Highlight added to all ComputerTable objects!")
    end,
})

local lastTeleported = nil  -- Stores the last teleported computer

-- Function to recursively search for all ComputerTable models anywhere in the workspace
local function findAllComputerTables()
    local computerTables = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "ComputerTable" and obj:IsA("Model") then
            table.insert(computerTables, obj)  -- Add the ComputerTable model to the list
        end
    end
    return computerTables
end

local function teleportToRandomComputer()
    local computerTables = findAllComputerTables()  -- Find all ComputerTable groups
    if #computerTables == 0 then
        print("No ComputerTable found in workspace.")
        return
    end

    print("Found " .. #computerTables .. " ComputerTables in workspace.")
    local validComputers = {}

    -- Iterate through all the ComputerTable models
    for _, computerGroup in pairs(computerTables) do
        local screen = computerGroup:FindFirstChild("Screen")  -- Find the "Screen" part in the ComputerTable group
        local trigger = computerGroup:FindFirstChild("ComputerTrigger1")  -- Find the "ComputerTrigger1" part in the ComputerTable group

        -- Check if both Screen and ComputerTrigger1 parts exist and are valid BaseParts
        if screen and trigger and screen:IsA("BasePart") and trigger:IsA("BasePart") then
            print("Found Screen and ComputerTrigger1 for: " .. computerGroup.Name)
            
            -- Check if the screen color is not (40, 127, 71) and it's not the same computer as the last one
            if screen.Color ~= Color3.fromRGB(40, 127, 71) and computerGroup ~= lastTeleported then
                print("Valid computer for teleportation: " .. computerGroup.Name)
                table.insert(validComputers, trigger)  -- Add to valid list
            else
                print("Skipped computer: " .. computerGroup.Name .. " (color is (40, 127, 71) or last teleported)")
            end
        else
            print("Missing Screen or ComputerTrigger1 in: " .. computerGroup.Name)
        end
    end

    -- If there are valid computers to teleport to
    if #validComputers > 0 then
        local randomIndex = math.random(1, #validComputers)
        local chosenTrigger = validComputers[randomIndex]
        print("Teleporting to: " .. chosenTrigger.Parent.Name)

        -- Ensure the player exists and has a Character with HumanoidRootPart
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Teleport the player to the chosen ComputerTrigger1's position (CFrame)
            player.Character.HumanoidRootPart.CFrame = chosenTrigger.CFrame  -- Correctly teleport to CFrame of ComputerTrigger1
            lastTeleported = chosenTrigger.Parent  -- Store last teleported computer
            print("Teleport successful!")
        else
            print("Player or HumanoidRootPart not found.")
        end
    else
        print("No valid computers found for teleportation.")
    end
end

-- Create the button with the function
local Button = ftf1:CreateButton({
    Name = "Teleport to PC",
    Callback = teleportToRandomComputer
})

local Button = ftf1:CreateButton({
    Name = "Silent Hacking [ DON'T MOVE ]",
    Callback = function()
        resizeTriggers()
        wait(0.01)
        hackOnePC()
    end,
 })

local previousWaypoint = nil  -- Stores the last placed waypoint

local function placeWaypoint()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Remove the previous waypoint if it exists
        if previousWaypoint then
            previousWaypoint:Destroy()
        end

        -- Create a new waypoint stick
        local waypoint = Instance.new("Part")
        waypoint.Size = Vector3.new(1, 10, 1)  -- Long stick
        waypoint.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)  -- Position above the player
        waypoint.Anchored = true
        waypoint.CanCollide = false
        waypoint.BrickColor = BrickColor.new("Bright green")  -- Green color
        waypoint.Material = Enum.Material.SmoothPlastic
        waypoint.Parent = workspace

        -- Add a highlight effect
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(0, 255, 0)  -- Green highlight
        highlight.OutlineTransparency = 0
        highlight.Parent = waypoint

        -- Store the new waypoint
        previousWaypoint = waypoint
    else
        print("Player or HumanoidRootPart not found.")
    end
end

 local Section = ftf1:CreateSection("Extras")


local Button = ftf1:CreateButton({
    Name = "Auto Finish Round [ BETA ]",
    Callback = function()
        autoFarmFTF()
    end,
 })

 local Button = ftf1:CreateButton({
    Name = "Silent Exit [ DON'T MOVE ] [ ONLY USE WHEN NO COMPUTERS ARE LEFT! ]",
    Callback = function()
        resizeTriggers()
        wait(0.01)
        exitTask()
    end,
 })

 local Button = ftf1:CreateButton({
    Name = "Silent Save a Captured Player [ DON'T MOVE ]",
    Callback = function()
        resizeTriggers()
        wait(0.01)
        checkAndSavePlayer()
    end,
 })

 local function teleportUp()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 200, 0)
    end
end

local Button = ftf1:CreateButton({
    Name = "Teleport Above the Map",
    Callback = function()
        teleportUp()
    end,
 })

 -- Create the button
local WaypointButton = ftf1:CreateButton({
    Name = "Set Waypoint",
    Callback = placeWaypoint
})

local UserInputService = game:GetService("UserInputService")

local Label = ftf1:CreateLabel("Never Fail Hacking is built inside the script itself.", 4728059490, Color3.fromRGB(255, 255, 255), false) -- Title, Icon, Color, IgnoreTheme

local extrass = Window:CreateTab("● Miscellaneous", 6953992690) -- Title, Image

local Section = extrass:CreateSection("Hiding Position")

 local Button = extrass:CreateButton({
    Name = "Save Hiding Position",
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
    end-- The function that takes place when the button is pressed
    end,
 })

 local Button = extrass:CreateButton({
    Name = "Load Hiding Position",
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
    end-- The function that takes place when the button is pressed
    end,
 })

 local Section = extrass:CreateSection("Computer Position")

 local Button = extrass:CreateButton({
    Name = "Save Computer Position",
    Callback = function()
    -- Get the LocalPlayer and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        -- Save the current CFrame of the HumanoidRootPart
        savedPosition2 = humanoidRootPart.CFrame
        print("Position saved!")
    else
        print("HumanoidRootPart not found!")
    end-- The function that takes place when the button is pressed
    end,
 })

 
 local Button = extrass:CreateButton({
    Name = "Load Computer Position",
    Callback = function()
    -- Check if a saved position exists
    if savedPosition2 then
        -- Get the LocalPlayer and its HumanoidRootPart
        local player = game.Players.LocalPlayer
        local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoidRootPart then
            -- Teleport the player to the saved position
            humanoidRootPart.CFrame = savedPosition2
            print("Teleported to saved position!")
        else
            print("HumanoidRootPart not found!")
        end
    else
        print("No saved position to teleport to!")
    end-- The function that takes place when the button is pressed
    end,
 })


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

-- Update tracers every frame
RunService.RenderStepped:Connect(updateTracers)
