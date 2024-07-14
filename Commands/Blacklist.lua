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
if Arguments[1] == nil or Arguments == nil then return end

local UserToBlacklist = Utilities.ParseDiscordMention(table.remove(Arguments, 1))
local BlacklistReason = table.concat(Arguments, " ")

if #BlacklistReason < 5 then
    return Message:reply(("%s, please specify a reason."):format(Utilities.Constants.MentionUser:format(AuthorId)))
else
    local Success, Error = Message.member.guild:banUser(UserToBlacklist, "Blacklisted: " .. BlacklistReason)

    if Success then
        pcall(function()
            Database.RemoveUserFromDatabase(UserToBlacklist)
        end)
        
        return Message:reply(Utilities.CreateEmbed("Coasting", {
            "Successfully blacklisted user:",
            Utilities.Constants.MentionUser:format(UserToBlacklist),
            "Reason:",
            BlacklistReason
        }, Configuration.Colors.Red))
    end
end