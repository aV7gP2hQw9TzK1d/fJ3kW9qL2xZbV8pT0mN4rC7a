local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local camera = game.Workspace.CurrentCamera

local isAnchored = false
local originalCFrame
local originalCameraPosition

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.V then
        if not isAnchored then
            -- Save original character and camera positions
            originalCFrame = humanoidRootPart.CFrame
            originalCameraPosition = camera.CFrame.Position  -- Only store position

            -- Move character down by 30 studs
            humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -30, 0)
            wait(0.1) -- Small delay

            -- Anchor character
            humanoidRootPart.Anchored = true

            -- Keep camera at the same height but allow movement
            RunService:BindToRenderStep("KeepCameraHeight", Enum.RenderPriority.Camera.Value, function()
                local camCFrame = camera.CFrame
                camera.CFrame = CFrame.new(camCFrame.Position.X, originalCameraPosition.Y, camCFrame.Position.Z) * camCFrame.Rotation
            end)
        else
            -- Unanchor character and move it back
            humanoidRootPart.Anchored = false
            humanoidRootPart.CFrame = originalCFrame

            -- Restore normal camera behavior
            RunService:UnbindFromRenderStep("KeepCameraHeight")
        end
        isAnchored = not isAnchored
    end
end)
