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

if not HasPermissions then return end
if not Message.channel then return end

local ChangeLogChannel = Client:getChannel(Configuration.Channels.ChangeLogs)
local UpdateContent = table.concat(Arguments, " ")

ChangeLogChannel:send("@everyone")
Message:reply(Utilities.CreateEmbed("Coasting", {
    "Change Logs:",
    UpdateContent
}, Configuration.Colors.Red))
return Message:delete()