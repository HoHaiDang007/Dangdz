-- main.lua — Muscle Legends Premium Hub v2 by Bcm2007

-- Services local Players      = game:GetService("Players") local RS           = game:GetService("ReplicatedStorage") local UIS          = game:GetService("UserInputService") local TweenService = game:GetService("TweenService") local VirtualUser  = game:GetService("VirtualUser")

local player = Players.LocalPlayer

-- ===== Helpers ===== local function createNotification(text, duration) local notifGui = player:FindFirstChild("PlayerGui"):FindFirstChild("Notifications") if not notifGui then notifGui = Instance.new("ScreenGui", player.PlayerGui) notifGui.Name = "Notifications" end local frame = Instance.new("Frame", notifGui) frame.Size = UDim2.new(0,250,0,50) frame.Position = UDim2.new(0.5, -125, 0.2, (#notifGui:GetChildren()-1)*55) frame.BackgroundColor3 = Color3.fromRGB(30,30,40) frame.BackgroundTransparency = 0.1 frame.BorderSizePixel = 0 frame.ZIndex = 10 local corner = Instance.new("UICorner", frame) corner.CornerRadius = UDim.new(0, 12)

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, -20, 1, -20)
label.Position = UDim2.new(0, 10, 0, 10)
label.BackgroundTransparency = 1
label.Text = text
label.TextColor3 = Color3.fromRGB(255,255,255)
label.Font = Enum.Font.GothamSemibold
label.TextSize = 16
label.TextWrapped = true
label.ZIndex = 11

delay(duration or 2, function()
    for i = 1, 20 do
        frame.BackgroundTransparency = frame.BackgroundTransparency + 0.045
        label.TextTransparency = label.TextTransparency + 0.05
        wait(0.03)
    end
    frame:Destroy()
end)

end

-- ===== Main UI ===== local gui = Instance.new("ScreenGui", player.PlayerGui) gui.Name = "MLPremiumHubV2" gui.ResetOnSpawn = false

-- Background Blur local blurFrame = Instance.new("Frame", gui) blurFrame.Size = UDim2.new(1,0,1,0) blurFrame.BackgroundTransparency = 0.7 blurFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)

-- Window local window = Instance.new("Frame", gui) window.Size = UDim2.new(0, 400, 0, 460) window.Position = UDim2.new(0.5, -200, 0.5, -230) window.BackgroundColor3 = Color3.fromRGB(20,20,25) window.BorderSizePixel = 0 window.Active = true window.Draggable = true local winCorner = Instance.new("UICorner", window) winCorner.CornerRadius = UDim.new(0, 14)

-- Shadow local shadow = Instance.new("ImageLabel", window) shadow.Size = window.Size shadow.Position = UDim2.new(0,4,0,4) shadow.Image = "rbxassetid://7031086005" shadow.ScaleType = Enum.ScaleType.Slice shadow.SliceCenter = Rect.new(49,49,450,450) shadow.ImageColor3 = Color3.fromRGB(0,0,0) shadow.ImageTransparency = 0.85 shadow.ZIndex = 0

-- Header local header = Instance.new("Frame", window) header.Size = UDim2.new(1,0,0,50) header.BackgroundColor3 = Color3.fromRGB(40,0,80) local hdrCorner = Instance.new("UICorner", header) hdrCorner.CornerRadius = UDim.new(0,14)

local headerGradient = Instance.new("UIGradient", header) headerGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(120,0,200)), ColorSequenceKeypoint.new(1, Color3.fromRGB(60,0,150)) }) headerGradient.Rotation = 90

local title = Instance.new("TextLabel", header) title.Size = UDim2.new(1,0,1,0) title.BackgroundTransparency = 1 title.Text = "Muscle Legends Hub" title.Font = Enum.Font.GothamBold title.TextSize = 20 title.TextColor3 = Color3.new(1,1,1) title.ZIndex = 1

