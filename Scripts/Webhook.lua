-- Your Discord Webhook URL
local webhookUrl = "https://discord.com/api/webhooks/1361739173308137482/FmeEFLdBxc282-puETYgpHcz1-acTyltmAibQuNKLlY1bOuHJTygGQQcZMnp9s0HcD_e"

-- Function to get the user's profile picture URL
local function getUserProfile(player)
    -- Check if the player exists
    if player then
        -- Return the player's avatar URL (higher resolution)
        return "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
    else
        -- Default avatar URL if player is not found
        return "https://www.roblox.com/robux.gif"
    end
end

-- Function to get the current game name
local function getGameName()
    -- Use the game's name via a direct call to the game service
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end

-- Function to send the message to Discord with log details in an embed
local function sendWebhookMessage()
    -- Getting the current player
    local player = game.Players.LocalPlayer
    if not player then
        return
    end

    -- Generate a random color
    local randomColor = math.random(0, 16777215)

    -- Get the player's username and user ID
    local username = player.Name
    local userId = player.UserId

    -- Get the current execution time and date
    local executionTime = os.date("%X")  -- Current time
    local executionDate = os.date("%Y-%m-%d")  -- Current date

    -- Get the current game name
    local gameName = getGameName()

    -- Create the embed message content
    local embedData = {
        ["embeds"] = {
            {
                ["title"] = "★ Legacy",  -- Title of the embed
                ["description"] = "Launcher execution detected, here are the details:",  -- Short description
                ["color"] = randomColor,  -- Color of the embed (random)
                ["fields"] = {
                    {
                        ["name"] = "Username",
                        ["value"] = username,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "User ID",
                        ["value"] = tostring(userId),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Execution Time",
                        ["value"] = executionTime,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Execution Date",
                        ["value"] = executionDate,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Game Name",
                        ["value"] = gameName,
                        ["inline"] = true
                    }
                }
            }
        }
    }

    -- Convert the data to JSON format
    local jsonData = game:GetService("HttpService"):JSONEncode(embedData)

    -- Set up the headers
    local headers = {
        ["Content-Type"] = "application/json"
    }

    -- Executor-dependent request
    local success, errorMessage
    if syn then
        -- For Synapse X executor (syn.request)
        success, errorMessage = pcall(function()
            syn.request({
                Url = webhookUrl,
                Method = "POST",
                Headers = headers,
                Body = jsonData
            })
        end)
    elseif http_request then
        -- For Krnl executor (http_request)
        success, errorMessage = pcall(function()
            http_request({
                Url = webhookUrl,
                Method = "POST",
                Headers = headers,
                Body = jsonData
            })
        end)
    else
        return
    end

    -- Check if the message was sent successfully
    if not success then
        warn("bomboclat")
    end
end

-- Execute the function to send the message
sendWebhookMessage()
