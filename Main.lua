-- main.lua — Muscle Legends Cyberpunk Hub by Bcm2007

-- Services
local Players       = game:GetService("Players")
local RS            = game:GetService("ReplicatedStorage")
local UIS           = game:GetService("UserInputService")
local TweenService  = game:GetService("TweenService")
local VirtualUser   = game:GetService("VirtualUser")

local player = Players.LocalPlayer

-- Helper: notification
local function Notify(msg, t)
    t = t or 2
    local gui = player:FindFirstChild("PlayerGui")
    local ng = gui:FindFirstChild("CyberNotifs") or Instance.new("ScreenGui", gui)
    ng.Name = "CyberNotifs"
    local frame = Instance.new("Frame", ng)
    frame.Size = UDim2.new(0, 260, 0, 38)
    frame.Position = UDim2.new(0.5, -130, 0.15, #ng:GetChildren()*45)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
    frame.BorderSizePixel = 0
    local cr = Instance.new("UICorner", frame); cr.CornerRadius = UDim.new(0,6)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -10, 1, -10); lbl.Position = UDim2.new(0,5,0,5)
    lbl.BackgroundTransparency = 1
    lbl.Text = msg; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(180,255,255)
    task.delay(t, function()
        for i=0,1,0.05 do
            frame.BackgroundTransparency = i
            lbl.TextTransparency = i
            task.wait(0.03)
        end
        frame:Destroy()
    end)
end

-- Build GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CyberHub"
gui.ResetOnSpawn = false

local win = Instance.new("Frame", gui)
win.Size = UDim2.new(0, 420, 0, 480)
win.Position = UDim2.new(0.5, -210, 0.5, -240)
win.BackgroundColor3 = Color3.fromRGB(10,10,15)
win.BorderSizePixel = 0
win.Active = true; win.Draggable = true
local winCr = Instance.new("UICorner", win); winCr.CornerRadius = UDim.new(0,12)
local shadow = Instance.new("ImageLabel", win)
shadow.Size = win.Size; shadow.Position = UDim2.new(0,6,0,6)
shadow.Image = "rbxassetid://7031086005"; shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49,49,450,450); shadow.ImageColor3 = Color3.new(0,0,0)
shadow.ImageTransparency = 0.8; shadow.ZIndex = 0

-- Header
local header = Instance.new("Frame", win)
header.Size = UDim2.new(1,0,0,48)
header.BackgroundColor3 = Color3.fromRGB(25,0,50)
local hCr = Instance.new("UICorner", header); hCr.CornerRadius = UDim.new(0,12)
local grad = Instance.new("UIGradient", header)
grad.Color = ColorSequence.new(Color3.fromRGB(150,0,255), Color3.fromRGB(50,0,150))
grad.Rotation = 90
local title = Instance.new("TextLabel", header)
title.Size, title.Position = UDim2.new(1,0,1,0), UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1; title.Text = "Cyber Legends Hub"
title.Font = Enum.Font.GothamBold; title.TextSize = 20; title.TextColor3 = Color3.fromRGB(200,255,255)
local close = Instance.new("TextButton", header)
close.Size, close.Position = UDim2.new(0,32,0,32), UDim2.new(1,-40,0,8)
close.BackgroundTransparency = 1; close.Text = "✕"; close.Font = Enum.Font.GothamBold
close.TextSize = 18; close.TextColor3 = Color3.fromRGB(255,100,100)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Tabs
local tabs = {"Auto","Farm","Misc","Stats"}
local pages, tabBtns = {}, {}
local tabBar = Instance.new("Frame", win)
tabBar.Size = UDim2.new(1,0,0,36); tabBar.Position = UDim2.new(0,0,0,48); tabBar.BackgroundTransparency = 1

for i,name in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(1/#tabs, -6, 1, -6)
    btn.Position = UDim2.new((i-1)/#tabs, 3, 0, 3)
    btn.BackgroundColor3 = Color3.fromRGB(30,0,60)
    btn.Font = Enum.Font.GothamBold; btn.Text = name; btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(180,255,255)
    local bCr = Instance.new("UICorner", btn); bCr.CornerRadius = UDim.new(0,8)
    tabBtns[name], pages[name] = btn, Instance.new("ScrollingFrame", win)
    pages[name].Size = UDim2.new(1,-20,1,-100); pages[name].Position = UDim2.new(0,10,0,92)
    pages[name].BackgroundTransparency = 1; pages[name].Visible = false
    pages[name].ScrollBarThickness = 6
    local layout = Instance.new("UIListLayout", pages[name])
    layout.Padding = UDim.new(0,8); layout.SortOrder = Enum.SortOrder.LayoutOrder

    btn.MouseButton1Click:Connect(function()
        for _,b in pairs(tabBtns) do
            TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(30,0,60)}):Play()
        end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(150,0,255)}):Play()
        for _,pg in pairs(pages) do pg.Visible = false end
        pages[name].Visible = true
    end)
end

-- Activate first tab
TweenService:Create(tabBtns["Auto"], TweenInfo.new(0), {BackgroundColor3=Color3.fromRGB(150,0,255)}):Play()
pages["Auto"].Visible = true

-- Toggle creator
local toggles = {}
local function MakeToggle(page, label, key, func)
    toggles[key] = false
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(1,0,0,32)
    btn.BackgroundColor3 = Color3.fromRGB(20,0,50)
    btn.Font = Enum.Font.Gotham; btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(180,255,255)
    btn.Text = label.." [OFF]"
    local cr = Instance.new("UICorner", btn); cr.CornerRadius = UDim.new(0,8)

    -- hover glow
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(40,0,80)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        local col = toggles[key] and Color3.fromRGB(100,0,200) or Color3.fromRGB(20,0,50)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3=col}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        toggles[key] = not toggles[key]
        local on = toggles[key]
        btn.Text = label.." ["..(on and "ON" or "OFF").."]"
        local col = on and Color3.fromRGB(100,0,200) or Color3.fromRGB(20,0,50)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3=col}):Play()
        Notify(label.." "..(on and "ENABLED" or "DISABLED"))

        if on then spawn(func) end
    end)
    return btn
