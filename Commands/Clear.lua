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

if not Message.channel then return end

if Arguments[1] == nil then
    return Message:reply(("Please enter a number of messages to be deleted, %s."):format(Utilities.Constants.MentionUser:format(AuthorId)))
end

if not tonumber(Arguments[1]) then return end

local AmountOfMessages = tonumber(Arguments[1])
local Channel = Message.channel

if AmountOfMessages <= 0 then
    return Message:reply(("Please clear more than %s messages, %s."):format(AmountOfMessages, Utilities.Constants.MentionUser:format(AuthorId)))
end

local Success, Error = Channel:bulkDelete(Channel:getMessages(AmountOfMessages + 1))

if Success then
    return Message:reply(("Successfully deleted %s %s."):format(AmountOfMessages, AmountOfMessages == 1 and "message" or "messages"))
end