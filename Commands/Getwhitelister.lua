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

if not Member:hasRole(Configuration.Roles.Access) then
    return Message:reply(("You do not have access, %s!"):format(Utilities.Constants.MentionUser:format(AuthorId)))
end

if not IsDirectMessages then 
    return Message:reply(("Please use this commmand in DMs, %s."):format(Utilities.Constants.MentionUser:format(AuthorId)))
end

if not Database.IsUserInDatabase(AuthorId) then
    Database.AddUserToDatabase(AuthorId)
end

local AuthenticationKey = Database.GetUserDataElement(AuthorId, "Key")
local ScriptId = Database.GetUserDataElement(AuthorId, "ScriptId")
local FileType = "whitelister"
local ScriptContent = Utilities.GetFileContent:format(AuthenticationKey, ScriptId, FileType)

return Message:reply(Utilities.CreateEmbed("Coasting", {
    "Response:",
    Utilities.Constants.Markdown:format("lua", ScriptContent)
}, Configuration.Colors.Red))