local closeBtn = Instance.new("TextButton", header) closeBtn.Size = UDim2.new(0,30,0,30) closeBtn.Position = UDim2.new(1,-35,0,10) closeBtn.BackgroundTransparency = 1 closeBtn.Text = "✕" closeBtn.Font = Enum.Font.GothamBold closeBtn.TextSize = 18 closeBtn.TextColor3 = Color3.fromRGB(255,150,150) closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Tab Bar local tabBar = Instance.new("Frame", window) tabBar.Size = UDim2.new(1,0,0,40) tabBar.Position = UDim2.new(0,0,0,50) tabBar.BackgroundTransparency = 1

local pages = {} local tabButtons = {} local tabs = {"Auto","Farm","Misc","Stats"}

-- Content Area local content = Instance.new("Frame", window) content.Size = UDim2.new(1,-20,1,-110) content.Position = UDim2.new(0,10,0,100) content.BackgroundTransparency = 1

for i, name in ipairs(tabs) do -- Tab Button local btn = Instance.new("TextButton", tabBar) btn.Size = UDim2.new(1/#tabs, -6, 1, -6) btn.Position = UDim2.new((i-1)/#tabs, 3, 0, 3) btn.BackgroundColor3 = Color3.fromRGB(30,0,60) btn.Font = Enum.Font.GothamBold btn.Text = name btn.TextSize = 15 btn.TextColor3 = Color3.new(1,1,1) local btnCr = Instance.new("UICorner", btn) btnCr.CornerRadius = UDim.new(0,8) tabButtons[name] = btn

-- Page
local page = Instance.new("ScrollingFrame", content)
page.Name = name.."Page"
page.Size = UDim2.new(1,0,1,0)
page.CanvasSize = UDim2.new(0,0,2,0)
page.ScrollBarThickness = 6
page.BackgroundTransparency = 1
page.Visible = false
local layout = Instance.new("UIListLayout", page)
layout.Padding = UDim.new(0,6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
pages[name] = page

-- Tab Click
btn.MouseButton1Click:Connect(function()
    for _, b in pairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(30,0,60) end
    btn.BackgroundColor3 = Color3.fromRGB(120,0,200)
    for _, pg in pairs(pages) do pg.Visible = false end
    page.Visible = true
end)

end

-- Activate first tabButtons["Auto"].BackgroundColor3 = Color3.fromRGB(120,0,200) pages["Auto"].Visible = true

-- Toggle Creator local toggles = {} local function makeToggle(page, label, key, action) toggles[key] = false local btn = Instance.new("TextButton", page) btn.Size = UDim2.new(1,0,0,32) btn.BackgroundColor3 = Color3.fromRGB(25,0,50) btn.Font = Enum.Font.Gotham btn.TextSize = 14 btn.Text = label.." [OFF]" btn.TextColor3 = Color3.fromRGB(200,200,255) local cr = Instance.new("UICorner", btn) cr.CornerRadius = UDim.new(0,8)

btn.MouseButton1Click:Connect(function()
    toggles[key] = not toggles[key]
    btn.Text = label.." ["..(toggles[key] and "ON" or "OFF").."]"
    local col = toggles[key] and Color3.fromRGB(130,0,220) or Color3.fromRGB(25,0,50)
    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = col}):Play()
    createNotification(label..(toggles[key] and " Enabled" or " Disabled"))
    if toggles[key] then spawn(action) end
end)
return btn

end

