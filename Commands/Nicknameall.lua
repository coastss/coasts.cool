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
if not Message.guild then return end

local NicknameToSetTo = nil

if Arguments[1] ~= nil then
    NicknameToSetTo = table.concat(Arguments, " ")
end

for i, v in pairs(Message.guild.members) do
    local Member = nil
    local Success, Error = pcall(function() Member = Message.guild:getMember(i) end)

    if Success then
        Member:setNickname(NicknameToSetTo)
    end
end

if NicknameToSetTo == nil then
    Message:reply(Utilities.CreateEmbed("Coasting", {
        "Reset everyones nicknames."
    }, Configuration.Colors.Red))
else
    Message:reply(Utilities.CreateEmbed("Coasting", {
        "Set everyones nickname to:",
        NicknameToSetTo
    }, Configuration.Colors.Red))
end

