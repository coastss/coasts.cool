local Discordia = require("discordia")
Discordia.extensions()

--// Main bot stuff.
local Prefix = "!"
local Token = "Bot NzIyNTYzOTg2Mjg1MTMzOTQ1.Xuk6Jg.ybfcwMoDpI1g10_OwuLhnNRYKbk"
local ServerId = "739623766807674910"

local Colors = {
    Red = Discordia.Color.fromRGB(255, 75, 75).value,
    Orange = Discordia.Color.fromRGB(255, 165, 0).value,
    Yellow = Discordia.Color.fromRGB(255, 255, 0).value,
    Green = Discordia.Color.fromRGB(90, 255, 60).value,
    Blue = Discordia.Color.fromRGB(0, 255, 255).value,
    Purple = Discordia.Color.fromRGB(100, 0, 255).value,
    Pink = Discordia.Color.fromRGB(255, 0, 220).value
}

local Roles = {
    Staff = "739623766807674916",
    SwagBruhs = "739623766807674915",
    Donator = "739623766807674913",
    Access = "739623766807674912",
    Member = "739623766807674911"
}

local Channels = {
    WelcomeAndGoodbye = "739623767109533778",
    ChangeLogs = "739623767277305956"
}

return {
    Prefix = Prefix,
    Token = Token,
    ServerId = ServerId,
    Colors = Colors,
    Roles = Roles,
    Channels = Channels
}