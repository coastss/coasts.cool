local Discordia = require("discordia")
local Json = require("json")
local FS = require("fs")

local Base64 = require("../Modules/Base64.lua")
local Utilities = require("../Modules/Utilities.lua")
Discordia.extensions()

local Writefile = FS.writeFileSync
local Readfile = FS.readFileSync
local Unlink = FS.unlink
local Rename = FS.rename
local ExistsSync = FS.existsSync

local UserDataFile = ("Database/%s.json")

function IsUserInDatabase(userid)
    local UserData = UserDataFile:format(userid)

    if ExistsSync(UserData) then
        return true
    else
        return false
    end
end

function AddUserToDatabase(userid)
    local UserData = UserDataFile:format(userid)
    local Data = {
        SynapseXHWID = "",
        Key = Utilities.GenerateKey(),
        ScriptId = Base64.Encode(userid)
    }

    Writefile(UserData, Json.encode(Data))
end

function ChangeUserData(userid, exploit, hwid, key, scriptid)
    local UserData = UserDataFile:format(userid)

    if exploit == "SynapseX" then
        local Data = {
            SynapseXHWID = hwid,
            Key = key,
            ScriptId = scriptid
        }
    end

    Writefile(UserData, Json.encode(Data))
end

function TransferUserData(userid, userid2)
    local OldUserDataFile = (UserDataFile:format(userid))
    local NewUserDataFile = (UserDataFile:format(userid2))

    Rename(OldUserDataFile, NewUserDataFile)
end

function RemoveUserFromDatabase(userid)
    local UserData = UserDataFile:format(userid)

    Unlink(UserData)
end

function GetUserDataElement(userid, element)
    local UserData = UserDataFile:format(userid)
    local UserDataList = Json.decode(Readfile(UserData))
    local UserElement = UserDataList[element]

    return(UserElement)
end

function ChangeUserDataElement(userid, element, newvalue)
    local UserData = UserDataFile:format(userid)
    local UserDataList = Json.decode(Readfile(UserData))
    UserDataList[element] = newvalue

    Writefile(UserData, Json.encode(UserDataList))
end

function AddUserDataElement(userid, element, newvalue)
    local UserData = UserDataFile:format(userid)
    local UserDataList = Json.decode(Readfile(UserData))

    if UserDataList[element] == nil then
        UserDataList[element] = newvalue
        Writefile(UserData, Json.encode(UserDataList))
    end
end

function WipeUserData(userid)
    local UserData = UserDataFile:format(userid)

    if ExistsSync(UserData) then
        local Data = {
            SynapseXHWID = "",
            Key = Utilities.GenerateKey(),
            ScriptId = Base64.Encode(userid)
        }

        Writefile(UserData, Json.encode(Data))
    end
end

function DoesUserHaveData(userid)
    local UserData = UserDataFile:format(userid)
    local UserDataList = Json.decode(Readfile(UserData))
    local UserElement = UserDataList

    if UserElement["SynapseXHWID"] ~= (nil or "") and UserElement["Key"] ~= (nil or "") and UserElement["ScriptId"] ~= (nil or "") then
        return true
    else
        return false
    end
end

return {
    IsUserInDatabase = IsUserInDatabase,
    AddUserToDatabase = AddUserToDatabase,
    ChangeUserData = ChangeUserData,
    TransferUserData = TransferUserData,
    RemoveUserFromDatabase = RemoveUserFromDatabase,
    GetUserDataElement = GetUserDataElement,
    ChangeUserDataElement = ChangeUserDataElement,
    AddUserDataElement = AddUserDataElement,
    WipeUserData = WipeUserData,
    DoesUserHaveData = DoesUserHaveData
}