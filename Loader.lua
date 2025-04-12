-- Roblox Script: Basit Bildirim
local StarterGui = game:GetService("StarterGui")

-- Bildirim Ayarları
local title = "★ Legacy"
local text = "Script is loading..."
local duration = 5 -- Bildirimin ekranda kalacağı süre (saniye)

-- Bildirimi Gönder
StarterGui:SetCore("SendNotification", {
    Title = title;
    Text = text;
    Duration = duration;
})

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "★ Legacy | LAUNCHER",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "★ Legacy | For Peak Quality",
    LoadingSubtitle = "by Ege",
    Theme = "Light", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
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

 local Main = Window:CreateTab("★ Legacy", 11797834387) -- Title, Image

 local Section = Main:CreateSection("★ Legacy Main Version")

 local Button = Main:CreateButton({
   Name = "★ Legacy",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/New%20Version%20%5B%202025%20%5D.lua'))()
   end,
})

local Paragraph = Main:CreateParagraph({Title = "★ Legacy", Content = "This is the main version of Legacy. Universal in most games."})

local Section = Main:CreateSection("★ Legacy Fixed Version")

local Button = Main:CreateButton({
   Name = "★ Legacy | FIXED VERSION",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/New%20Fixed%20Version%20%5B%202025%20%5D.lua'))()
   end,
})

local Paragraph = Main:CreateParagraph({Title = "★ Legacy | FIXED VERSION", Content = "This is the fixed version of Legacy. If only the Player tab shows up when you execute the main version, execute this version instead."})

local Other = Window:CreateTab("★ Legacy Jailbreak", 11797834387) -- Title, Image

local Section = Other:CreateSection("★ Legitbreak Criminal Version")

 local Button = Other:CreateButton({
   Name = "★ Legitbreak | Criminal Version",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Scripts/Legitbreak%20Criminal.lua'))()
      wait(0)
      Rayfield:Destroy()
   end,
})

local Paragraph = Other:CreateParagraph({Title = "★ Legitbreak | Criminal Version", Content = "Another project of Legacy, this script is for Jailbreak and has Police Aimbot, Police ESP and Teleport Behind Doors in it. If you are going to play as a Criminal, use this version."})

local Section = Other:CreateSection("★ Legitbreak Police Version")

local Button = Other:CreateButton({
   Name = "★ Legitbreak | Police Version",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/aV7gP2hQw9TzK1d/fJ3kW9qL2xZbV8pT0mN4rC7a/refs/heads/main/Scripts/Legitbreak%20Police.lua'))()
      wait(0)
      Rayfield:Destroy()
   end,
})

local Paragraph = Other:CreateParagraph({Title = "★ Legitbreak | Police Version", Content = "Another project of Legacy, this script is for Jailbreak and has Criminal Aimbot, Criminal ESP and Teleport Behind Doors in it. If you are going to play as a Police, use this version."})
