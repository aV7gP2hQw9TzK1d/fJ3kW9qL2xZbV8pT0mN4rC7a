-- Casino: -248.381103515625, 2000, -4664.0244140625
-- Gun Store [ CRATER CITY ]: -354.9327697753906, 2000, -5675.8955078125
-- Bank [ CRATER CITY ]: -644.6334838867188, 2000, -6073.3935546875
-- Mansion: 3003.84033203125, 2000, -4608.66845703125
-- Volcano Base [ FRONT ]: 2286.79931640625, 2000, -2065.772216796875
-- Volcano Base [ BEHIND ]: 2057.266357421875, 2000, -3167.781494140625
-- Jewelry Store: 85.09757995605469, 2000, 1312.5462646484375
-- Criminal Base: -232.2403564453125, 2000, 1176.173583984375
-- Power Plant: 67.42196655273438, 2000, 2341.923095703125
-- Cargo Plane: -1326.8094482421875, 2000, 2953.6162109375
-- Gas Station: -1623.4390869140625, 2000, 692.7808227539062
-- Bank [ CITY ]: -1.5456242561340332, 2000, 865.1112060546875
-- Gun Store [ CITY ]: 383.1368408203125, 2000, 534.015869140625
-- Museum: 1130.9072265625, 2000, 1358.3173828125
-- Donut Store: 90.20208740234375, 2000, -1509.538330078125
-- Gun Store [ TOWN ]: 3.102001190185547, 2000, -1766.8046875
-- Oil Rig: -2787.451904296875, 134.53829956054688, -4006.870361328125

-- Locations
local Casino = Vector3.new(-248.381103515625, 2000, -4664.0244140625)
local GunStoreCrater = Vector3.new(-354.9327697753906, 2000, -5675.8955078125)
local BankCrater = Vector3.new(-644.6334838867188, 2000, -6073.3935546875)
local Mansion = Vector3.new(3003.84033203125, 2000, -4608.66845703125)
local VBaseFront = Vector3.new(2286.79931640625, 2000, -2065.772216796875)
local VBaseBehind = Vector3.new(2057.266357421875, 2000, -3167.781494140625)
local JewelryS = Vector3.new(85.09757995605469, 2000, 1312.5462646484375)
local CrimBase = Vector3.new(-244.98495483398438, 2000, 1615.80419921875)
local PPlant = Vector3.new(67.42196655273438, 2000, 2341.923095703125)
local CPlane = Vector3.new(-1326.8094482421875, 2000, 2953.6162109375)
local GStation = Vector3.new(-1623.4390869140625, 2000, 692.7808227539062)
local BankCity = Vector3.new(-1.5456242561340332, 2000, 865.1112060546875)
local GunStoreCity = Vector3.new(383.1368408203125, 2000, 534.015869140625)
local Museum = Vector3.new(1130.9072265625, 2000, 1358.3173828125)
local DonutStore = Vector3.new(90.20208740234375, 2000, -1509.538330078125)
local GunStoreTown = Vector3.new(3.102001190185547, 2000, -1766.8046875)
local HidingSpot = Vector3.new(2091.934814453125, 2000, 906.0448608398438)
local OilRig = Vector3.new(-2787.451904296875, 2000, -4006.870361328125)

-- Things
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

repeat task.wait() until hrp and humanoid

local function getGroundPosition(origin, ignoreList)
    -- Make sure ignoreList only contains valid parts
    local validIgnoreList = {}
    for _, obj in pairs(ignoreList) do
        if obj:IsA("BasePart") then
            table.insert(validIgnoreList, obj)
        end
    end

    local ray = Ray.new(origin, Vector3.new(0, -20000, 0))
    local part, position = Workspace:FindPartOnRayWithIgnoreList(ray, validIgnoreList)
    
    return position
end

