local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()
local SubmitButton

local UI =
    Material.Load(
        {
            Title = "★ Legacy | Chat Spoofer",
            Style = 2,
            SizeX = 400,
            SizeY = 220,
            Theme = "Dark"
        }
    )

local Page =
    UI.New(
        {
            Title = "Spoofer"
        }
    )

-- aardappel

local OwnMessage =
    Page.TextField(
        {
            Text = "Your message.",
            Callback = function(value)
                SubmitButton:SetText("Send (" .. CheckCount() .. "/39)")
            end,
            Menu = {
                Information = function(self)
                    UI.Banner(
                        {
                            Text = "You will send this message as yourself (required for the method). Use something meaningful to avoid suspicion."
                        }
                    )
                end
            }
        }
    )

local SpoofName =
    Page.TextField(
        {
            Text = "Username to Spoof.",
            Callback = function(value)
                SubmitButton:SetText("Send (" .. CheckCount() .. "/39)")
            end,
            Menu = {
                Information = function(self)
                    UI.Banner(
                        {
                            Text = "The victims username. Example : Roblox, Builderman."
                        }
                    )
                end
            }
        }
    )

local SpoofMessage =
    Page.TextField(
        {
            Text = "Spoofed message.",
            Callback = function(value)
                SubmitButton:SetText("Send (" .. CheckCount() .. "/39)")
            end,
            Menu = {
                Information = function(self)
                    UI.Banner(
                        {
                            Text = "The message that the spoofed user will say."
                        }
                    )
                end
            }
        }
    )

SubmitButton =
    Page.Button(
        {
            Text = "Send (0/39)",
            Callback = function()
                if CheckCount() > 39 then
                    UI.Banner({
                        Text = "This method only allows up to 39 characters. Try using a shorter message or victim name."
                    })
                else
                    message =
                        "" ..
                        tostring(OwnMessage:GetText()) ..
                        "                                                                                                                                                             [" ..
                        tostring(SpoofName:GetText()) .. "]: " .. tostring(SpoofMessage:GetText())
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
                end
            end
        }
    )

function CheckCount()
    local TotalChars = #OwnMessage:GetText() + #SpoofName:GetText() + #SpoofMessage:GetText()
    return TotalChars
end
