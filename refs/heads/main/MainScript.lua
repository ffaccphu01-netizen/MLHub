--[[
    SURVIVAL THE APOCALYPSE - Script cho Delta Mobile
    Tác giả: MinhLoi
    Phiên bản: 1.0
]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")

-- Tạo GUI chính
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:PlayerGui
screenGui.Name = "ApocalypseHub"
screenGui.ResetOnSpawn = false

-- Khung chính - Tối ưu cho mobile
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 380)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Bo góc cho khung
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Text = "🌟 APOCALYPSE HUB 🌟"
title.TextColor3 = Color3.fromRGB(255, 140, 0)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- Nút đóng
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 15)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Hàm tạo nút toggle đẹp
local function createToggle(name, yPos, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.88, 0, 0, 35)
    button.Position = UDim2.new(0.06, 0, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    button.Text = name .. ": TẮT"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.Parent = mainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(255, 100, 100)
    stroke.Parent = button
    
    local enabled = false
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            button.Text = name .. ": BẬT"
            stroke.Color = Color3.fromRGB(100, 255, 100)
        else
            button.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            button.Text = name .. ": TẮT"
            stroke.Color = Color3.fromRGB(255, 100, 100)
        end
        callback(enabled)
    end)
end

-- Nút MENU di động
local menuBtn = Instance.new("TextButton")
menuBtn.Size = UDim2.new(0, 55, 0, 55)
menuBtn.Position = UDim2.new(0, 15, 0, 15)
menuBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
menuBtn.Text = "APO"
menuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
menuBtn.TextSize = 12
menuBtn.Font = Enum.Font.GothamBlack
menuBtn.Parent = screenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 27)
menuCorner.Parent = menuBtn

local menuStroke = Instance.new("UIStroke")
menuStroke.Thickness = 2
menuStroke.Color = Color3.fromRGB(255, 150, 50)
menuStroke.Parent = menuBtn

menuBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- ================== TÍNH NĂNG ==================

-- 1. Auto Farm Zombie
createToggle("🤖 Auto Farm", 50, function(on)
    task.spawn(function()
        while on and player.Character do
            pcall(function()
                local target = nil
                local minDist = 60
                
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= character then
                        if obj.Humanoid.Health > 0 then
                            local dist = (rootPart.Position - obj:GetPivot().Position).Magnitude
                            if dist < minDist then
                                minDist = dist
                                target = obj
                            end
                        end
                    end
                end
                
                if target and target:FindFirstChild("HumanoidRootPart") then
                    humanoid:MoveTo(target.HumanoidRootPart.Position)
                    -- Trang bị vũ khí
                    for _, tool in pairs(player.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                            tool.Parent = character
                            tool:Activate()
                            break
                        end
                    end
                    -- Đánh tay không nếu không có vũ khí
                    if #player.Backpack:GetChildren() == 0 then
                        local args = {
                            [1] = "Swing",
                            [2] = "Melee"
                        }
                        pcall(function()
                            game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FindFirstChild("Melee"):FireServer(unpack(args))
                        end)
                    end
                end
            end)
            task.wait(0.15)
        end
    end)
end)

-- 2. God Mode
local godConnection
createToggle("🛡️ Bất Tử", 92, function(on)
    if on then
        humanoid.MaxHealth = 9e9
        humanoid.Health = 9e9
        godConnection = humanoid.HealthChanged:Connect(function()
            if humanoid.Health < 9e9 then
                humanoid.Health = 9e9
            end
        end)
    else
        if godConnection then godConnection:Disconnect() end
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    end
end)

-- 3. ESP
local espObjects = {}
createToggle("👁️ ESP", 134, function(on)
    task.spawn(function()
        while on do
            pcall(function()
                for _, esp in pairs(espObjects) do esp:Destroy() end
                espObjects = {}
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") and obj ~= character then
                        local hl = Instance.new("Highlight")
                        hl.Parent = obj
                        hl.FillTransparency = 0.4
                        hl.OutlineTransparency = 0.2
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        if obj.Humanoid.Health > 0 then
                            hl.FillColor = Color3.fromRGB(255, 30, 30)
                            hl.OutlineColor = Color3.fromRGB(255, 100, 100)
                        end
                        table.insert(espObjects, hl)
                    end
                end
            end)
            task.wait(1.5)
        end
        for _, esp in pairs(espObjects) do esp:Destroy() end
    end)
end)

-- 4. Tốc độ
createToggle("⚡ Tốc Độ X2", 176, function(on)
    humanoid.WalkSpeed = on and 32 or 16
end)

-- 5. Nhảy vô hạn
local jumpConn
createToggle("🦘 Nhảy Vô Hạn", 218, function(on)
    if on then
        jumpConn = UIS.JumpRequest:Connect(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    else
        if jumpConn then jumpConn:Disconnect() end
    end
end)

-- 6. Kill Aura
createToggle("💀 Kill Aura", 260, function(on)
    task.spawn(function()
        while on and player.Character do
            pcall(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= character then
                        if obj.Humanoid.Health > 0 then
                            local root = obj:FindFirstChild("HumanoidRootPart")
                            if root and (rootPart.Position - root.Position).Magnitude < 15 then
                                obj.Humanoid:TakeDamage(30)
                            end
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- 7. Bay
createToggle("🕊️ Bay", 302, function(on)
    if on then
        humanoid.PlatformStand = true
        local flyBody = Instance.new("BodyVelocity")
        flyBody.Velocity = Vector3.new(0, 0, 0)
        flyBody.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBody.Parent = rootPart
        
        task.spawn(function()
            while on and player.Character do
                flyBody.Velocity = Vector3.new(0, UIS:IsKeyDown(Enum.KeyCode.Space) and 50 or 0, 0)
                task.wait(0.05)
            end
            flyBody:Destroy()
            humanoid.PlatformStand = false
        end)
    else
        humanoid.PlatformStand = false
        if rootPart:FindFirstChild("BodyVelocity") then
            rootPart.BodyVelocity:Destroy()
        end
    end
end)

-- Thông tin
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0.88, 0, 0, 30)
infoLabel.Position = UDim2.new(0.06, 0, 0, 345)
infoLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
infoLabel.Text = "✅ Apocalypse Hub v2.0"
infoLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
infoLabel.TextSize = 12
infoLabel.Font = Enum.Font.GothamMedium
infoLabel.Parent = mainFrame

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoLabel

-- Tự động cập nhật character khi respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end)

print("✅ Apocalypse Hub loaded successfully!")
print("📱 Optimized for Mobile - Delta Executor")
