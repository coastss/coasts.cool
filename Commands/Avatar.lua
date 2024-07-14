local Discordia = _G.Discordia
local Client = _G.Client
local Message = _G.Message
local Arguments = _G.Arguments

local Configuration = _G.Configuration
local Utilities = _G.Utilities
local Database = _G.Database
local FS = _G.FS

local AuthorId = Message.author.id
local Guild = Client:getGuild(Configuration.ServerId)
local Member = Guild:getMember(AuthorId)
local IsDirectMessages = (Message.channel.type == 1 and true or false)
local HasPermissions = (AuthorId == "317751432394571817" or AuthorId == "279655764581154816") and true or false

local User = nil

if Arguments[1] == nil then
    User = Message.author
else
    User = Client:getUser(Utilities.ParseDiscordMention(table.remove(Arguments, 1)))
end

return Message:reply(Utilities.CreateEmbedWithImage("Coasting", {
    "Avatar for:",
    User.tag
}, User:getAvatarURL(), Configuration.Colors.Red))