-- Feature Actions local function autoStrength() local ev=RS:WaitForChild("TrainEvent") while toggles.strength do ev:FireServer() task.wait(0.1) end end local function autoPunch()   local ev=RS:WaitForChild("PunchRemote") while toggles.punch    do ev:FireServer() task.wait(0.1) end end local function autoRock()    local ev=RS:WaitForChild("RockRemote") while toggles.rock     do ev:FireServer() task.wait(0.1) end end local function autoKill()    local ev=RS:WaitForChild("DamageEvent") while toggles.kill     do for _,pl in pairs(Players:GetPlayers()) do if pl~=player and pl.Character and pl.Character:FindFirstChild("Humanoid") then ev:FireServer(pl.Character.Humanoid) end end task.wait(0.5) end end local function autoRebirth() local ev=RS:WaitForChild("RebirthEvent") while toggles.rebirth  do ev:FireServer() createNotification("Reborn!") task.wait(5) end end local function fastRebirth() local ev=RS:WaitForChild("RebirthEvent") while toggles.rebirthFast do ev:FireServer() task.wait(0.2) end end local function autoPet()     local ev=RS:WaitForChild("buyEgg") while toggles.pet      do ev:InvokeServer("Advanced Egg") task.wait(2) end end local function autoAura()    local ev=RS:WaitForChild("buyAura") while toggles.aura     do ev:FireServer() task.wait(3) end end local function antiAfk()     while toggles.afk do task.wait(60) VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame) task.wait(1) VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame) end end

-- Create Toggles makeToggle(pages["Auto"], "Auto Strength", "strength", autoStrength) makeToggle(pages["Auto"], "Auto Punch",    "punch",    autoPunch) makeToggle(pages["Auto"], "Auto Rock",     "rock",     autoRock) makeToggle(pages["Auto"], "Auto Kill",     "kill",     autoKill) makeToggle(pages["Farm"], "Auto Rebirth", "rebirth",  autoRebirth) makeToggle(pages["Farm"], "Fast Rebirth", "rebirthFast", fastRebirth) makeToggle(pages["Misc"], "Auto Pet",     "pet",      autoPet) makeToggle(pages["Misc"], "Auto Aura",    "aura",     autoAura) makeToggle(pages["Misc"], "Anti AFK",     "afk",      antiAfk)

-- Stats Page Inputs local stats = pages["Stats"] local speedBox = Instance.new("TextBox", stats) speedBox.Size = UDim2.new(1,0,0,32); speedBox.PlaceholderText="WalkSpeed"; speedBox.Text="100"; speedBox.Font=Enum.Font.Gotham; speedBox.TextSize=14; speedBox.BackgroundColor3=Color3.fromRGB(25,0,50) local jumpBox = speedBox:Clone(); jumpBox.Parent=stats; jumpBox.Position=UDim2.new(0,0,0,40); jumpBox.PlaceholderText="JumpPower"; jumpBox.Text="100" local function applyStats() if player.Character then local h=player.Character:FindFirstChild("Humanoid") if h then h.WalkSpeed=tonumber(speedBox.Text) or 16; h.JumpPower=tonumber(jumpBox.Text) or 50 end end end speedBox.FocusLost:Connect(applyStats); jumpBox.FocusLost:Connect(applyStats); Players.LocalPlayer.CharacterAdded:Connect(function() task.wait(1) applyStats() end)

-- Fly Hotkey local flying=false UIS.InputBegan:Connect(function(input, gp) if gp then return end if input.KeyCode==Enum.KeyCode.F then flying = not flying if player.Character then player.Character.Humanoid.PlatformStand = flying end if flying then spawn(function() local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart") local bg = Instance.new("BodyGyro", hrp); bg.P=9e4; bg.MaxTorque=Vector3.new(4e4,4e4,4e4) local bv = Instance.new("BodyVelocity", hrp); bv.MaxForce=Vector3.new(9e9,9e9,9e9) while flying and hrp.Parent do local vel=Vector3.new(); local cam=workspace.CurrentCamera if UIS:IsKeyDown(Enum.KeyCode.W) then vel=cam.CFrame.LookVector50 end if UIS:IsKeyDown(Enum.KeyCode.S) then vel=-cam.CFrame.LookVector50 end if UIS:IsKeyDown(Enum.KeyCode.A) then vel=-cam.CFrame.RightVector50 end if UIS:IsKeyDown(Enum.KeyCode.D) then vel=cam.CFrame.RightVector50 end bv.Velocity, bg.CFrame = vel, cam.CFrame; task.wait() end; bg:Destroy(); bv:Destroy() end) end createNotification("Fly "..(flying and "ON" or "OFF")) end end)

-- Done createNotification("Cyber Legends Hub Loaded!", 3)

