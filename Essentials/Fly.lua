local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local FLYING = false
local flySpeed = 150  -- Adjust this value for desired fly speed
local flyKey = Enum.KeyCode.X  -- Key to toggle flying

local function getRoot(character)
	return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
end

local function startFly()
	FLYING = true
	local character = LocalPlayer.Character
	local root = getRoot(character)
	if not root then return end

	local bodyGyro = Instance.new("BodyGyro")
	local bodyVelocity = Instance.new("BodyVelocity")
	
	bodyGyro.P = 9e4
	bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	bodyGyro.cframe = root.CFrame
	bodyGyro.Parent = root

	bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
	bodyVelocity.velocity = Vector3.new(0, 0, 0)
	bodyVelocity.Parent = root

	character.Humanoid.PlatformStand = true

	-- Movement loop
	local connection
	connection = game:GetService("RunService").Heartbeat:Connect(function()
		if not FLYING then
			bodyGyro:Destroy()
			bodyVelocity:Destroy()
			connection:Disconnect()
			character.Humanoid.PlatformStand = false
			return
		end

		-- Control movement
		local direction = Vector3.new()
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + workspace.CurrentCamera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - workspace.CurrentCamera.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - workspace.CurrentCamera.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + workspace.CurrentCamera.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.E) then direction = direction + Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.Q) then direction = direction - Vector3.new(0, 1, 0) end

		bodyVelocity.velocity = direction * flySpeed
		bodyGyro.cframe = workspace.CurrentCamera.CFrame
	end)
end

local function stopFly()
	FLYING = false
end

-- Toggle flying when X key is pressed
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == flyKey then
		if FLYING then
			stopFly()
		else
			startFly()
		end
	end
end)
