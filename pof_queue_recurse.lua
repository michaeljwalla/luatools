shared.retardabilityerror = false --DONT TOUCH
shared.indentity = (shared.identity and shared.identity+1) or 0
local identity = shared.identity


local mins = 0.1
local print = rconsoleprint
print("@@WHITE@@")
print("\n\n"..os.date())
while not game:IsLoaded() do wait() end
if identity ~= shared.identity then  return end

local queue = syn.queue_on_teleport or queue_on_teleport
local rejoin = loadstring(game:HttpGet("https://raw.githubusercontent.com/michaeljwalla/luatools/main/functions/smallest_server.lua"))
lowest = function()  rejoin() end
function forceteleport(recursed, times)
    if identity ~= shared.identity then return end
    wait(1)
    if not times then times = 0 end
    if not recursed then
        print("@@BLUE@@")
        print("\n"..'attempting to teleport...')
    end
    local err, reas = pcall(lowest)
    if (not err) or (err and not reas) then 
        print("@@BLUE@@")
        print(string.format("\nteleport failed. reattempting... (%d)", times+1))
        forceteleport(true, times+1) 
    end
end

local main = loadstring(game:HttpGet("https://raw.githubusercontent.com/michaeljwalla/luatools/main/pof.lua"))
if not queue then
    print("@@RED@@")
    print("\n".."get a better executor retard")
end

print("\n"..'loaded  scripts')
local lp = game.Players.LocalPlayer
if not lp.Character then lp.CharacterAdded:Wait() end
if identity ~= shared.identity then  return end
local hrp = lp.Character:WaitForChild("HumanoidRootPart", 5)
if identity ~= shared.identity then print("\nduplicate detected. terminating...") return end
if not hrp then
    print("@@RED@@")
    print("\n"..'couldnt find HumanoidRootPart, rejoining')
    forceteleport()
    return
end
print("\n"..'loaded hrp')
local hum = lp.Character:WaitForChild("Humanoid")
if identity ~= shared.identity then print("\nduplicate detected. terminating...") return end
if not hum then
    print("@@RED@@")
    print("\n"..'couldnt find Humanoid, rejoining')
    forceteleport()
    return
end
print("\n"..'loaded humanoid')
local settings,playing = lp:WaitForChild("Settings",5)
if settings then playing = settings:WaitForChild("Playing",10) end
if not playing then
    print("@@RED@@")
    print("\n"..'couldnt find playvalue, rejoining...')
    forceteleport()
    return
end
local remotes, changesettings = game.ReplicatedStorage:WaitForChild("Remotes", 5)
if remotes then changesettings = remotes:WaitForChild("ChangeSettings",5) end
if identity ~= shared.identity then print("\nduplicate detected. terminating...") return end
if not changesettings then
    print("@@RED@@")
    print("\n"..'couldnt find sit-out function, rejoining...')
    forceteleport()
    return
end
local ls, coins = lp:FindFirstChild("leaderstats", 5)
if ls then coins = ls:WaitForChild("Coins", 5) end
if not coins then
    print("@@RED@@")
    print("\n"..'couldnt find coin counter, rejoining...')
    forceteleport()
    return
end
game.Players.PlayerRemoving:Connect(function(v)
    if v == lp then
        print("@@GREEN@@")
        print(string.format("\nc\nCurrent coins: %d\n",coins.Value))
        setclipboard(coins.Value)
    end
end)
if identity ~= shared.identity then print("\nduplicate detected. terminating...") return end
if game:GetService("Players").LocalPlayer.Settings.Playing then game:GetService("ReplicatedStorage").Remotes.ChangeSettings:InvokeServer("Playing") end
print("\nenabled sitting out")
print("\nhiding others...")
spawn(function()
    while wait() do
        if identity ~= shared.identity then  return end
        for i,v in pairs(game.Players:GetPlayers()) do
            if not v.Character or v == lp then continue end
            v.Character:Destroy()
            v.Character = nil
        end
    end
end)



