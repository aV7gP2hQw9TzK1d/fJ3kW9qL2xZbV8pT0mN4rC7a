local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer -- Ensure you're in a LocalScript

-- Create the TextLabel that will appear on screen
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0, 1000, 0, 150)  -- Increased height to fit 3 lines
textLabel.Position = UDim2.new(0.5, -500, 0.5, -300)
textLabel.Text = "Legitbreak Criminal Config Loaded!\nCoded by Ege\nShoutout to Vexanair"
textLabel.Font = Enum.Font.GothamBold
textLabel.TextSize = 36
textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Red text color
textLabel.TextStrokeTransparency = 0  -- Black outline
textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)  -- Black stroke color
textLabel.BackgroundTransparency = 1
textLabel.TextTransparency = 1 -- Start invisible
textLabel.TextWrapped = true  -- Allows wrapping of the text
textLabel.Parent = screenGui

-- Function to fade in
local function fadeIn()
    for i = 1, 0, -0.05 do
        textLabel.TextTransparency = i
        wait(0.05)
    end
end

-- Function to fade out
local function fadeOut()
    for i = 0, 1, 0.05 do
        textLabel.TextTransparency = i
        wait(0.05)
    end
end

-- Display the label with fade-in effect
fadeIn() -- Fade in first

wait(4) -- Keep the label on screen for 4 seconds

fadeOut() -- Then fade out the label after 4 seconds

-- Destroy the TextLabel after fading out
textLabel:Destroy()


local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer -- Ensure you're in a LocalScript

-- Create the ScreenGui that will contain the text
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Create the TextLabel
local rainbowLabel = Instance.new("TextLabel")
rainbowLabel.Size = UDim2.new(0, 300, 0, 50)  -- Size of the label
rainbowLabel.Position = UDim2.new(0.5, 180, 0, -65)  -- Center top position
rainbowLabel.Text = "Legitbreak | Made by Ege"
rainbowLabel.Font = Enum.Font.GothamBold
rainbowLabel.TextSize = 20
rainbowLabel.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Start with red color
rainbowLabel.TextStrokeTransparency = 0  -- Black outline
rainbowLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)  -- Black stroke color
rainbowLabel.BackgroundTransparency = 1
rainbowLabel.TextTransparency = 0 -- Fully visible
rainbowLabel.Parent = screenGui

-- Function to smoothly change the color of the text
local function changeRainbowColor()
    local time = 0
    while true do
        -- Cycle through the rainbow colors
        local color = Color3.fromHSV(time % 1, 1, 1)  -- Time-based hue cycle
        rainbowLabel.TextColor3 = color  -- Apply the color to the text
        time = time + 0.01  -- Increment the time for smooth color change
        wait(0.1)  -- Small wait for smooth animation
    end
end

spawn(function()
    changeRainbowColor()
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Police ESP",
    Text = "Press X to enable/disable.",
    Duration = 99999
})
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Teleport Behind Doors",
    Text = "Press T to teleport behind doors.",
    Duration = 99999
})
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Police Aimbot",
    Text = "Hold Right Click to lock onto Polices.",
    Duration = 99999
})

-- // SETTINGS
local FOV_RADIUS = 150
local SMOOTHNESS = 10
local ESP_TEAM_NAME = "Police" -- Changed from "Criminal"

-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Teams = game:GetService("Teams")

-- // VARIABLES
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local HoldingRightClick = false
local ESP_Enabled = false
local AddedESP = {}

-- // FOV CIRCLE
local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Visible = true
FOV_Circle.Radius = FOV_RADIUS
FOV_Circle.Thickness = 1
FOV_Circle.Color = Color3.fromRGB(255, 255, 255)
FOV_Circle.Filled = false

-- // Teleport Forward
local function teleportForward()
	local character = LocalPlayer.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local hrp = character.HumanoidRootPart
		local direction = hrp.CFrame.LookVector * 5
		hrp.CFrame = hrp.CFrame + direction
	end