local function spawnBaseplateBelow()
    -- Spawn a small baseplate just below the character
    local baseplate = Instance.new("Part")
    baseplate.Size = Vector3.new(4, 1, 4)  -- Small baseplate size
    baseplate.Position = hrp.Position - Vector3.new(0, 2, 0)  -- Position it below the character
    baseplate.Anchored = true
    baseplate.CanCollide = true
    baseplate.Parent = Workspace

    -- Return baseplate so it can be removed later
    return baseplate
end

local function getIgnoreList(radius)
    -- Get all parts within 10 studs radius of the character to ignore
    local ignoreList = {}
    local region = Region3.new(hrp.Position - Vector3.new(radius, radius, radius), hrp.Position + Vector3.new(radius, radius, radius))

    local partsInRegion = Workspace:FindPartsInRegion3(region, nil, math.huge)
    for _, part in pairs(partsInRegion) do
        table.insert(ignoreList, part)
    end

    -- Include the character's BaseParts in the ignore list
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            table.insert(ignoreList, part)
        end
    end

    return ignoreList
end

local function flyTo(destination: Vector3, speed: number)
    -- Ascend 2000 studs first
    hrp.CFrame = hrp.CFrame + Vector3.new(0, 2000, 0)
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)

    local connection

    connection = RunService.Heartbeat:Connect(function(dt)
        local currentPos = hrp.Position
        local direction = (destination - currentPos).Unit
        local moveDistance = speed * dt
        local newPos = currentPos + direction * moveDistance
        local distanceToTarget = (destination - currentPos).Magnitude

        if distanceToTarget <= 5 then
            connection:Disconnect()

            -- Snap to final destination
            hrp.CFrame = CFrame.new(destination)

            -- Spawn a baseplate to stand on
            local baseplate = spawnBaseplateBelow()

            hrp.Anchored = true

            -- Wait for 0.5 seconds before checking ground and teleporting
            task.wait(0.5)

            hrp.Anchored = false
            -- Get the ignore list for parts within a 10-stud radius
            local ignoreList = getIgnoreList(10)

            -- Find surface below after standing on baseplate
            -- Ignore parts within the 10-stud radius during ground detection
            local groundPosition = getGroundPosition(destination, ignoreList)

            -- Check if the detected ground is between Y values of 900 and 1100, and if so, look for lower ground
            if groundPosition and groundPosition.Y >= 1990 and groundPosition.Y <= 2100 then
                -- If the detected ground is in that range, continue searching for a lower ground
                print("Detected ground is between 1990 and 2100, searching for lower ground.")
                groundPosition = getGroundPosition(destination - Vector3.new(0, 10, 0), ignoreList)
            end

            if groundPosition then
                -- Print the detected ground position
                print("Detected ground position: " .. tostring(groundPosition))

                -- Remove baseplate before teleporting
                baseplate:Destroy()

                -- Move character 4 studs above the surface
                hrp.CFrame = CFrame.new(groundPosition + Vector3.new(0, 4, 0))
            else
                warn("No surface found below destination.")
            end

            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            return
        end

        -- Keep flying
        hrp.CFrame = CFrame.new(newPos)
        hrp.Velocity = Vector3.zero
        hrp.RotVelocity = Vector3.zero
    end)
end

local function flyToRig(destination: Vector3, speed: number)
    -- Ascend 2000 studs first
    hrp.CFrame = hrp.CFrame + Vector3.new(0, 2000, 0)
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)

    local connection

    connection = RunService.Heartbeat:Connect(function(dt)
        local currentPos = hrp.Position
        local direction = (destination - currentPos).Unit
        local moveDistance = speed * dt
        local newPos = currentPos + direction * moveDistance
        local distanceToTarget = (destination - currentPos).Magnitude

        if distanceToTarget <= 5 then
            connection:Disconnect()

            -- Snap to final destination
            hrp.CFrame = CFrame.new(destination)

            -- Spawn a baseplate to stand on
            local baseplate = spawnBaseplateBelow()

            hrp.Anchored = true

            -- Wait for 0.5 seconds before checking ground and teleporting
            task.wait(0.5)

            hrp.Anchored = false
            
            baseplate:Destroy()

			hrp.CFrame = CFrame.new(-2787.451904296875, 136, -4006.870361328125)

            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            return
        end

        -- Keep flying
        hrp.CFrame = CFrame.new(newPos)
        hrp.Velocity = Vector3.zero
        hrp.RotVelocity = Vector3.zero
    end)
