-- Define services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- List of target camera locations
local locations = {
    Vector3.new(-248.381103515625, 150, -4664.0244140625),
    Vector3.new(-354.9327697753906, 150, -5675.8955078125),
    Vector3.new(-644.6334838867188, 150, -6073.3935546875),
    Vector3.new(3003.84033203125, 150, -4608.66845703125),
    Vector3.new(2286.79931640625, 150, -2065.772216796875),
    Vector3.new(2057.266357421875, 150, -3167.781494140625),
    Vector3.new(85.09757995605469, 150, 1312.5462646484375),
    Vector3.new(-232.2403564453125, 150, 1176.173583984375),
    Vector3.new(67.42196655273438, 150, 2341.923095703125),
    Vector3.new(-1326.8094482421875, 150, 2953.6162109375),
    Vector3.new(-1623.4390869140625, 150, 692.7808227539062),
    Vector3.new(-1.5456242561340332, 150, 865.1112060546875),
    Vector3.new(383.1368408203125, 150, 534.015869140625),
    Vector3.new(1130.9072265625, 150, 1358.3173828125),
    Vector3.new(90.20208740234375, 150, -1509.538330078125),
    Vector3.new(3.102001190185547, 150, -1766.8046875),
    Vector3.new(-2787.451904296875, 134.53829956054688, -4006.870361328125)
}

-- Create loading screen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Name = "MapLoadingGui"
screenGui.Parent = PlayerGui

-- Fullscreen black background
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.Position = UDim2.new(0, 0, 0, 0)
bg.BackgroundColor3 = Color3.new(0, 0, 0)
bg.BorderSizePixel = 0
bg.Parent = screenGui

-- "Loading map..." label
local loadingLabel = Instance.new("TextLabel")
loadingLabel.Text = "Loading map..."
loadingLabel.TextColor3 = Color3.new(1, 1, 1)
loadingLabel.BackgroundTransparency = 1
loadingLabel.Font = Enum.Font.SourceSansBold
loadingLabel.TextSize = 40
loadingLabel.Position = UDim2.new(0.5, 0, 0.45, 0)
loadingLabel.AnchorPoint = Vector2.new(0.5, 0.5)
loadingLabel.Size = UDim2.new(1, 0, 0, 50)
loadingLabel.Parent = screenGui

-- Estimated time label
local timeLabel = Instance.new("TextLabel")
timeLabel.Text = ""
timeLabel.TextColor3 = Color3.new(1, 1, 1)
timeLabel.BackgroundTransparency = 1
timeLabel.Font = Enum.Font.SourceSansBold
timeLabel.TextSize = 28
timeLabel.Position = UDim2.new(0.5, 0, 0.53, 0)
timeLabel.AnchorPoint = Vector2.new(0.5, 0.5)
timeLabel.Size = UDim2.new(1, 0, 0, 40)
timeLabel.Parent = screenGui

-- Lock camera to script control
local function lockCameraPosition()
	Camera.CameraType = Enum.CameraType.Scriptable
end

-- Unlock camera
local function unlockCameraPosition()
	Camera.CameraType = Enum.CameraType.Custom
end

-- Move camera to each location
local function moveCameraToLocations()
	for i, location in ipairs(locations) do
		lockCameraPosition()

		-- Update estimated time remaining
		local remaining = #locations - i + 1
		local estimatedTime = remaining * 2
		timeLabel.Text = "Time left: " .. estimatedTime .. "s"

		-- Tween camera to location
		local goal = { CFrame = CFrame.new(location) }
		local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
		local tween = TweenService:Create(Camera, tweenInfo, goal)
		tween:Play()
		tween.Completed:Wait()

		wait(2)
		unlockCameraPosition()
	end

	-- Remove GUI after all locations
	screenGui:Destroy()
end

-- Start camera travel
moveCameraToLocations()