end

-- Feature functions
local function f_Strength()
    local ev = RS:WaitForChild("TrainEvent")
    while toggles.strength do ev:FireServer(); task.wait(0.1) end
end
local function f_Punch()
    local ev = RS:WaitForChild("PunchRemote")
    while toggles.punch do ev:FireServer(); task.wait(0.1) end
end
local function f_Rock()
    local ev = RS:WaitForChild("RockRemote")
    while toggles.rock do ev:FireServer(); task.wait(0.1) end
end
local function f_Kill()
    local ev = RS:WaitForChild("DamageEvent")
    while toggles.kill do
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=player and pl.Character and pl.Character:FindFirstChild("Humanoid") then
                ev:FireServer(pl.Character.Humanoid)
            end
        end
        task.wait(0.5)
    end
end

local function f_Rebirth()
    local ev = RS:WaitForChild("RebirthEvent")
    while toggles.rebirth do ev:FireServer(); Notify("Reborn!"); task.wait(5) end
end
local function f_RebirthFast()
    local ev = RS:WaitForChild("RebirthEvent")
    while toggles.rebirthFast do ev:FireServer(); task.wait(0.2) end
end
local function f_Grind()
    local te = RS:WaitForChild("TrainEvent")
    local re = RS:WaitForChild("RebirthEvent")
    while toggles.grind do te:FireServer(); re:FireServer(); task.wait(0.1) end
end
local function f_Pet()
    local ev = RS:WaitForChild("buyEgg")
    while toggles.pet do ev:InvokeServer("Advanced Egg"); task.wait(2) end
end
local function f_Aura()
    local ev = RS:WaitForChild("buyAura")
    while toggles.aura do ev:FireServer(); task.wait(3) end
end
local function f_AFK()
    while toggles.afk do
        task.wait(60)
        VirtualUser:Button2Down(Vector2.new(),workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(),workspace.CurrentCamera.CFrame)
    end
end

-- Create toggles in pages
MakeToggle(pages["Auto"], "Auto Strength",   "strength",   f_Strength)
MakeToggle(pages["Auto"], "Auto Punch",      "punch",      f_Punch)
MakeToggle(pages["Auto"], "Auto Rock",       "rock",       f_Rock)
MakeToggle(pages["Auto"], "Auto Kill",       "kill",       f_Kill)

MakeToggle(pages["Farm"], "Auto Rebirth",     "rebirth",     f_Rebirth)
MakeToggle(pages["Farm"], "Fast Rebirth",     "rebirthFast", f_RebirthFast)
MakeToggle(pages["Farm"], "Fast Grind",       "grind",       f_Grind)

MakeToggle(pages["Misc"], "Auto Pet",        "pet",        f_Pet)
MakeToggle(pages["Misc"], "Auto Aura",       "aura",       f_Aura)
MakeToggle(pages["Misc"], "Anti AFK",        "afk",        f_AFK)

-- Stats tab: inputs
local stats = pages["Stats"]
local sBox = Instance.new("TextBox", stats)
sBox.Size = UDim2.new(1,0,0,32); sBox.PlaceholderText="WalkSpeed"; sBox.Text="100"
sBox.Font=Enum.Font.Gotham; sBox.TextSize=14; sBox.BackgroundColor3=Color3.fromRGB(20,0,50)
local jBox = sBox:Clone()
jBox.Parent = stats; jBox.PlaceholderText="JumpPower"; jBox.Text="100"; jBox.Position=UDim2.new(0,0,0,40)
local function applySJ()
    if player.Character then
        local h = player.Character:FindFirstChild("Humanoid")
        if h then
            h.WalkSpeed = tonumber(sBox.Text) or 100
            h.JumpPower = tonumber(jBox.Text) or 100
        end
    end
end
sBox.FocusLost:Connect(applySJ)
jBox.FocusLost:Connect(applySJ)
Players.LocalPlayer.CharacterAdded:Connect(function() task.wait(1) applySJ() end)

-- Fly
local flying = false
local function FlyLoop()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bg = Instance.new("BodyGyro", hrp); bg.P=9e4; bg.MaxTorque=Vector3.new(4e4,4e4,4e4)
    local bv = Instance.new("BodyVelocity", hrp); bv.MaxForce=Vector3.new(9e9,9e9,9e9)
    while flying and hrp.Parent do
        local vel = Vector3.new()
        local cam = workspace.CurrentCamera
        if UIS:IsKeyDown(Enum.KeyCode.W) then vel = cam.CFrame.LookVector*50 end
        if UIS:IsKeyDown(Enum.KeyCode.S) then vel = -cam.CFrame.LookVector*50 end
        if UIS:IsKeyDown(Enum.KeyCode.A) then vel = -cam.CFrame.RightVector*50 end
        if UIS:IsKeyDown(Enum.KeyCode.D) then vel = cam.CFrame.RightVector*50 end
        bv.Velocity, bg.CFrame = vel, cam.CFrame
        task.wait()
    end
    bg:Destroy(); bv:Destroy()
end
UIS.InputBegan:Connect(function(inp,g)
    if g then return end
    if inp.KeyCode==Enum.KeyCode.F then
        flying = not flying
        if player.Character then player.Character.Humanoid.PlatformStand = flying end
        if flying then spawn(FlyLoop) end
        Notify("Fly "..(flying and "ON" or "OFF"))
    end
end)

-- Done
Notify("Loaded CyberHub Premium!", 3)