end

local baseplateSize = Vector3.new(30, 1, 30)  -- Size of the baseplate
local baseplatePosition = Vector3.new(2091.934814453125, 1980, 906.0448608398438)  -- Target coordinates

-- Create the baseplate
local baseplate = Instance.new("Part")
baseplate.Size = baseplateSize
baseplate.Position = baseplatePosition
baseplate.Anchored = true  -- Make sure the baseplate doesn't fall
baseplate.Color = Color3.fromRGB(255, 255, 255)  -- Set the baseplate color to white (optional)
baseplate.Name = "EgeOnTop"  -- Name the part (optional)
baseplate.Parent = game.Workspace  -- Parent it to the Workspace so it appears in the game
baseplate.Transparency = 0.75

local speed = 200

local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(char) character = char end)

local noclipEnabled = false
local highlightEnabled = false
local resizeEnabled = false
local walkspeedEnabled = false
local currentTeam = player.Team
local partsToNoclip = {"UpperTorso", "LowerTorso", "HumanoidRootPart"}

-- Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/memejames/elerium-v2-ui-library//main/Library", true))()

-- Window
local window = library:AddWindow("★ Legacy | Jailbreak", {
	main_color = Color3.fromRGB(65 ,65, 65), -- Color
	min_size = Vector2.new(433, 365), --A Size of the gui
	can_resize = false, -- true or false
})


local Player = window:AddTab("Player") -- Name of tab
Player:Show() -- shows the tab

Player:AddLabel("Features")

-- NoClip logic
local function setNoclipState(state)
	for _, partName in ipairs(partsToNoclip) do
		local part = character:FindFirstChild(partName)
		if part and part:IsA("BasePart") then
			part.CanCollide = state
		end
	end
end

RunService.Stepped:Connect(function()
	if noclipEnabled then
		setNoclipState(false)
	end
end)

Player:AddSwitch("NoClip", function(bool)
	noclipEnabled = bool
	if not bool then
		setNoclipState(true)
	end
end):Set(false)

-- WalkSpeed Lock
local walkspeedSwitch = nil
walkspeedSwitch = Player:AddSwitch("Flash Mode", function(state)
	local hum = character:FindFirstChildWhichIsA("Humanoid")
	if not hum then return end

	if state then
		walkspeedLocked = true
		hum.WalkSpeed = 100
		if walkspeedConnection then walkspeedConnection:Disconnect() end
		walkspeedConnection = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			if walkspeedLocked and hum.WalkSpeed ~= 100 then
				hum.WalkSpeed = 100
			end
		end)
	else
		walkspeedLocked = false
		if walkspeedConnection then
			walkspeedConnection:Disconnect()
			walkspeedConnection = nil
		end
		hum.WalkSpeed = 16
	end
end)


-- ESP Highlight & Billboard logic
local function addHighlight(target, color)
	if target and not target:FindFirstChild("Highlight") then
		local hl = Instance.new("Highlight")
		hl.Name = "Highlight"
		hl.FillColor = color
		hl.OutlineColor = Color3.new(1, 1, 1)
		hl.OutlineTransparency = 0
		hl.Parent = target
	end
end

