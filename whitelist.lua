local lp = game.Players.LocalPlayer
function gethwid()
    return game:GetService("RbxAnalyticsService"):GetClientId()
end
local wl = {
  {
    UserId = 3312237316,
     HWID = {
      ['8DAEF9D0-637F-4264-AAE3-03E5F8725CFD'] = true
    },
    Dev = false
  }
}
function getwl()
    local id, hwid, dev
    for i,v in pairs(wl) do
        if v.UserId == lp.UserId then id = true end
        if v.HWID[gethwid()] then hwid = true end
        if v.Dev and (id or hwid) then dev = true end
    end
    return {UserId = id, HWID = hwid, Dev = dev}
end
local d = getwl()
local id, hwid, dev = d.UserId, d.HWID, d.Dev
return {Whitelisted = id or hwid, Dev = dev, GetWhitelist = getwl, WhitelistedBy = getwl()}
