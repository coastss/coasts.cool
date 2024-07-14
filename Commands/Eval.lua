local Discordia = _G.Discordia
local Client = _G.Client
local Message = _G.Message
local Arguments = _G.Arguments

local Configuration = _G.Configuration
local Utilities = _G.Utilities
local Database = _G.Database
local FS = _G.FS
local PrettyPrint = _G.PrettyPrint

local AuthorId = Message.author.id
local Guild = Client:getGuild(Configuration.ServerId)
local Member = Guild:getMember(AuthorId)
local IsDirectMessages = (Message.channel.type == 1 and true or false)
local HasPermissions = (AuthorId == "317751432394571817" or AuthorId == "279655764581154816") and true or false

if not HasPermissions then 
    return Message:reply("haha, no :joy_cat: :joy_cat: :joy_cat:") 
end

if Arguments[1] == nil or Arguments == nil then return end

local Sandbox = setmetatable({}, {__index = _G})

local function Code(str)
    if str ~= ("" or nil) then
        return string.format("```\n%s\n```", str)
    else
        return(str)
    end
end

local function PrintLine(...)
    local Ret = {}

    for i = 1, select("#", ...) do
        local Arg = tostring(select(i, ...))
        table.insert(Ret, Arg)
    end
    return table.concat(Ret, "\t")
end

local function PrettyLine(...)
    local Ret = {}

    for i = 1, select("#", ...) do
        local Arg = PrettyPrint.strip(PrettyPrint.dump(select(i, ...)))
        table.insert(Ret, Arg)
    end
    return table.concat(Ret, "\t")
end

local function Execute(argument, message)
    if not argument then return end

    argument = argument:gsub("```\n?", "")

    local Lines = {}

    Sandbox.message = message

    Sandbox.print = function(...)
        table.insert(Lines, PrintLine(...))
    end

    Sandbox.p = function(...)
        table.insert(Lines, PrettyLine(...))
    end

    local fn, SyntaxError = load(argument, "CoastingBot", "t", Sandbox)
    if not fn then 
        return(Message:reply(Utilities.CreateEmbed("Coasting", {
            "Syntax Error:",
            Code(SyntaxError)
        }, Configuration.Colors.Red)))
    end

    local Success, RuntimeError = pcall(fn)
    if not Success then 
        return(Message:reply(Utilities.CreateEmbed("Coasting", {
            "Runtime Error:",
            Code(RuntimeError)
        }, Configuration.Colors.Red)))
    end
    
    Lines = table.concat(Lines, "\n")

    if #Lines > 1990 then
        Lines = Lines:sub(1, 1990)
    end

    return(Message:reply(Utilities.CreateEmbed("Coasting", {
        "Response:",
        Code(Lines)
    }, Configuration.Colors.Red)))
end

local Content = table.concat(Arguments, " ")
return Execute(Content, Message)