local StealthMode = true 

local Indicator

if not StealthMode then
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    Indicator = Instance.new("TextLabel", ScreenGui)
    Indicator.AnchorPoint = Vector2.new(0, 1)
    Indicator.Position = UDim2.new(0, 0, 1, 0)
    Indicator.Size = UDim2.new(0, 200, 0, 50)
    Indicator.BackgroundTransparency = 1
    Indicator.TextScaled = true
    Indicator.TextStrokeTransparency = 0
    Indicator.TextColor3 = Color3.new(0, 0, 0)
    Indicator.TextStrokeColor3 = Color3.new(1, 1, 1)
    Indicator.Text = "Noclip: Enabled"
end

local noclip = false
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local mouse = player:GetMouse()

-- Function to toggle noclip
local function toggleNoclip()
    noclip = not noclip

    if not StealthMode then
        Indicator.Text = "Noclip: " .. (noclip and "Enabled" or "Disabled")
    end

    -- Apply noclip
    for _, v in pairs(character:GetDescendants()) do
        pcall(function()
            if v:IsA("BasePart") then
                v.CanCollide = not noclip
            end
        end)
    end
end

-- Toggle noclip on pressing the "e" key
mouse.KeyDown:Connect(function(key)
    if key == "z" then
        toggleNoclip()
    end
end)

-- Ensure noclip works after respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    if noclip then
        -- Apply noclip to the new character parts
        for _, v in pairs(character:GetDescendants()) do
            pcall(function()
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end)
        end
    end
end)

-- Continuous check for noclip state
while true do
    if noclip then
        for _, v in pairs(character:GetDescendants()) do
            pcall(function()
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end)
        end
    end
    game:GetService("RunService").Stepped:wait()
end
