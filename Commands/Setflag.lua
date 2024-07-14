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

if not HasPermissions then 
    return Message:reply(Utilities.CreateInvalidPermissionsEmbed(AuthorId)) 
end

local Flag = Arguments[1]
local SetFlagTo = Arguments[2]

if not FS.FileExists(("Flags/%s.json"):format(Flag)) then
    return Message:reply(Utilities.CreateEmbed("Coasting", {
        "Response:",
        "Invalid flag!"
    }, Configuration.Colors.Red))
end

if SetFlagTo == "true" then
    FS.Writefile(("Flags/%s.json"):format(Flag), Json.encode({[Flag] = true}))
elseif SetFlagTo == "false" then
    FS.Writefile(("Flags/%s.json"):format(Flag), Json.encode({[Flag] = false}))
end

return Message:reply(Utilities.CreateEmbed("Coasting", {
    ("Set %s to:"):format(Flag),
    SetFlagTo
}, Configuration.Colors.Red))