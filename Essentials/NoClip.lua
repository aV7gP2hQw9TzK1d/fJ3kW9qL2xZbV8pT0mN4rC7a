local StealthMode = true
local noclip, player = false, game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local mouse, originalCollideState = player:GetMouse(), {}
local bodyParts = {"LowerTorso", "UpperTorso", "HumanoidRootPart", "Torso"}

local function toggleNoclip()
    noclip = not noclip
    if not StealthMode then Indicator.Text = "Noclip: " .. (noclip and "Enabled" or "Disabled") end
    if noclip then
        for _, partName in pairs(bodyParts) do
            local part = character:FindFirstChild(partName)
            if part then originalCollideState[part] = part.CanCollide part.CanCollide = false end
        end
    else
        for part, state in pairs(originalCollideState) do
            if part and part.Parent then part.CanCollide = state end
        end
    end
end

mouse.KeyDown:Connect(function(key) if key == "z" then toggleNoclip() end end)

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    if noclip then
        for _, partName in pairs(bodyParts) do
            local part = character:FindFirstChild(partName)
            if part then originalCollideState[part] = part.CanCollide part.CanCollide = false end
        end
    end
end)

while true do
    if noclip then
        for _, partName in pairs(bodyParts) do
            local part = character:FindFirstChild(partName)
            if part then part.CanCollide = false end
        end
    end
    game:GetService("RunService").Stepped:wait()
end
