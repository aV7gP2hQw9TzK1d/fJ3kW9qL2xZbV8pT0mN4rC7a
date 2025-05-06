local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/memejames/elerium-v2-ui-library//main/Library", true))()

local window = library:AddWindow("★ Legacy | Spy Arrest V1", {
	main_color = Color3.fromRGB(65 ,65, 65),
	min_size = Vector2.new(310, 240),
	can_resize = false,
})

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
