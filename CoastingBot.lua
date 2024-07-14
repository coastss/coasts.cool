local Discordia = require("discordia")
local Fs = require("fs")
local Json = require("json")
local PrettyPrint = require("pretty-print")

local Configuration = require("./Configuration.lua")
local Utilities = require("./Modules/Utilities.lua")
local Database = require("./Modules/Database.lua")
local Base64 = require("./Modules/Base64.lua")
local ShaHashing = require("./Modules/ShaHashing.lua")
local Purchases = require("./Modules/Purchases.lua")

local Client = Discordia.Client()
Discordia.extensions()

local FS = {
    Writefile = Fs.writeFileSync,
    Readfile = Fs.readFileSync,
    UnlinkFile = Fs.unlink,
    RenameFile = Fs.rename,
    FileExists = Fs.existsSync
}

local Environment = {
    Discordia = Discordia,
    Client = Client,
    Configuration = Configuration,
    Utilities = Utilities,
    Database = Database,
    Base64 = Base64,
    FS = FS,
    Json = Json,
    PrettyPrint = PrettyPrint,
    Purchases = Purchases
}

for i, v in pairs(Environment) do
    _G[i] = v
end

local CoastingScript = Json.decode(FS.Readfile("Flags/coastingscript.json")).coastingscript
local WeblitApp = require("./Weblit/weblit-app.lua")

WeblitApp.bind({host = "0.0.0.0", port = 444})
WeblitApp.use(require("./Weblit/weblit-auto-headers.lua"))

WeblitApp.route({method = "GET", path = "/coasting/getuser.lua", domain = ""}, function(request, response, go)
    response.code = 200
    response.headers = {}

    if not request.query then response.body = "" return go() end
    if not request.query["id"] then response.body = "" return go() end

    local UserId = request.query["id"]
    local Username = ""
    local Success, Error = pcall(function() Username = Client:getUser(UserId).username end)

    if Success then
        response.body = Username
    else
        response.body = ""
    end

    return go()
end)

WeblitApp.route({method = "GET", path = "/coasting/gethardwareid.lua", domain = ""}, function(request, response, go)
    response.code = 200
    response.headers = {}
    
    local HardwareId = ""

    if request.headers["Syn-Fingerprint"] then
        HardwareId = request.headers["Syn-Fingerprint"]
    elseif request.headers["proto-user-identifier"] then
        HardwareId = request.headers["proto-user-identifier"]
    end

    if HardwareId ~= "" then
        HardwareId = Base64.Encode(ShaHashing.Sha(512, HardwareId))
    end

    response.body = HardwareId
    return go()
end)

WeblitApp.route({method = "GET", path = "/coasting/getfile.lua", domain = ""}, function(request, response, go)
    response.code = 200
    response.headers = {}

    if request.query == nil then response.body = "" return go() end
    if not request.query["scriptid"] then response.body = "" return go() end
    if not request.query["exploit"] then response.body = "" return go() end
    if not request.query["scripttype"] then response.body = "" return go() end

    if request.query["exploit"] == "SynapseX" then else response.body = "" return go() end
    if request.query["scripttype"] == "main" or request.query["scripttype"] == "whitelister" then else response.body = "" return go() end

    if not Database.IsUserInDatabase(Base64.Decode(request.query["scriptid"])) then response.body = "" return go() end

    local ScriptId = request.query["scriptid"]
    local Exploit = request.query["exploit"]
    local ScriptType = request.query["scripttype"]

    if ScriptType == "main" then
        response.body = (Utilities.ScriptFileContent:format(ScriptId) .. "\n\n".. module:load("./CoastingScript/" .. Exploit .. ".lua"))
    elseif ScriptType == "whitelister" then
        response.body = (Utilities.ScriptFileContent:format(ScriptId) .. "\n\n".. module:load("./CoastingScript/" .. Exploit .. "Whitelister.lua"))
    end
    
    return go()
end)

