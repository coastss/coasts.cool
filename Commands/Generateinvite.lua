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

local InviteUseAmount = tonumber(Arguments[1])
local CreatedInviteMessage = ""

if InviteUseAmount == 1 then
    CreatedInviteMessage = ("Successfully created a invite with %s use."):format(InviteUseAmount)
else
    CreatedInviteMessage = ("Successfully created a invite with %s uses."):format(InviteUseAmount)
end

local Invite, Error = Message.channel:createInvite({max_age = 86400, max_uses = InviteUseAmount, temporary = false, unique = false})

if Invite then
    return Message:reply(Utilities.CreateEmbed("Coasting", {
        CreatedInviteMessage,
        ("Invite Link: https://discord.gg/" .. Invite.code)
    }, Configuration.Colors.Red))
end