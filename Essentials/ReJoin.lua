local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Function to teleport the player to the same game
local function rejoinGame()
    -- Get the current place ID
    local currentPlaceId = game.PlaceId
    
    -- Teleport the player to the same place (same game)
    TeleportService:Teleport(currentPlaceId, player)
end

-- Call the rejoin function (you can call this based on a specific event or condition)
rejoinGame()