WeblitApp.route({method = "GET", path = "/coasting/whitelister.lua", domain = ""}, function(request, response, go)
    response.code = 200
    response.headers = {}
    CoastingScript = Json.decode(FS.Readfile("Flags/coastingscript.json")).coastingscript

    if not CoastingScript then response.body = "[Whitelister]: Script is down." return go() end
    if request.query == nil then response.body = "[Whitelister]: Failed to find request query." return go() end
    if not request.query["hardwareid"] then response.body = "[Whitelister]: Failed to find hardwareid request query." return go() end
    if not request.query["exploit"] then response.body = "[Whitelister]: Failed to find exploit request query." return go() end
    if not request.query["scriptid"] then response.body = "[Whitelister]: Failed to find scriptid request query." return go() end

    if request.query["exploit"] == "SynapseX" then else response.body = "[Whitelister]: Unsupported exploit." return go() end
    if not Database.IsUserInDatabase(Base64.Decode(request.query["scriptid"])) then response.body = "[Whitelister]: Couldn't locate user in the database." return go() end

    local HardwareId = request.query["hardwareid"]
    local Exploit = request.query["exploit"]
    local ScriptId = request.query["scriptid"]

    local UserId = Base64.Decode(ScriptId)
    local EncodedHardwareId = HardwareId

    if Exploit == "SynapseX" then
        Exploit = "Synapse X"
        if Database.GetUserDataElement(UserId, "SynapseXHWID") ~= (nil or "") then response.body = "[Whitelister]: You are already whitelisted for Synapse X." return go() end
        Database.ChangeUserDataElement(UserId, "SynapseXHWID", EncodedHardwareId)
    end

    response.body = (("[Whitelister]: You have successfully been whitelisted for %s, please DM the bot !getscript to start using Coasting."):format(Exploit))

    Utilities.SendWebhook("https://discordapp.com/api/webhooks/740640460342558832/OJqJQ-OgBu7SvGkyxz6yJwM_-xPvYjilfQrC_4oJ06-B1H4LHDF1IJiBrWQtbLhk1Wfx", "Coasting Whitelists", {
        "User:", Utilities.Constants.MentionUser:format(UserId),
        "Hardware Id:", EncodedHardwareId,
        "Script Id:", ScriptId,
        "Exploit:", Exploit
    }, "coasting whitelists")

    return go()
end)

WeblitApp.route({method = "GET", path = "/coasting/authentication.lua", domain = ""}, function(request, response, go)
    response.code = 200
    response.headers = {}
    CoastingScript = Json.decode(FS.Readfile("Flags/coastingscript.json")).coastingscript

    if not CoastingScript then response.body = "Script is down" return go() end
    if request.query == nil then response.body = "" return go() end
    if request.headers == nil then response.body = "" return go() end

    if not request.query["key"] then response.body = "" return go() end
    if not request.query["scriptid"] then response.body = "" return go() end  
    if not request.query["hwid"] then response.body = "" return go() end
    if not request.query["clientdata"] then response.body = "" return go() end

    if request.headers["Exploit"] == "SynapseX" then else response.body = "" return go() end
    if not request.headers["RobloxUser"] then response.body = "" return go() end

    if not Database.IsUserInDatabase(Base64.Decode(request.query["scriptid"])) then response.body = "" return go() end

    local Key = request.query["key"]
    local ScriptId = request.query["scriptid"]
    local HardwareId = request.query["hwid"]

    local ClientData = request.query["clientdata"]
    local Exploit = request.headers["Exploit"]
    local RobloxUser = request.headers["RobloxUser"]

    local UserId = Base64.Decode(ScriptId)

    local AuthenticationClientKey = "mP.b,?_grGkkuq^cWvZ1tAu2NCo1L4tetLnpYM]kfRriCv!LEgaobWaYr23.7E4,}N+nei-Hcopt5-LFGQC5%jV>H2~5.c8zY>cB"
    local AuthenticationServerKey = "~17*uzqa)MZ=*2Wc)Teu37kvwHyVw]^P^}-R]T8mx>qvB]?.a8]x#?TqK0RAw_T.qV55mz?Ff1!1bj~r=~:~ND_n>ypp*B]=^XQ]"

    local ClientKeySplit = Utilities.SplitString(AuthenticationClientKey, 50)
    local ServerKeySplit = Utilities.SplitString(AuthenticationServerKey, 50)
    local UserHardwareId = ""

    local ServerData = Base64.Encode(ClientKeySplit[1], ScriptId .. Key .. HardwareId .. ClientKeySplit[2])
    local UserScriptId = Database.GetUserDataElement(UserId, "ScriptId")
    local UserKey = Database.GetUserDataElement(UserId, "Key")

    if Exploit == "SynapseX" then
        Exploit = "Synapse X"
        UserHardwareId = Database.GetUserDataElement(UserId, "SynapseXHWID")
    end

    function SendFailedLoginWebhook(reason)
        Utilities.SendWebhook("https://discordapp.com/api/webhooks/739969471547965557/GEb_8WYlx4Y5swzfKWDlmV9Hvl3czrhEaV7amNY7QrAOVZeIGAk99sm0tz8mK9OdzXs3", "Coasting Logins", {
            "User:", Utilities.Constants.MentionUser:format(UserId),
            "Reason: ", reason,
            "Key:", Key,
            "Hardware Id:", HardwareId,
            "Script Id:", ScriptId,
            "Exploit:", Exploit,
            "Roblox User:", RobloxUser,
        }, "coasting logins")
    end

    if ScriptId == UserScriptId and Key == UserKey and HardwareId == UserHardwareId and ClientData == ServerData then
        response.body = Base64.Encode(ServerKeySplit[1], ScriptId .. Key .. HardwareId .. ServerKeySplit[2])

        Utilities.SendWebhook("https://discordapp.com/api/webhooks/739969348214587402/6csgABmF_27sy5uCtM5-lQz8R6FRSpGNExZpXde6HO9Y7vM0xYTShqDxYg635YETdBkh", "Coasting Logins", {
            "User:", Utilities.Constants.MentionUser:format(UserId),
            "Key:", Key,
            "Hardware Id:", HardwareId,
            "Script Id:", ScriptId,
            "Exploit:", Exploit,
            "Roblox User:", RobloxUser,
        }, "coasting logins")
    elseif ScriptId ~= UserScriptId then
        response.body = "User Mismatch"
        SendFailedLoginWebhook("User Mismatch")
    elseif Key ~= UserKey then
        response.body = "Invalid Key"
        SendFailedLoginWebhook("Invalid Key")
    elseif HardwareId ~= UserHardwareId then
        response.body = "HWID Mismatch"
        SendFailedLoginWebhook("HWID Mismatch")
    elseif ClientData ~= ServerData then
        response.body = "Data Mismatch"
        SendFailedLoginWebhook("Data Mismatch")
    end

    Database.ChangeUserDataElement(UserId, "ClientKey", "")
    Database.ChangeUserDataElement(UserId, "ServerKey", "")

    return go()
end)