local function addBillboard(target, name, highlightColor)
	if not target:FindFirstChild("DisplayNameBillboard") then
		local head = target:FindFirstChild("Head")
		if head then
			local billboard = Instance.new("BillboardGui")
			billboard.Name = "DisplayNameBillboard"
			billboard.Size = UDim2.new(0, 150, 0, 32)
			billboard.StudsOffset = Vector3.new(0, 3, 0)
			billboard.AlwaysOnTop = true
			billboard.Adornee = head
			billboard.Parent = target

			local textLabel = Instance.new("TextLabel")
			textLabel.Size = UDim2.new(1, 0, 1, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.TextColor3 = highlightColor
			textLabel.TextStrokeTransparency = 0.5
			textLabel.Text = name
			textLabel.Font = Enum.Font.SourceSansBold
			textLabel.TextScaled = true
			textLabel.Parent = billboard
		end
	end
end

local function removeAllHighlightsAndBillboards()
	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= player then
			local char = otherPlayer.Character
			if char then
				local hl = char:FindFirstChild("Highlight")
				if hl then
					hl:Destroy()
				end
				local bb = char:FindFirstChild("DisplayNameBillboard")
				if bb then
					bb:Destroy()
				end
			end
		end
	end
end

local function resetEnemyHumanoidRootParts()
	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= player then
			local char = otherPlayer.Character
			if char then
				local hrp = char:FindFirstChild("HumanoidRootPart")
				if hrp then
					hrp.Size = Vector3.new(2, 2, 2)
				end
			end
		end
	end
end

local function updateEnemyVisuals()
	local myTeam = player.Team
	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Team and otherPlayer.Team ~= myTeam then
			if otherPlayer.Team.Name ~= "Prisoner" then
				local char = otherPlayer.Character
				if char then
					if highlightEnabled then
						addHighlight(char, otherPlayer.Team.TeamColor.Color)
						addBillboard(char, otherPlayer.DisplayName, otherPlayer.Team.TeamColor.Color)
					end
					if resizeEnabled then
						local hrp = char:FindFirstChild("HumanoidRootPart")
						if hrp then
							hrp.Size = Vector3.new(12, 12, 12)
						end
					end
				end
			end
		end
	end
end

RunService.Heartbeat:Connect(function()
	if highlightEnabled or resizeEnabled then
		if player.Team ~= currentTeam then
			currentTeam = player.Team
			removeAllHighlightsAndBillboards()
			resetEnemyHumanoidRootParts()
		end
		updateEnemyVisuals()
	end
end)

Player:AddSwitch("ESP", function(bool)
	highlightEnabled = bool
	currentTeam = player.Team
	if not bool then
		removeAllHighlightsAndBillboards()
	end
end)

Player:AddSwitch("Extend Hitboxes", function(bool)
	resizeEnabled = bool
	currentTeam = player.Team
	if not bool then
		resetEnemyHumanoidRootParts()
	end
end)

local AR = window:AddTab("Spy Arrest")
AR:Show()

AR:AddLabel("Target Username")

local targetPlayerName = ""

AR:AddTextBox("Input Target's Username or Display Name", function(text)
	targetPlayerName = text
end)

-- Load Map Function
if not _G.MapLoadedChecker then
    _G.MapLoadedChecker = false
end

function LoadMap()
    if not _G.MapLoadedChecker then
        _G.MapLoadedChecker = true
        wait(0.1)
        loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Scripts/JBMapLoader.lua'))()
    else
        print("Map already loaded.")
    end
end

-- LocalScript in StarterPlayerScripts

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Target CFrame
local lockedCFrame = CFrame.new(
    732.684265, 40.1631851, 1104.86279,
    0.381594092, -0.081174925, -0.920758724,
    0, 0.996136427, -0.0878202766,
    0.924330115, 0.0335116982, 0.380119652
)

local isLocked = false
local originalCFrame = nil
local connection = nil

local function toggleCamera()
	if not isLocked then
		-- Save original CFrame and lock to the target
		originalCFrame = camera.CFrame
		isLocked = true
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = lockedCFrame

		-- Keep camera locked every frame
		connection = RunService.RenderStepped:Connect(function()
			camera.CFrame = lockedCFrame
		end)
	else
		-- Unlock and revert to original camera
		isLocked = false
		camera.CameraType = Enum.CameraType.Custom
		if connection then
			connection:Disconnect()
			connection = nil
		end
		if originalCFrame then
			camera.CFrame = originalCFrame
		end
	end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.F1 then
		toggleCamera()
	end
end)

