local Discordia = require("discordia")
local Json = require("json")
local FS = require("fs")
Discordia.extensions()

local Writefile = FS.writeFileSync
local Readfile = FS.readFileSync
local Unlink = FS.unlink
local Rename = FS.rename
local ExistsSync = FS.existsSync

local UserDataFile = ("Purchases/%s.json")

local function DoesUserHaveAPendingPurchase(userid)
    local UserData = UserDataFile:format(userid)

    if ExistsSync(UserData) then
        return true
    else
        return false
    end
end

local function AddUserToPurchasing(userid)
    local UserData = UserDataFile:format(userid)
    Writefile(UserData, "")
end

local function RemoveUserFromPurchasing(userid)
    local UserData = UserDataFile:format(userid)
    Unlink(UserData)
end

return {
    DoesUserHaveAPendingPurchase = DoesUserHaveAPendingPurchase,
    AddUserToPurchasing = AddUserToPurchasing,
    RemoveUserFromPurchasing = RemoveUserFromPurchasing
}