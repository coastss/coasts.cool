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

local ServerRules = [==[
If a staff member is abusing their powers please let <@317751432394571817> know.
```
1. No spamming, raiding, or very long messages that can fill the chat. (Mute)
2. Absolutely NO NSFW or gore. This includes: Pornography, Gore, Child Pornography, Animal Tortue, etc. (Ban)
3. No unsafe files or links. Such as: .rars, .exes, and any other type of file or link that looks suspicious. Let one of us know and we will take care of it. (Ban)
4. No serious threats. Such as: leaking info, ddosing, doxing, etc. (Ban)
5. No advertising, Like: youtube, twitter, etc. (Warn or Mute)
6. No drama, we aren't here to solve your problems. (Warn or Mute)
7. Don't ping staff for no reason. (Warn or Mute)
8. Making people in this server to raid people or other servers. (Which is also against the Terms of Service.) (Ban)
9. No racism or racial slurs, homophobia, or any other type of discrimination to someone. (Ban)
10. Don't try to avoid a ban or mute. (Ban)
11. No flashing/epileptic images. (Ban)```]==]

local HowToWhitelist = [==[
1. DM <@722563986285133945> `!getwhitelister`.
2. Run the script.
3. Then type `!getscript`.
4. Then your finished!]==]

Message:reply(Utilities.CreateEmbed("Coasting Info", {
    "Info:",
    "Supported Exploits: Synapse X and ProtoSmasher.",
    "Terms of Service:",
    "https://coasts.cool/coasting/termsofservice.txt",
    "Features List:",
    "https://coasts.cool/coasting/features.txt",
    "Rules: **Staff follow these rules aswell!**",
    ServerRules,
    "How to Whitelist:",
    HowToWhitelist,
    "Wanna invite a friend? Tell them to fill this out:",
    "https://docs.google.com/forms/d/e/1FAIpQLSd7Wa60sRAKveEoTl6J35k7OMadgCB3-w5MFfpl62CGxgDu8w/viewform"
}, Configuration.Colors.Red))

Message:reply()

return Message:delete()