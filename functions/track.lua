local self = shared.self
local dtrack = self.Object
local opttrackplr, tplrname = shared.track, shared.name
local stop = function()
        if dtrack.Visible then dtrack.Visible = false end 
        local trackplr = game.Players:FindFirstChild(opttrackplr)
        if trackplr and trackplr.Character and trackplr.Character:FindFirstChild("HumanoidRootPart") then
            local tracked
            for i,v in pairs(_G.tracers) do if v.Tracking == trackplr.Character.HumanoidRootPart then v.Tracer:Destroy() v.Billboard:Destroy() table.remove(_G.tracers, i) break end end
        end
    end
 
local start = function()
        for i,v in pairs(game.Players:GetPlayers()) do
            if not opttrackplr or not typeof(opttrackplr) == "string" or opttrackplr == "" then break end
            if v ~= plr and string.lower(v.Name):find(string.lower(opttrackplr)) == 1 then opttrackplr = v.Name shared.track = opttrackplr break end
        end
        local trackplr = game.Players:FindFirstChild(opttrackplr)
        if trackplr and trackplr.Character and trackplr.Character:FindFirstChild("HumanoidRootPart") then
            local tracked
            for i,v in pairs(_G.tracers) do if v.Tracking == trackplr.Character.HumanoidRootPart then tracked = true break end end
            if not tracked then newtracer(trackplr.Character.HumanoidRootPart, tplrname or opttrackplr, 24) end
        end
        if not dtrack.Visible then dtrack.Visible = true end
        local found = false
        for i,v in pairs(game.Workspace.Disaster:GetChildren()) do
            if v:IsA("Model") then found = v break end
        end
        if found then
            dtrack.Text = found.Name
            dtrack.BackgroundTransparency = 0
            dtrack.TextColor3 = Color3.new(1,1,1)
            else do 
                dtrack.Text = "..."
                dtrack.BackgroundTransparency = .5
                dtrack.TextColor3 = Color3.new(0.2,0.2,0.2)
            end
        end
    end
return {Start = start, Stop = stop}
