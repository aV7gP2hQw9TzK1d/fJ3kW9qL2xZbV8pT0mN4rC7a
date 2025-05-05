local targetPlayerName = "username"
-- Press "Y" to Teleport to the target after reaching it.













































-- Use _G to persist the value across executions
if not _G.MapLoadedChecker then
    _G.MapLoadedChecker = false  -- Initialize the global variable if it doesn't exist
end

function LoadMap()
    if _G.MapLoadedChecker == false then
        _G.MapLoadedChecker = true  -- Set to true after the map is loaded
        wait(0.1)
        loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Scripts/JBMapLoader.lua'))()
    else
        print("Map is already loaded.")
    end
end

LoadMap()


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




local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera

-- Target setup
local targetPlayer = nil
for _, player in pairs(Players:GetPlayers()) do
    -- Check if the player's username or display name matches the targetPlayerName
    if string.lower(player.Name):sub(1, #targetPlayerName) == string.lower(targetPlayerName) or 
       string.lower(player.DisplayName):sub(1, #targetPlayerName) == string.lower(targetPlayerName) then
        targetPlayer = player
        break
    end
end

if not targetPlayer then return warn("Target player not found") end


local targetHRP = targetPlayer.Character and targetPlayer.Character:WaitForChild("HumanoidRootPart")
if not targetHRP then return warn("Target HRP not found") end

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

	-- Start following above target
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

		-- Instantly teleport to ground follow start position
		local startPos = targetHRP.Position + Vector3.new(0, 0, 0)
		humanoidRootPart.CFrame = CFrame.new(startPos)

		-- Begin ground follow
		task.spawn(function()
			while true do
				local targetPos = targetHRP.Position + Vector3.new(0, 0, 0)
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
