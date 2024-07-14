local Discordia = require("discordia")
local Configuration = require("../Configuration.lua")
local Http = require("coro-http")

Discordia.extensions()

local GetFileContent = [==[
shared.AuthKey = "%s"
local Exploit = (syn and "SynapseX")
loadstring(game:HttpGet("https://coasts.cool/coasting/getfile.lua?scriptid=%s&scripttype=%s&exploit=" .. Exploit))()]==]

local ScriptFileContent = [==[
local QueueForTeleport = syn.queue_on_teleport
local GetRegistry = getregistry or debug.getregistry
local AuthKey = shared.AuthKey
    
GetRegistry().AuthKey = AuthKey
GetRegistry().ScriptId = "%s"]==]

function GenerateKey()
    local UpperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local LowerCaseLetters = "abcdefghijklmnopqrstuvwxyz"
    local Numbers = "0123456789"

    local CharacterSet = UpperCaseLetters .. LowerCaseLetters .. Numbers
    local Output = ""

    for i = 1, 18 do
        local Random = math.random(#CharacterSet)
        Output = Output .. string.sub(CharacterSet, Random, Random)
    end

    return Output
end

function GenerateDataKey()
    local UpperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local LowerCaseLetters = "abcdefghijklmnopqrstuvwxyz"
    local Numbers = "0123456789"
    local Symbols = "`~!@#$%^&*()+{}|:<>?-=[];',./"

    local CharacterSet = (UpperCaseLetters .. LowerCaseLetters .. Numbers .. Symbols)
    local Output = ""

    for i = 1, 100 do
        local Random = math.random(#CharacterSet)
        Output = Output .. string.sub(CharacterSet, Random, Random)
    end

    return Output
end


function CreateEmbed(title, data, color)
    local Embed = {}
    local Fields = {}
    
    for i = 1, #data, 2 do
        local Field = data[i]
        local Text = data[i + 1]
        table.insert(Fields, {
            name = Field,
            value = Text,
            inline = false
        })
    end
    
    Embed.title = title
    Embed.fields = Fields
    Embed.footer = {text = "coasting bot"}
    Embed.timestamp = Discordia.Date():toISO("T", "Z")
    Embed.color = color

    return {embed = Embed}
end

function CreateEmbedWithImage(title, data, imageurl, color)
    local Embed = {}
    local Fields = {}
    
    for i = 1, #data, 2 do
        local Field = data[i]
        local Text = data[i + 1]
        table.insert(Fields, {
            name = Field,
            value = Text,
            inline = false
        })
    end
    
    Embed.title = title
    Embed.fields = Fields
    Embed.image = {url = imageurl}
    Embed.footer = {text = "coasting bot"}
    Embed.timestamp = Discordia.Date():toISO("T", "Z")
    Embed.color = color

    return {embed = Embed}
end


function SendWebhook(webhook, title, data, footer)
    local WebhookUrl = webhook
    local Headers = {
        {"content-type", "application/json"}
    }

    local Fields = {}
    
    for i = 1, #data, 2 do
        local Field = data[i]
        local Text = data[i + 1]
        table.insert(Fields, {
            name = Field,
            value = Text
        })
    end

    local WebhookEmbed = {
        title = title,
        fields = Fields,
        footer = {text = footer},
        color = Configuration.Colors.Red,
        timestamp = Discordia.Date():toISO("T", "Z")
    }

    coroutine.wrap(function()
        local Response, Body = Http.request("POST", WebhookUrl, Headers, Json.encode({embeds = {WebhookEmbed}}))
    end)()
end

local function SplitString(text, chunksize)
    local s = {}
    for i = 1, #text, chunksize do
        s [#s + 1] = text:sub(i, i + chunksize - 1)
    end
    
    return s
end

function CreateInvalidPermissionsEmbed(userid)
    local Embed = {}
    
    Embed.title = "Coasting"
    Embed.fields = {{name = "Response:", value = ("You do not have the permissions to do that, <@" .. userid .. ">."), inline = false}}
    Embed.footer = {text = "coasting bot"}
    Embed.timestamp = Discordia.Date():toISO("T", "Z")
    Embed.color = Configuration.Colors.Red

    return {embed = Embed}
end

function ParseDiscordMention(mentioneduser)
    local CharactersToParse = {"<", ">", "!", "@"}

    for i, v in pairs(CharactersToParse) do
        mentioneduser = string.gsub(mentioneduser, v, "")
    end

    return mentioneduser
end

local Constants = {
    MentionUser = "<@%s>",
    Markdown = "```%s\n%s\n```",
    EasyMarkdown = "`%s`"
}

return {
    GetFileContent = GetFileContent,
    ScriptFileContent = ScriptFileContent,
    GenerateKey = GenerateKey,
    GenerateDataKey = GenerateDataKey,
    CreateEmbed = CreateEmbed,
    CreateEmbedWithImage = CreateEmbedWithImage,
    SendWebhook = SendWebhook,
    SplitString = SplitString,
    CreateInvalidPermissionsEmbed = CreateInvalidPermissionsEmbed,
    ParseDiscordMention = ParseDiscordMention,
    Constants = Constants
}