AR:AddButton("Travel to Target", function()
	if targetPlayerName == "" then
		warn("Target username not set!")
		return
	end

	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")

	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	local humanoid = character:WaitForChild("Humanoid")
	local camera = workspace.CurrentCamera

	-- Find target player
	local targetPlayer = nil
	for _, plr in pairs(Players:GetPlayers()) do
		if string.lower(plr.Name):sub(1, #targetPlayerName) == string.lower(targetPlayerName)
			or string.lower(plr.DisplayName):sub(1, #targetPlayerName) == string.lower(targetPlayerName) then
			targetPlayer = plr
			break
		end
	end

	if not targetPlayer then
		warn("Target player not found!")
		return
	end

	local targetHRP = targetPlayer.Character and targetPlayer.Character:WaitForChild("HumanoidRootPart")
	if not targetHRP then
		warn("Target HRP not found!")
		return
	end

	local SPEED = 185
	local followingAbove = false
	local groundFollowStarted = false
	local fallProtection = true

	-- Initial teleport up
	humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, 2000, 0)

	-- Fall protection
	task.spawn(function()
		while fallProtection do
			humanoid.PlatformStand = true
			humanoidRootPart.Velocity = Vector3.zero
			RunService.Heartbeat:Wait()
		end
	end)

	-- Travel horizontally toward target (XZ only)
	task.spawn(function()
		local reachedDestination = false
		while not reachedDestination do
			local targetXZ = Vector3.new(targetHRP.Position.X, humanoidRootPart.Position.Y, targetHRP.Position.Z)
			local direction = targetXZ - humanoidRootPart.Position
			local distance = direction.Magnitude

			if distance < 5 then
				reachedDestination = true
				break
			end

			local delta = RunService.Heartbeat:Wait()
			local step = math.min(SPEED * delta, distance)
			humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position + direction.Unit * step)
		end

		-- Follow above target
		camera.CameraSubject = targetPlayer.Character:WaitForChild("Head")
		camera.CameraType = Enum.CameraType.Attach
		followingAbove = true

		task.spawn(function()
			while followingAbove do
				local targetPos = targetHRP.Position + Vector3.new(0, 2000, 0)
				local direction = targetPos - humanoidRootPart.Position
				local distance = direction.Magnitude
				local delta = RunService.Heartbeat:Wait()

				if distance > 0.1 then
					local step = math.min(SPEED * delta, distance)
					humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position + direction.Unit * step)
				end
			end
		end)
	end)

	-- Switch to ground follow when Y is pressed
	UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe or groundFollowStarted then return end
		if input.KeyCode == Enum.KeyCode.Y then
			followingAbove = false
			fallProtection = false
			groundFollowStarted = true

			humanoid.PlatformStand = false
			camera.CameraSubject = player.Character:WaitForChild("Head")
			camera.CameraType = Enum.CameraType.Custom

			local startPos = targetHRP.Position
			humanoidRootPart.CFrame = CFrame.new(startPos)

			task.spawn(function()
				while true do
					local targetPos = targetHRP.Position
					local direction = targetPos - humanoidRootPart.Position
					local distance = direction.Magnitude
					local delta = RunService.Heartbeat:Wait()

					if distance > 0.1 then
						local step = math.min(SPEED * delta, distance)
						humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position + direction.Unit * step)
					end
				end
			end)
		end
	end)
end)

AR:AddButton("Load Map", function()
    LoadMap()
end)

AR:AddLabel("★ Press [Y] to Teleport to Target after reaching.")
AR:AddLabel("★ Press [ENTER] after typing Target's username.")
AR:AddLabel("★ Press [F1] to view the Bounty Board.")

local RS = window:AddTab("Robberies") -- Name of tab
RS:Show() -- shows the tab

RS:AddLabel("Robbery Teleportations")

RS:AddButton("Jewelry Store",function()
	local JewelryS = Vector3.new(85.09757995605469, 2000, 1312.5462646484375)
	flyTo(JewelryS, speed)
end)