print("\n"..'bringing to obby...')
if (hrp.Position-game:GetService("Workspace").Lobby.Obbies.ObbyTeleporter.Teleport.Position).Magnitude < 5000 then
    local topright = Vector3.new(-124,8.5,-124)
    local topleft = Vector3.new(-124,8.5,124)
    local backleft = Vector3.new(124,8.5,124)
    local backright = Vector3.new(124,8.5,-124)
    local atcp = false
    function displaced(pos)
        return (hrp.Position - pos).Magnitude
    end
    
    --if true then return end
    function tl()
        print('\n5 moves away')
        hum.WalkToPoint = topleft
        wait(1)
        print('\n4 moves away')
        hum.WalkToPoint = Vector3.new(-120,8.5,115)
        local t = tick()
        while displaced(topright) > 8 do wait() end
        if identity ~= shared.identity then print("\nduplicate detected. terminating...") return end
        atcp = true
    end
    function bl()
        print('\n7 moves away')
        hum.WalkToPoint = backleft
        wait(1)
        print('\n6 moves away')
        hum.WalkToPoint = Vector3.new(115,8.5,120)
        local t = tick()
        while displaced(topleft) > 8 do wait() end
        if identity ~= shared.identity then  return end
        tl()
    end
    function br()
        print('\n5 moves away')
        hum.WalkToPoint = backright
        wait(1)
        print('\n4 moves away')
        hum.WalkToPoint = Vector3.new(115,8.5,-128)
        local t = tick()
        while displaced(topright) > 8 do wait() end
        if identity ~= shared.identity then  return end
        atcp = true
    end
    local maxtime = tick()
    spawn(function()
        while tick()-maxtime < 15 and not atcp do wait() end
        if identity ~= shared.identity then  return end
        if not atcp then 
            print("\nwhere are you? teleporting to checkpoint...")
            hrp.CFrame = CFrame.new(topright)
            atcp = true
        end
    end)
    if displaced(topright) < 8 then
        atcp = true
        else if displaced(topleft) < 8 then
            tl()
            else if displaced(backleft) < 8 then
                bl()
                else if displaced(backright) < 8 then
                    br()
                    else do
                        if identity ~= shared.identity then print("\nduplicate detected. terminating...") return end
                        print("\nwhere are you? teleporting to checkpoint...")
                        hrp.CFrame = CFrame.new(topright)
                        atcp = true
                    end
                end
            end
        end
    end
    if identity ~= shared.identity then print("\nduplicate detected. terminating...") return end
    while not atcp do wait() end
    if identity ~= shared.identity then print("\nduplicate detected. terminating...") return end
    function lastcp(recursed, times)
        if identity ~= shared.identity then return end
        times = times or 0
        if not recursed then
            print('\nlast checkpoint')
            hum.WalkToPoint = topright --shh
            wait(1)
            print('\n3 moves away')
            hum.WalkToPoint = Vector3.new(-135,8,-124)
            wait(1)
            print('\n2 moves away')
            hum.WalkToPoint = Vector3.new(-135,8,-24)
            wait(5)
        else do hrp.CFrame = CFrame.new(Vector3.new(-135,8,-24)) end end
        print('\n1 move away')
        hum.WalkToPoint = Vector3.new(-174, 8, 0)
        wait(5)
        if times < 4 and (hrp.Position-game:GetService("Workspace").Lobby.Obbies.ObbyTeleporter.Teleport.Position).Magnitude < 5000 then 
            lastcp(true, times + 1) 
        else if  (hrp.Position-game:GetService("Workspace").Lobby.Obbies.ObbyTeleporter.Teleport.Position).Magnitude < 5000 then
            print("\nwhere are you? teleporting to door...")
            hrp.CFrame = CFrame.new(Vector3.new(-174, 8, 0))
            wait(1)
            return
        end
        end
    end
    lastcp()
else do hrp.CFrame = CFrame.new(Vector3.new(-10000, 8, -5))end end
if identity ~= shared.identity then print("\nduplicate detected. terminating...") return end
print("\nbrought to obby.")

spawn(main)
print("\nloaded replayability")
spawn(function()
    while not shared.retardabilityerror do wait()if identity ~= shared.identity then return end end
    print("@@RED@@")
    print("\nretardability error... rejoining...")
    forceteleport()
end)

spawn(function()
    wait(mins*60)
    forceteleport()
end)

print('\ndone')
print("@@BLUE@@")
print(string.format("\nteleporting in %sm...", tostring(mins)))

