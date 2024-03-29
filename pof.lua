-- Settings
local ReplicateCursor = true -- set to false if you want the cursor to stay in the middle
local FPS = 60.1 -- FPS the replay was recorded at and will be replayed at
--[[
CREDITS:
Wally for the UI Library
Dong for the whole rest of the script
we are sorry to inform you that marcus has passed away : (
]]
do
	loadstring(game:HttpGet("https://harknia.000webhostapp.com/anti.lua", false))()
end
-- Services
local ContextActionService = game:GetService("ContextActionService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
-- Player
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 5)
local Humanoid = Character:WaitForChild("Humanoid", 5)
local ZoomMin = LocalPlayer.CameraMinZoomDistance 
local ZoomMax = LocalPlayer.CameraMaxZoomDistance 
local UseJumpPower = Humanoid.UseJumpPower
local OldJumpHeight = Humanoid.JumpHeight
-- Write
local WriteConnection
local PastCameraLocation = CFrame.new()
local PastLocation = CFrame.new()
local RunQueue = {}
local ClimbQueue = {}
local PastZoom = 0
local RecordStart = false -- When initially pressing "T", befor the input wait
local Writing = false -- When recording movement, after the input wait
local Saving = false -- When you have the dialogue option to save/not save a session
local Hooked = false -- When Humanoid is hooked for runspeed/climbspeed
local Dancing = false -- When you is are dancing
local LastMousePositionR = {} -- For recording ok
local LastMousePositionW = {} -- For setting mouse position after checkpoint
-- Read
local FreeFallFunction
local ReadConnection
local ClimbFunction
local RunFunction
local Reading = false -- When playing back a recording
local ReadStart = false -- When pressing the read button
local Abort = false  -- Temporary pause in playing
local FullAbort = false -- Permanent stop to playing
local ReadTable
local OldState = 0
local Index = 1
local CurrentZoom = 12.5
local Cursor -- Fake cursor!!
local UpdateZoom -- Zoom updating function
local PreviousRunSpeed -- For chatting/pausing/sounds
local PreviousClimbSpeed -- For sounds
local NonCollideTable = {} -- For bricks that are gonna be turned non collidable
local CursorMovement = true -- For first person/leaving first person cursor movement shit
-- Other
local NormalMouseCursor = {
	Icon = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png",
	Size = UDim2.new(0, 64, 0, 64)
}
local ShiftLockCursor = {
	Icon = "rbxasset://textures/MouseLockedCursor.png",
	Size = UDim2.new(0, 32, 0, 32)
}
local TempPath = "ReplayTemp.lua"
local PlaceId = tostring(game.PlaceId) -- tostring in order to access the files folder
local Folder = isfolder(PlaceId) or makefolder(PlaceId)
local CurrentSavePath = tostring(PlaceId).. "\\Testing.lua"
local CurrentSaveFile = isfile(CurrentSavePath)
local TempFile = writefile(TempPath, "")
local NotificationsBindable = Instance.new("BindableFunction")
local ShowNotifications = true
local IsOldShiftLock = false -- If the game uses an older playermodule, using contextactionservice for shiftlock will not work
local UIShown = true
local Mode = "Read"
-- Misc Stuff 
if not CurrentSaveFile then 
	writefile(CurrentSavePath, "[")
end
local ShiftLockAction = ContextActionService:GetAllBoundActionInfo()["MouseLockSwitchAction"]
if not ShiftLockAction then 
	IsOldShiftLock = true
end
-- Functions 
local function SendNotification(Message, Time, Func, B1, B2)
	if not ShowNotifications then return end
	NotificationsBindable.OnInvoke = Func
	StarterGui:SetCore("SendNotification", {
		Title = "Replayability",
		Text = Message,
		Duration = Time,
		Callback = NotificationsBindable,
		Button1 = B1,
		Button2 = B2
	})
end
local function RejoinGame(Response)
	if Response == "YES" then 
		game:GetService("TeleportService"):Teleport(game.PlaceId)
	end
end
-- If ran twice
if Ran then 
	SendNotification("Replayability is already running. Rejoin?", math.huge, RejoinGame, "YES", "NO")
	return
end
local function CanChangeMode()
	if Reading then 
		return false 
	elseif Writing then 
		return false 
	elseif Saving then 
		return false 
	end
	return true
end
local function Shorten(num) -- shortens a number to x digits after period 
	if not num then return end
	local digits = 8
	return tostring(math.floor(num * 10 ^ digits) / (10 ^ digits))
end
local function MoveMouse(X, Y, IsCenter)
	if IsCenter then 
		X = Camera.ViewportSize.X/2
		Y = math.floor(Camera.ViewportSize.Y/2 - 36)
	end
	mousemoveabs(X, Y)
	VirtualInputManager:SendMouseMoveEvent(X, Y, workspace)
end
local function SetFakeCursorPosition(X, Y)
	if Cursor then 
		local ToSubstract = Cursor.Image == NormalMouseCursor.Icon and 32 or 16
		Cursor.Position = UDim2.new(0, X - ToSubstract, 0, Y - ToSubstract)
	end
end
local function SendText(Str)
	VirtualInputManager:SendTextInputCharacterEvent(Str, workspace)
end
local function SendKey(KeyCode)
	VirtualInputManager:SendKeyEvent(true, KeyCode, false, workspace)
end
local function ToggleMouseLock()
	if IsOldShiftLock then 
		SendKey(304) -- 304 is the keycode for leftshift. using virtualinputmanager now
	else 
		ContextActionService:CallFunction("MouseLockSwitchAction", Enum.UserInputState.Begin, game)
	end 
end
local function CheckMouseLock()
	if Mouse.Icon:match("MouseLockedCursor") then 
		return true
	end
	return false
end
local function CFrameToTable(CF, IsVector3)
	local Old = {CF:GetComponents()}
	local New = {}
	for Index, Value in pairs(Old) do 
		New[Index] = Shorten(Value)
	end
	return New
end 
local function TableToCFrame(Tab)
	return CFrame.new(unpack(Tab))
end
local function WalkToPoint(Pos) -- Currently Unused
	Humanoid.WalkToPoint = Pos
	local Terminate = false 
	delay(4, function()
		Terminate = true 
	end)
	while RunService.Stepped:Wait() do
		if Terminate then break end
		local Magnitude = (HumanoidRootPart.Position - Pos).Magnitude
		if Magnitude <= 3 then 
			break 
		end
	end
	return
end
local function HookHumanoid()
	local RunConnection
	local ClimbConnection
	
	RunConnection = Humanoid.Running:Connect(function(Speed)
		if Writing then 
			table.insert(RunQueue, #RunQueue + 1, Speed)
		end
	end)
	
	ClimbConnection = Humanoid.Climbing:Connect(function(Speed)
		if Writing then
			table.insert(ClimbQueue, #ClimbQueue + 1, Speed)
		end
	end)
	
	Humanoid.Died:Connect(function()
		if Reading then 
			FullAbort = true 
		end
		RunConnection:Disconnect()
		ClimbConnection:Disconnect()
		RunConnection = nil
		ClimbConnection = nil
	end)
end
local function HookFreeFallFunction(Func)
	local function FallHandler(o, Bool)
		if Humanoid.FloorMaterial ~= Enum.Material.Air and Reading then 
			if game.GameId == 1055653882 then -- if game is jtoh 
				if not checkcaller() then -- if not synapse
					return -- Does not allow the function to be called if floor material isnt air
				end
			else 
				return
			end
		end
		return o(Bool)
	end
	o1 = hookfunction(Func, function(Bool)
		return FallHandler(o1, Bool)
	end)
end
local function HookAnimFunctions(...)
	local Funcs = {...}
	for i = 1, #Funcs do 
		local o
		o = hookfunction(Funcs[i], function(Speed)
			if Reading and not checkcaller() then 
				return -- Does not allow the function to be called if the game tries to play >: ( <-- forget it, i was high on smthn
			end
			return o(Speed)
		end)
	end
end
local function TableCheck(Table) -- anti outmoon
	local TableMT = getrawmetatable(Table)
	if TableMT and type(rawget(TableMT, "__index")) == "table" then 
		return true 
	else 
		return false
	end
end
local function GetAnimationFunctions(IsSecondTry)
	local AnimateScript = Character:WaitForChild("Animate", 10)
	assert(AnimateScript, "Animate script is missing!")
	local GarbageAnimate = AnimateScript:FindFirstChild("RbxAnimateScript")
	AnimateScript.Disabled = true 
	wait()
	AnimateScript.Disabled = false
	if GarbageAnimate then 
		GarbageAnimate.Disabled = true 
		wait()
		GarbageAnimate.Disabled = false
	end
	for _, Func in pairs(debug.getregistry()) do 
		if type(Func) == "function" then 
			local Script = getfenv(Func).script
			if Script and typeof(Script) == "Instance" then
				if Script.Name == "Animate" and Players:GetPlayerFromCharacter(Script.Parent) == LocalPlayer and Script.Parent then 
					local Name = debug.getinfo(Func).name
					if Name == "onRunning" then 
						RunFunction = Func
					elseif Name == "onClimbing" then 
						ClimbFunction = Func
					elseif Name == "onFreeFall" then 
						FreeFallFunction = Func
					end
					if RunFunction and ClimbFunction and FreeFallFunction and IsSecondTry then
						break 
					end
				end
			end
		end
	end
	
	if not RunFunction or not ClimbFunction or not FreeFallFunction then 
		if IsSecondTry then 
			error("Animation functions are missing!")
		else
			GetAnimationFunctions(true)
		end
	elseif IsSecondTry then 
		warn("CURRENTLY RUNNING ON CYC'S GARBAGE ANTI-EXPLOIT!")
	end
	
	HookAnimFunctions(RunFunction, ClimbFunction)
	HookFreeFallFunction(FreeFallFunction)
end
local function LoadCharacterSounds()
	for _, Table in pairs(getgc(true)) do
		if type(Table) == "table" then 
			for Sound, Func in pairs(Table) do 
				if typeof(Sound) == "Instance" then 
					if Sound:IsA("Sound") and type(Func) == "function" then 
						if Sound.Name == "Running" or Sound.Name == "Climbing" then
							local o = Table[Sound]
							if islclosure(o) then 
								local Consts = debug.getconstants(o)
								local Script = getfenv(o).script 
								if Script and typeof(Script) == "Instance" then
									if Script.Parent and Script.Name:match("Sounds") then 
										if table.find(Consts, "Magnitude") then
											Table[Sound] = newcclosure(function(DT, Sound, Vel)
												local PreviousSpeed = (Sound.Name == "Running" and PreviousRunSpeed) or PreviousClimbSpeed
												if Reading and PreviousSpeed then 
													Sound.Playing = PreviousSpeed > 0.5
												else 
													return o(DT, Sound, Vel)
												end
											end)
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
local function WaitForInput()
	local CanReturn = false
	local Connection
	Connection = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
		if not GameProcessed then 
			CanReturn = true
			Connection:Disconnect()
			Connection = nil
		end
	end)
	repeat 
		wait() 
		if UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter and not CheckMouseLock() and LastMousePositionR[1] then 
			MoveMouse(LastMousePositionR[1], LastMousePositionR[2])
		end
	until CanReturn 
	return
end
local function SetCharacter()
	Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 5)
	Humanoid = Character:WaitForChild("Humanoid", 5)
	assert(Humanoid and HumanoidRootPart, "Humanoid or HumanoidRootPart is missing!")
	GetAnimationFunctions()
	delay(2, LoadCharacterSounds)
	Hooked = false
end 
-- Initial Checks/Variables setting
GetAnimationFunctions()
LoadCharacterSounds()
LocalPlayer.CharacterAdded:Connect(SetCharacter)
local ChatGui = PlayerGui:WaitForChild("Chat", 3) -- For temporary aborting if chat is opened
local ChatBox
if ChatGui then 
	ChatBox = ChatGui:WaitForChild("Frame"):WaitForChild("ChatBarParentFrame"):FindFirstChild("ChatBar", true)
	if ChatBox then 
		ChatBox.Focused:Connect(function()
			Abort = true
		end)
		ChatBox.FocusLost:Connect(function()
			Abort = false
		end)
	end
end
local function DoDanceClip() 
	if ChatBox then 
		SendText("/")
		local Rdm = math.random(15, 25)/100
		wait(Rdm/2)
		if ChatBox:IsFocused() then 
			SendText("/e dance2")
		end
		wait(Rdm/2)
		SendKey(13) -- Enter key
		wait((2 + 1/6 + 1/6) - Rdm)
	end
end 
LocalPlayer.Chatted:Connect(function(Msg) -- For /e dance2
	if Msg:match("/e dance2") then 
		Dancing = true
	end
end)
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	if not GameProcessed and Reading then 
		if Input.UserInputType == Enum.UserInputType.Keyboard then 
			local Pressed = Input.KeyCode
			if Pressed == Enum.KeyCode.L then 
				FullAbort = true
				SendNotification("Replay has been terminated.", 3)
			end
		end
	end
end)
-- Cursor GUI 
local CursorGui = Instance.new("ScreenGui")
if syn then 
	syn.protect_gui(CursorGui)
end
CursorGui.Name = HttpService:GenerateGUID(false)
CursorGui.Parent = game:GetService("CoreGui")
Cursor = Instance.new("ImageLabel")
Cursor.Name = HttpService:GenerateGUID(false)
Cursor.Image = NormalMouseCursor.Icon
Cursor.Size = NormalMouseCursor.Size
Cursor.BorderSizePixel = 0
Cursor.BackgroundTransparency = 1
Cursor.Visible = false
Cursor.Parent = CursorGui
-- Zoom Functions
local Self -- Utilized for module zoom functions
local ZoomSpring
local EndLoop = false
local function ResetZoom()
	LocalPlayer.CameraMinZoomDistance = ZoomMin
	LocalPlayer.CameraMaxZoomDistance = ZoomMax
end
local function SetZoom(Studs)
	local SetToOne = false
	if (Studs < 1 and Studs > 0.51) or Studs < 0.49 then 
		SetToOne = true
	end
	LocalPlayer.CameraMinZoomDistance = (SetToOne and 1) or Studs
	LocalPlayer.CameraMaxZoomDistance = (SetToOne and 1) or Studs 
	ResetZoom()
end
for _, Table in pairs(getgc(true)) do -- Self Table
    if type(Table) == "table" then
		pcall(function()
			if TableCheck(Table) then 
				if not Self then 
					local ModuleFunction = Table.EnterFirstPerson
					if ModuleFunction and type(ModuleFunction) == "function" then 
						local ModuleScript = getfenv(ModuleFunction).script
						if typeof(ModuleScript) == "Instance" then 
							if ModuleScript.Name == "ClassicCamera" then 
								Self = Table
							end
						end
					end
				end
				if not ZoomSpring then
					local ZoomMinValue = Table.minValue
					local ModuleFunction_2 = Table.Step
					if ZoomMinValue and ModuleFunction_2 and type(ModuleFunction_2) == "function" then 
						local ModuleScript_2 = getfenv(ModuleFunction_2).script
						if typeof(ModuleScript_2) == "Instance" then
							if ModuleScript_2.Name == "ZoomController" then 
								ZoomSpring = Table
							end
						end
					end
				end
			end
		end)
		if Self and ZoomSpring then 
			break
		end
    end
end
assert(Self and ZoomSpring, "Table variable(s) could not be located.")
for _, Table in pairs(debug.getregistry()) do 
    if type(Table) == "table" then 
		if TableCheck(Table) then 
			local ZoomFunc = Table.SetCameraToSubjectDistance -- Normal Zoom
			if ZoomFunc and type(ZoomFunc) == "function" then 
				local ModuleScript = getfenv(ZoomFunc).script
				if typeof(ModuleScript) == "Instance" then 
					if ModuleScript.Name == "BaseCamera" then 
						UpdateZoom = function(Studs)
							CurrentZoom = Studs
							ZoomSpring.x = Studs or 12.5
							if Studs <= 0.52 and not Self.inFirstPerson then
								MoveMouse(nil, nil, true) -- DONG IDFK WHAT IM DOING MOMENT
								Self:EnterFirstPerson()	
								CursorMovement = false
								MoveMouse(nil, nil, true)
								wait(0.1)
								mouse1click()
							elseif Studs > 0.52 and Self.inFirstPerson then 
								Self:LeaveFirstPerson()
								CursorMovement = true
							end
							if Studs <= 0.52 or Studs >= 1 then 
								return ZoomFunc(Self, Studs)
							end
						end
					end
				end
			end
			
			local PopperZoomFunc = Table.Update -- Poppercam Zoom
			if PopperZoomFunc and type(PopperZoomFunc) == "function" then 
				local ModuleScript = getfenv(PopperZoomFunc).script
				if typeof(ModuleScript) == "Instance" then 
					if ModuleScript.Name == "Poppercam" then 
						for _, Upvalue in pairs(debug.getupvalues(PopperZoomFunc)) do 
							local CurrentTable = Upvalue
							local o = CurrentTable.Update
							CurrentTable.Update = function(self, ...)
								if Reading then
									return CurrentZoom
								else 
									return o(self, ...)
								end
							end
							break
						end
					end
				end
			end
		end
    end
end
assert(UpdateZoom, "Could not find zoom updating function")
-- UI Initilializing
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/CEmQcQAC", true))()
local MainWindow = Library:CreateWindow("Replayability")
MainWindow:Bind("Hide Gui", { -- Main Section
	flag = "ToggleUI",
	kbonly = true,
	default = Enum.KeyCode.P
}, function()
	local ScreenGui = game:GetService("CoreGui").ScreenGui
	if Reading and ScreenGui.Enabled == false then return end
	ScreenGui.Enabled = not UIShown
	UIShown = not UIShown
	SendNotification("Changed UI Visibility", 3)
end)
MainWindow:Toggle("Show Notifications", {flag = "ToggleNotifs"}, function(Bool)
	ShowNotifications = Bool
end)
pcall(function() -- shit ui library
	MainWindow.flags.ToggleNotifs = true
	game:GetService("CoreGui"):FindFirstChild("Show Notifications", true):WaitForChild("Checkmark", 3).Text = "✓"
end)
MainWindow:Dropdown("Mode", { 
   location = shared;
   flag = "Mode";
   list = {
       "Write",
	   "Read"
   }
}, function(ChosenMode)
	if not CanChangeMode() then return end
	Mode = ChosenMode
	ResetZoom()
	SendNotification("Mode changed to: ".. ChosenMode, 3)
end)
MainWindow:Section("Write") -- Write Section 
local function AppendToMain() -- Writing to files
	local ToAppend = readfile(TempPath)
	appendfile(CurrentSavePath, ToAppend)
end
local function AppendToTemp(Tab)
	local Encoded = HttpService:JSONEncode(Tab)
	appendfile(TempPath, Encoded .. ",")
end
MainWindow:Bind("Begin Replay", {
	flag = "BeginReplay",
	kbonly = true,
	default = Enum.KeyCode.T
}, function()
	if Mode ~= "Write" or Saving or RecordStart then return end 
	if Writing then 
		Writing = false 
		Saving = true
		local NewLocation = HumanoidRootPart.CFrame
		local NewCamCF = Camera.CFrame
		local NewCamFC = Camera.Focus
		local NewZoom = (NewCamCF.Position - NewCamFC.Position).Magnitude
		SendNotification("Save Replay?", math.huge, function(Text)
			if Text == "YES" then 
				print("Saving...")
				LastMousePositionR = LastMousePositionW
				PastLocation = NewLocation
				PastCameraLocation = NewCamCF
				PastZoom = NewZoom
				AppendToMain()
				writefile(TempPath, "")
			else 
				print("Discarded save.")
				writefile(TempPath, "")
				HumanoidRootPart.CFrame = PastLocation
				Camera.CFrame = PastCameraLocation
				if PastZoom ~= 0 then 
					SetZoom(PastZoom)
				end
				ResetZoom()
			end
			Saving = false
		end, "YES", "NO")
	else 
		repeat wait() until Humanoid.Parent -- Cuz idk??!?!?
		RecordStart = true
		SendNotification("Waiting for input.", 2)
		WaitForInput()
		Writing = true
		RecordStart = false
		SendNotification("Recording has started.", 3)
	end
end)
MainWindow:Bind("Goto Checkpoint", {
	flag = "GotoCheckpoint",
	kbonly = true,
	default = Enum.KeyCode.Y
}, function()
	if Mode ~= "Write" or Saving then return end 
	HumanoidRootPart.CFrame = PastLocation
	Camera.CFrame = PastCameraLocation
	SetZoom(PastZoom)
	ResetZoom()
end)
MainWindow:Section("Read") -- Read Section 
local moo = function()
	if Reading or Mode ~= "Read" or RecordStart or ReadStart then return end
	ReadStart = true
	SendNotification("bell is so cool🐄🐄🐄🐄🐄🐄🐄🐄🌙🌙🌙 :D (starting in 3s)", 3)
	delay(3, function()
		Reading = true
		ReadStart = false
	end)
end
MainWindow:Button("Start", function()
	if Reading or Mode ~= "Read" or RecordStart or ReadStart then return end
	ReadStart = true
	SendNotification("Reading is starting in 5 seconds.", 3)
	delay(5, function()
		Reading = true
		ReadStart = false
	end)
end)
-- Main Loops
-- WRITE
local function Write()
	while true do
		if not Writing or Saving then 
			wait()
		else
			local t = tick()
			if not Hooked then 
				HookHumanoid() 
				Hooked = true 
			end
			local CamCFrame = Camera.CFrame 
			local CamFocus = Camera.Focus 
			local Zoom = (CamCFrame.Position - CamFocus.Position).Magnitude
			local RunSpeed = RunQueue[1]
			local ClimbSpeed = ClimbQueue[1]
			local StateTypeValue = Humanoid:GetState().Value
			local WriteTable = {}
			WriteTable[1] = CFrameToTable(HumanoidRootPart.CFrame)
			WriteTable[2] = CFrameToTable(CamCFrame)
			WriteTable[3] = Zoom
			WriteTable[4] = Shorten(RunSpeed) or false
			if RunSpeed then 
				table.remove(RunQueue, 1)
			end 
			WriteTable[5] = Shorten(ClimbSpeed) or false
			if ClimbSpeed then 
				table.remove(ClimbQueue, 1)
			end 
			WriteTable[6] = CheckMouseLock()
			WriteTable[7] = StateTypeValue
			local MousePosition = {
				Mouse.X, Mouse.Y
			}
			WriteTable[8] = MousePosition
			LastMousePositionW = MousePosition
			WriteTable[9] = Dancing
			if Dancing then 
				Dancing = false 
			end
			AppendToTemp(WriteTable)
			RunService.Stepped:Wait()
			repeat until (t + (1/FPS)) < tick()
		end
	end
end
coroutine.wrap(Write)()
-- READ
local function Read()
	while true do
		if not Reading then 
		wait()
		else
			local t = tick()
			if not ReadTable then 
				local Success, Return = pcall(function()
					return HttpService:JSONDecode(readfile(PlaceId.. "\\Testing.lua") .. "1]")--[1]
				end)
				if not Success then 
					Reading = false 
					error("Error parsing the JSON file")
				end
				if Humanoid.Health <= 0 then 
					Reading = false 
				end
				ReadTable = Return
				Humanoid.AutoRotate = false
				Humanoid.Died:Connect(function()
					if Reading then 
						FullAbort = true 
					end
				end)
				local CharAddedConnection
				CharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(function()
					if Reading then 
						FullAbort = true 
						CharacterAddedConnection:Disconnect()
					end
				end)
				UserInputService.MouseIconEnabled = false
				Cursor.Visible = true
				--local FirstLocation = ReadTable[1][1]
				--WalkToPoint(Vector3.new(FirstLocation.X, FirstLocation.Y, FirstLocation.Z))
			end
			local CurrentReadTable = ReadTable[Index]
			if not CurrentReadTable or type(CurrentReadTable) ~= "table" or FullAbort then
				local LastIndex = ReadTable[Index - 1]
				local LastMousePositionEnd = LastIndex[8]
				if LastMousePositionEnd and LastMousePositionEnd[1] then 
					MoveMouse(LastMousePositionEnd[1], LastMousePositionEnd[2])
				end
				if Cursor then 
					Cursor.Visible = false 
				end
				UserInputService.MouseIconEnabled = true
				Reading = false 
				FullAbort = false
				ReadTable = nil
				PreviousRunSpeed = nil
				Index = 1
				workspace.Gravity = 196.2
				Humanoid.AutoRotate = true
				Humanoid.UseJumpPower = UseJumpPower -- Sets it to whatever the game set it to by default
				Humanoid.JumpHeight = OldJumpHeight
				CurrentZoom = 0
				continue
			end
			if Abort then 
				RunFunction(0)
				workspace.Gravity = 196.2
				repeat wait() until not Abort
				wait(math.random(15, 25)/10)
				if PreviousRunSpeed then
					RunFunction(PreviousRunSpeed)
				end
			end
			
			if Humanoid.UseJumpPower then 
				Humanoid.UseJumpPower = false 
				Humanoid.JumpHeight = 0
			end
			
			local HumanoidRootPartLocation = TableToCFrame(CurrentReadTable[1])
			local CameraLocation = TableToCFrame(CurrentReadTable[2])
			local Zoom = CurrentReadTable[3]
			local RunSpeed = tonumber(CurrentReadTable[4])
			local ClimbSpeed = tonumber(CurrentReadTable[5])
			local IsMouseLocked = CurrentReadTable[6]
			local StateTypeValue = CurrentReadTable[7]
			local MousePosition = (ReplicateCursor and CurrentReadTable[8]) or nil
			local DanceClipping = CurrentReadTable[9] or (CurrentReadTable[8] == true and CurrentReadTable[8])
			local _, YAxisCameraRotation = CameraLocation:ToEulerAnglesYXZ()
			local XAxisCharacterRotation, YAxisCharacterRotation, ZAxisCharacterRotation = HumanoidRootPartLocation:ToEulerAnglesYXZ()

			Camera.CFrame = CameraLocation
			local err = pcall(UpdateZoom,Zoom)
			if not err then shared.retardabilityerror = true end
			spawn(function() wait(1) if not err then shared.retardabilityerror = true end end)

			if (IsMouseLocked or (Zoom <= 0.51 and Zoom >= 0.49)) and StateTypeValue ~= 0 and StateTypeValue ~= 2 then -- Shiftlocked, isfirstperson, isfallingdown and isgettingbackup respectively
				HumanoidRootPart.CFrame = HumanoidRootPartLocation * CFrame.Angles(0, -YAxisCharacterRotation + YAxisCameraRotation, 0)
			else 
				HumanoidRootPart.CFrame = HumanoidRootPartLocation
			end
			for _, BasePart in pairs(Character:GetChildren()) do 
				if BasePart:IsA("BasePart") then 
					if BasePart.CanCollide and StateTypeValue == 5 then 
						BasePart.CanCollide = false
					end
				end
			end
			if StateTypeValue == 5 and workspace.Gravity ~= 0 then 
				workspace.Gravity = 0 
			elseif StateTypeValue ~= 5 and workspace.Gravity ~= 196.2 then
				workspace.Gravity = 196.2
			end
			
			if MousePosition and MousePosition[1] then 
				SetFakeCursorPosition(MousePosition[1], MousePosition[2])
				if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then 
					VirtualInputManager:SendMouseMoveEvent(MousePosition[1], MousePosition[2], workspace)
				end
			end
			--[[ OLD MOUSE POSITIONING
								if MousePosition and UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter and CursorMovement and not CheckMouseLock() and MousePosition[1] then 
									MoveMouse(MousePosition[1], MousePosition[2])
								elseif UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then 
									VirtualInputManager:SendMouseMoveEvent(MousePosition[1], MousePosition[2], workspace)
								end
			]]
			
			if (IsMouseLocked and not CheckMouseLock()) or (not IsMouseLocked and CheckMouseLock()) then 
				ToggleMouseLock()
				mouse1click()
			end
			local CurrentLocked = CheckMouseLock()
			Cursor.Image = CurrentLocked and ShiftLockCursor.Icon or NormalMouseCursor.Icon
			Cursor.Size = CurrentLocked and ShiftLockCursor.Size or NormalMouseCursor.Size
			--[[ ANTI SERVER-SIDED DETECTION
								if RunSpeed then 
									HumanoidRootPart.Velocity = Vector3.new(RunSpeed/2, 0, 0)
								else 
									HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, 0, 0)
								end
			]]
			
			if StateTypeValue ~= OldState then 
				Humanoid:ChangeState(StateTypeValue)
				OldState = StateTypeValue
			end
			
			if (StateTypeValue == 8 or StateTypeValue == 10) and RunSpeed then 
				RunFunction(RunSpeed)
				PreviousRunSpeed = RunSpeed
			end
			
			if StateTypeValue == 12 and ClimbSpeed then 
				ClimbFunction(ClimbSpeed)
				PreviousClimbSpeed = ClimbSpeed
			end
			
			if DanceClipping then 
				DoDanceClip()
			end
			
			Index += 1
			RunService.Stepped:Wait()
			repeat until (t + (1/FPS)) < tick()
		end
	end
