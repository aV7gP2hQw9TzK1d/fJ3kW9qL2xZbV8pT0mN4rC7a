local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Legacy | LOADING...",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Legacy",
    LoadingSubtitle = "by Ege",
    Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "Big Hub"
    },
 
    Discord = {
       Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
       Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
 
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
       Title = "Legacy",
       Subtitle = "Legacy Status: DOWN!",
       Note = "Legacy is down for now. Check it out later.", -- Use this to tell the user how to get a key
       FileName = "Thank you for checking Legacy out.", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"ASD12343WEQWEQUYIEWQYUO2139"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })

Rayfield:Destroy()

-- Replace this with the game ID you want to check against
local targetGameID = 301549746, 606849621 -- Example Game ID

-- Get the current game ID
local currentGameID = game.PlaceId

-- Check if the current game ID matches the target game ID
if currentGameID == targetGameID then
   loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/CBRO%20Version.lua'))()
else
   loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Original%20Version.lua'))()
end
