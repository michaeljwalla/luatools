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
    Dev = true
  }
}

function iswl()
    local id, hwid, dev = false, false, false
    for i,v in pairs(wl) do
        if v.UserId == lp.UserId then id = true end
        if v.HWID == gethwid() then hwid = true end
        if v.Dev then dev = true end
      end
    end
    return id, hwid, dev
end
function getwltable()
    if dev then return wl else do lp:Kick("You are not a dev") end end
end
local id, hwid, dev = iswl()
return {Whitelisted = id or hwid, Dev = dev, GetWhitelist = getwltable, WhitelistedBy = {UserId = id, HWID = hwid, Dev = dev}}
