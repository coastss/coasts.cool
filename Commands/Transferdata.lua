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

if not HasPermissions then 
    return Message:reply(Utilities.CreateInvalidPermissionsEmbed(AuthorId))
end

if not Message.guild then return end
if not Message.member then return end
if Arguments[1] == nil or Arguments[2] == nil or Arguments == nil then return end

local OldUser = Utilities.ParseDiscordMention(Arguments[1])
local NewUser = Utilities.ParseDiscordMention(Arguments[2])

pcall(function()
    Database.TransferUserData(OldUser, NewUser)
end)

local Member = Guild:getMember(NewUser)

if not Member:hasRole(Configuration.Roles.Access) then
    Member:hasRole(Configuration.Roles.Access)
end

local Success, Error = Message.member.guild:kickUser(OldUser, ("Transfered data from: %s to: %s."):format(OldUser, NewUser))

if Success then  
    return Message:reply(Utilities.CreateEmbed("Coasting", {
        "Previous account:",
        Utilities.Constants.MentionUser:format(OldUser),
        "New account:",
        Utilities.Constants.MentionUser:format(NewUser)
    }, Configuration.Colors.Red))
end