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
local HasPermissions = (AuthorId == "317751432394571817" or AuthorId == "279655764581154816" or Member:hasRole(Configuration.Roles.Staff)) and true or false

if Member:hasRole(Configuration.Roles.Access) then
    return Message:reply(Utilities.CreateEmbed("Coasting", {
        "Response:",
        ("You're already have access, %s!"):format(Utilities.Constants.MentionUser:format(AuthorId)),
    }, Configuration.Colors.Red))
end

if not Database.IsUserInDatabase(AuthorId) then
    return Message:reply(Utilities.CreateEmbed("Coasting", {
        "Response:",
        ("Couldn't find %s in the database."):format(Utilities.Constants.MentionUser:format(AuthorId)),
    }, Configuration.Colors.Red))
end

Member:addRole(Configuration.Roles.Access)

return Message:reply(Utilities.CreateEmbed("Coasting", {
    "Response:",
    ("Successfully gave your role back, %s!"):format(Utilities.Constants.MentionUser:format(AuthorId)),
}, Configuration.Colors.Red))