RS:AddButton("Bank [ CITY ]",function()
	local BankCity = Vector3.new(-1.5456242561340332, 2000, 865.1112060546875)
	flyTo(BankCity, speed)
end)

RS:AddButton("Bank [ CRATER CITY ]",function()
	local BankCrater = Vector3.new(-644.6334838867188, 2000, -6073.3935546875)
	flyTo(BankCrater, speed)
end)

RS:AddButton("Casino",function()
	local Casino = Vector3.new(-248.381103515625, 2000, -4664.0244140625)
	flyTo(Casino, speed)
end)

RS:AddButton("Mansion",function()
	local Mansion = Vector3.new(3003.84033203125, 2000, -4608.66845703125)
	flyTo(Mansion, speed)
end)

RS:AddButton("Power Plant",function()
	local PPlant = Vector3.new(67.42196655273438, 2000, 2341.923095703125)
	flyTo(PPlant, speed)
end)

RS:AddButton("Cargo Plane",function()
	local CPlane = Vector3.new(-1326.8094482421875, 2000, 2953.6162109375)
	flyTo(CPlane, speed)
end)

RS:AddButton("Gas Station",function()
	local GStation = Vector3.new(-1623.4390869140625, 2000, 692.7808227539062)
	flyTo(GStation, speed)
end)

RS:AddButton("Donut Store",function()
	local DonutStore = Vector3.new(90.20208740234375, 2000, -1509.538330078125)
	flyTo(DonutStore, speed)
end)

RS:AddButton("Museum",function()
	local Museum = Vector3.new(1130.9072265625, 2000, 1358.3173828125)
	flyTo(Museum, speed)
end)

RS:AddButton("Oil Rig",function()
	local OilRig = Vector3.new(-2787.451904296875, 2000, -4006.870361328125)
	flyToRig(OilRig, speed)
end)

local GS = window:AddTab("Gun Stores") -- Name of tab
GS:Show() -- shows the tab

GS:AddLabel("Gun Store Teleportations")

GS:AddButton("Gun Store [ TOWN ]",function()
	local GunStoreTown = Vector3.new(3.102001190185547, 2000, -1766.8046875)
	flyTo(GunStoreTown, speed)
end)

GS:AddButton("Gun Store [ CRATER CITY ]",function()
	local GunStoreCrater = Vector3.new(-354.9327697753906, 2000, -5675.8955078125)
	flyTo(GunStoreCrater, speed)
end)

GS:AddButton("Gun Store [ CITY ]",function()
	local GunStoreCity = Vector3.new(383.1368408203125, 2000, 534.015869140625)
	flyTo(GunStoreCity, speed)
end)


local LS = window:AddTab("Bases") -- Name of tab
LS:Show() -- shows the tab

LS:AddLabel("Base Teleportations")

LS:AddButton("Volcano Base [ FRONT ]",function()
	local VBaseFront = Vector3.new(2286.79931640625, 2000, -2065.772216796875)
	flyTo(VBaseFront, speed)
end)

LS:AddButton("Volcano Base [ BEHIND ]",function()
	local VBaseBehind = Vector3.new(2057.266357421875, 2000, -3167.781494140625)
	flyTo(VBaseBehind, speed)
end)

LS:AddButton("Criminal Base",function()
	local CrimBase = Vector3.new(-244.98495483398438, 2000, 1615.80419921875)
	flyTo(CrimBase, speed)
end)

LS:AddButton("Hiding Spot",function()
	local HidingSpot = Vector3.new(2091.934814453125, 2000, 906.0448608398438)
	flyTo(HidingSpot, speed)
end)

-- Main Tab
local Settings = window:AddTab("Settings") -- Name of tab
Settings:Show() -- shows the tab

Settings:AddLabel("★ Use a vehicle for 200+ Travel Speed!")

local slider = Settings:AddSlider("Travel Speed", function(psps)
    speed = psps  -- Update the speed variable with the value from the slider
end, {
    ["min"] = 200,  -- Minimum value for speed
    ["max"] = 750,  -- Maximum value for speed
})

slider:Set(0) -- Needed
