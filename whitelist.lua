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
local whitelisted, dev
for i,v in pairs(wl) do
    if v.HWID[tostring(gethwid())] and (v.Dev or v.UserId == lp.UserId) then
    if v.Dev then dev = true  end
    whitelisted = true 
    break
  end
end
