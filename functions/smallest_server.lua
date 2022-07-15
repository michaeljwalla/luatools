local HTTPS = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")

local nextCursor, serverId;
local minimum, current = math.huge, math.huge;

repeat
    local Servers;
    if not nextCursor then
        Servers = HTTPS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    else
        Servers = HTTPS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100&cursor="..nextCursor))
    end

    if (Servers) then
        nextCursor = Servers.nextPageCursor or nil
        for _,v in pairs(Servers.data) do
            if v.id == game.JobId then
                current = v.playing
            elseif v.playing < minimum and v.playing < current then
                minimum = v.playing
                serverId = v.id
            end
        end
    end
    wait()
until not nextCursor

if (serverId) then
    print("Teleporting to "..tostring(minimum).." Player Server!")
    TPS:TeleportToPlaceInstance(game.PlaceId, serverId)
    return true
else
    return false
end
