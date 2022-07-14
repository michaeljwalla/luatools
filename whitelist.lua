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
local whitelisted, dev
for i,v in pairs(wl) do
    if v.UserId == lp.UserId and v.HWID[tostring(gethwid())] then
    if v.Dev then dev = true end
    whitelisted = true 
    break
  end
end
return whitelisted, (dev and wl) or nil