end

-- // Input handling
UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		HoldingRightClick = true
	elseif input.KeyCode == Enum.KeyCode.X then
		ESP_Enabled = not ESP_Enabled
		if not ESP_Enabled then
			for player, data in pairs(AddedESP) do
				if data.Highlight then data.Highlight:Destroy() end
				if data.Billboard then data.Billboard:Destroy() end
			end
			AddedESP = {}
		end
	elseif input.KeyCode == Enum.KeyCode.T then
		teleportForward()
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		HoldingRightClick = false
	end
end)

-- // ESP Functions
local function addESP(player)
	if player == LocalPlayer or AddedESP[player] then return end
	if player.Team and player.Team.Name == ESP_TEAM_NAME then
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			local highlight = Instance.new("Highlight")
			highlight.Adornee = character
			highlight.FillColor = Color3.fromRGB(0, 0, 255) -- Blue
			highlight.OutlineColor = Color3.new(1, 1, 1)
			highlight.FillTransparency = 0.5
			highlight.OutlineTransparency = 0
			highlight.Parent = character

			local billboard = Instance.new("BillboardGui")
			billboard.Size = UDim2.new(0, 100, 0, 20)
			billboard.StudsOffset = Vector3.new(0, 3, 0)
			billboard.AlwaysOnTop = true
			billboard.Adornee = character:FindFirstChild("Head")
			billboard.Parent = character

			local nameLabel = Instance.new("TextLabel")
			nameLabel.Size = UDim2.new(1, 0, 1, 0)
			nameLabel.BackgroundTransparency = 1
			nameLabel.Text = player.DisplayName
			nameLabel.TextColor3 = Color3.new(0, 0, 1) -- Blue
			nameLabel.TextStrokeTransparency = 0.5
			nameLabel.TextScaled = true
			nameLabel.Font = Enum.Font.SourceSansBold
			nameLabel.Parent = billboard

			AddedESP[player] = {
				Highlight = highlight,
				Billboard = billboard
			}
		end
	end
end

local function removeESP(player)
	if AddedESP[player] then
		if AddedESP[player].Highlight then AddedESP[player].Highlight:Destroy() end
		if AddedESP[player].Billboard then AddedESP[player].Billboard:Destroy() end
		AddedESP[player] = nil
	end
end

-- Update ESP when new players join or change teams
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		wait(1)
		if ESP_Enabled then
			addESP(player)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	removeESP(player)
end)

-- Check team changes
for _, player in pairs(Players:GetPlayers()) do
	player:GetPropertyChangedSignal("Team"):Connect(function()
		if ESP_Enabled then
			if player.Team and player.Team.Name == ESP_TEAM_NAME then
				addESP(player)
			else
				removeESP(player)
			end
		end
	end)
end

-- // Utility
local function getClosestTargetInFOV()
    local closestPlayer = nil
    local shortestDistance = FOV_RADIUS

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team and player.Team.Name == "Police" and player.Character and player.Character:FindFirstChild("Head") then
            local headPos = player.Character.Head.Position
            local screenPoint, onScreen = Camera:WorldToViewportPoint(headPos)
            if onScreen then
                local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end


-- // Main loop
RunService.RenderStepped:Connect(function()
	FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

	if HoldingRightClick then
		local target = getClosestTargetInFOV()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			local targetPos = target.Character.Head.Position
			local currentPos = Camera.CFrame.Position

			local lerpAlpha = SMOOTHNESS <= 0 and 1 or (1 / (SMOOTHNESS + 1))
			local newCFrame = CFrame.new(currentPos, currentPos:Lerp(targetPos, lerpAlpha))
			Camera.CFrame = newCFrame
		end
	end

	if ESP_Enabled then
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Team and player.Team.Name == ESP_TEAM_NAME then
				addESP(player)
			else
				removeESP(player)
			end
		end
	end
end)