function CommandExists(command)
    local CommandName = command:gsub("^%l", string.upper)

    if FS.FileExists("./Commands/" .. CommandName .. ".lua") then
        return true
    else
        return false
    end
end

function LoadCommand(command)
    local CommandName = command:gsub("^%l", string.upper)
    local Environment = setmetatable({}, {__index = _G})

    assert(pcall(setfenv(assert(loadfile("./Commands/" .. CommandName .. ".lua")), Environment)))
    setmetatable(Environment, nil)
    
    return Environment
end

Client:on("messageCreate", function(message)
    pcall(function()
        local Arguments = message.content:split(" ")

        if Arguments[1]:find(Configuration.Prefix) then
            local Command = Arguments[1]:gsub(Configuration.Prefix, "")

            if CommandExists(Command) then
                table.remove(Arguments, 1)

                _G.Message = message
                _G.Arguments = Arguments
                LoadCommand(Command)
            end
        end
    end)
end)

Client:on("memberJoin", function(member)
    if not member.guild then return end

    local Member = member.guild:getMember(member.id)
    local WelcomeAndGoodbyeChannel = Client:getChannel(Configuration.Channels.WelcomeAndGoodbye)
    local Success, Error = pcall(function()
        Member:addRole(Configuration.Roles.Member)
        Member:addRole(Configuration.Roles.Access)
    end)

    if Success then
        WelcomeAndGoodbyeChannel:send("Yo wassup " .. Utilities.Constants.MentionUser:format(member.id) .. ", welcome to **Coasting**!")
    elseif Error then
        local Success2, Error2 = pcall(function()
            Member:addRole(Configuration.Roles.Member)
            Member:addRole(Configuration.Roles.Access)
        end)

        if Success2 then
            WelcomeAndGoodbyeChannel:send("Yo wassup " .. Utilities.Constants.MentionUser:format(member.id) .. ", welcome to **Coasting**!")
        end
    end
end)

Client:on("memberLeave", function(member)
    local WelcomeAndGoodbyeChannel = Client:getChannel(Configuration.Channels.WelcomeAndGoodbye)
    WelcomeAndGoodbyeChannel:send(Utilities.Constants.MentionUser:format(member.id) .. " just left the server, see ya!")
end)

WeblitApp.start()
Client:run(Configuration.Token)