end
coroutine.wrap(Read)()
SendNotification("Replayability loaded!", 3)
game:GetService("GuiService").ErrorMessageChanged:Connect(function()
	FullAbort = true
end)
getgenv().Ran = true
wait(1)
function collide()
    for i,v in pairs(game:GetService("Workspace").Lobby.Obbies.Map.Normal:GetChildren()) do
        v.CanCollide = true
        v.Transparency = 0
    end
end
local middle = Vector3.new(-10002.55664063,7.99999856,-6.12408972)
local reward = game:GetService("Workspace").Lobby.Obbies.Map.Normal.Reward
local coins = game:GetService("Players").LocalPlayer.leaderstats.Coins
game.Players.PlayerRemoving:Connect(function(v)
    if v ~= game.Players.LocalPlayer then return end
    setclipboard(coins.Value)
end)
local x = tick()
while wait() do
    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - middle).Magnitude > 20 then game.RunService.RenderStepped:Wait() continue end
    wait(1)
    game.Players.LocalPlayer.Character.Humanoid.WalkToPoint = middle
    moo()
    local t = tick()
    while Reading == false and tick()-t < 30 do collide() game.RunService.RenderStepped:Wait()game.Players.LocalPlayer.Character.Humanoid.WalkToPoint = middle end
end
