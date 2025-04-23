local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local ESPEnabled = false
local SpeedHackEnabled = false
local FlyHackEnabled = false
local BaseSpeed = 16
local SpeedhackValue = 35
local CheatActive = true
local GUIShown = true
local Velocity = Vector3.new(0, 0, 0)
local FlySpeed = 30
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui
local Highlights = {}
local WallhackColors = {
    Color3.new(1, 0, 0),
    Color3.new(0, 1, 0),
    Color3.new(0, 0, 1),
    Color3.new(1, 1, 0),
    Color3.new(1, 0, 1),
}
local CurrentColorIndex = 1

local function CreateGUI()
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.ClipsDescendants = true
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = 0})
    tween:Play()
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 280, 0, 40)
    TitleLabel.Position = UDim2.new(0, 10, 0, 10)
    TitleLabel.Text = "SYNDICATE DYNASTY"
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 24
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextStrokeTransparency = 0.5
    TitleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    TitleLabel.Parent = MainFrame
    coroutine.wrap(function()
        while CheatActive and TitleLabel do
            for i = 0, 1, 0.01 do
                if not TitleLabel then return end
                TitleLabel.TextColor3 = Color3.fromHSV(i, 1, 1)
                wait(0.01)
            end
        end
    end)()
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(0, 280, 0, 60)
    InfoLabel.Position = UDim2.new(0, 10, 0, 370)
    InfoLabel.Text = "Чтобы сменить цвет Wallhack нажми на V"
    InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoLabel.Font = Enum.Font.GothamBold
    InfoLabel.TextSize = 14
    InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Parent = MainFrame
    local WallhackStatus = Instance.new("TextLabel")
    WallhackStatus.Name = "WallhackStatus"
    WallhackStatus.Size = UDim2.new(0, 280, 0, 30)
    WallhackStatus.Position = UDim2.new(0, 10, 0, 60)
    WallhackStatus.Text = "Wallhack [Z]: ВЫКЛ"
    WallhackStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
    WallhackStatus.Font = Enum.Font.GothamBold
    WallhackStatus.TextSize = 18
    WallhackStatus.BackgroundTransparency = 1
    WallhackStatus.Parent = MainFrame
    local SpeedhackStatus = Instance.new("TextLabel")
    SpeedhackStatus.Name = "SpeedhackStatus"
    SpeedhackStatus.Size = UDim2.new(0, 280, 0, 30)
    SpeedhackStatus.Position = UDim2.new(0, 10, 0, 95)
    SpeedhackStatus.Text = "Speedhack [X]: ВЫКЛ"
    SpeedhackStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
    SpeedhackStatus.Font = Enum.Font.GothamBold
    SpeedhackStatus.TextSize = 18
    SpeedhackStatus.BackgroundTransparency = 1
    SpeedhackStatus.Parent = MainFrame
    local FlyhackStatus = Instance.new("TextLabel")
    FlyhackStatus.Name = "FlyhackStatus"
    FlyhackStatus.Size = UDim2.new(0, 280, 0, 30)
    FlyhackStatus.Position = UDim2.new(0, 10, 0, 130)
    FlyhackStatus.Text = "Flyhack [C]: ВЫКЛ"
    FlyhackStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
    FlyhackStatus.Font = Enum.Font.GothamBold
    FlyhackStatus.TextSize = 18
    FlyhackStatus.BackgroundTransparency = 1
    FlyhackStatus.Parent = MainFrame
end

local function ESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            if ESPEnabled and CheatActive then
                if Highlights[player] and Highlights[player].Parent == character then
                    continue
                end
                local highlight = Instance.new("Highlight")
                highlight.Adornee = character
                highlight.FillColor = WallhackColors[CurrentColorIndex]
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.OutlineTransparency = 0
                highlight.Parent = character
                Highlights[player] = highlight
            else
                if Highlights[player] and Highlights[player].Parent then
                    Highlights[player]:Destroy()
                    Highlights[player] = nil
                end
            end
        end
    end
end

local function FlyHack()
    if FlyHackEnabled and LocalPlayer.Character then
        local char = LocalPlayer.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        RunService.Stepped:Connect(function()
            if not FlyHackEnabled or not root or not root.Parent then
                Velocity = Vector3.new(0, 0, 0)
                return
            end
            root.Velocity = Velocity
        end)
        UserInputService.InputBegan:Connect(function(input)
            if not FlyHackEnabled or not root or not root.Parent then return end
            if input.KeyCode == Enum.KeyCode.W then
                Velocity = root.CFrame.lookVector * FlySpeed
            elseif input.KeyCode == Enum.KeyCode.S then
                Velocity = -root.CFrame.lookVector * FlySpeed
            elseif input.KeyCode == Enum.KeyCode.A then
                Velocity = -root.CFrame.rightVector * FlySpeed
            elseif input.KeyCode == Enum.KeyCode.D then
                Velocity = root.CFrame.rightVector * FlySpeed
            elseif input.KeyCode == Enum.KeyCode.Space then
                Velocity = Vector3.new(0, FlySpeed, 0)
            elseif input.KeyCode == Enum.KeyCode.LeftShift then
                Velocity = Vector3.new(0, -FlySpeed, 0)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if not FlyHackEnabled or not root or not root.Parent then return end
            if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D or input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then
                Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end
end

UserInputService.InputBegan:Connect(function(input)
    if not CheatActive then return end
    if input.KeyCode == Enum.KeyCode.Z then
        ESPEnabled = not ESPEnabled
        local mainFrame = ScreenGui:FindFirstChild("MainFrame")
        if mainFrame then
            local statusLabel = mainFrame:FindFirstChild("WallhackStatus")
            if statusLabel then
                statusLabel.Text = "Wallhack [Z]: " .. (ESPEnabled and "ВКЛ" or "ВЫКЛ")
                statusLabel.TextColor3 = ESPEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            end
        end
        ESP()
    elseif input.KeyCode == Enum.KeyCode.X then
        SpeedHackEnabled = not SpeedHackEnabled
        local mainFrame = ScreenGui:FindFirstChild("MainFrame")
        if mainFrame then
            local statusLabel = mainFrame:FindFirstChild("SpeedhackStatus")
            if statusLabel then
                statusLabel.Text = "Speedhack [X]: " .. (SpeedHackEnabled and "ВКЛ" or "ВЫКЛ")
                statusLabel.TextColor3 = SpeedHackEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            end
        end
    elseif input.KeyCode == Enum.KeyCode.C then
        FlyHackEnabled = not FlyHackEnabled
        local mainFrame = ScreenGui:FindFirstChild("MainFrame")
        if mainFrame then
            local statusLabel = mainFrame:FindFirstChild("FlyhackStatus")
            if statusLabel then
                statusLabel.Text = "Flyhack [C]: " .. (FlyHackEnabled and "ВКЛ" or "ВЫКЛ")
                statusLabel.TextColor3 = FlyHackEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            end
        end
        FlyHack()
    elseif input.KeyCode == Enum.KeyCode.V and ESPEnabled then
        CurrentColorIndex = CurrentColorIndex + 1
        if CurrentColorIndex > #WallhackColors then
            CurrentColorIndex = 1
        end
        for _, highlight in pairs(Highlights) do
            if highlight and highlight.Parent then
                highlight.FillColor = WallhackColors[CurrentColorIndex]
            end
        end
    elseif input.KeyCode == Enum.KeyCode.Insert then
        GUIShown = not GUIShown
        local mainFrame = ScreenGui:FindFirstChild("MainFrame")
        if mainFrame then
            mainFrame.Visible = GUIShown
        end
    elseif input.KeyCode == Enum.KeyCode.Home then
        if ScreenGui then
            ScreenGui:Destroy()
            ScreenGui = nil
        end
        CheatActive = false
        ESPEnabled = false
        SpeedHackEnabled = false
        FlyHackEnabled = false
        for player, highlight in pairs(Highlights) do
            if highlight and highlight.Parent then
                highlight:Destroy()
            end
            Highlights[player] = nil
        end
    end
end)

local function NewSpeedHack()
    if not SpeedHackEnabled then return end
    local Character = LocalPlayer.Character
    if not Character then return end
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not HumanoidRootPart or not Humanoid then return end
    workspace.Gravity = 196.2
    if SpeedHackEnabled then
        workspace.Gravity = 70
        RunService.Stepped:Connect(function()
            if SpeedHackEnabled and HumanoidRootPart then
                local lookDirection = HumanoidRootPart.CFrame.lookVector
                local movement = Vector3.new(lookDirection.X, 0, lookDirection.Z).Unit * SpeedhackValue
                HumanoidRootPart.Velocity = Vector3.new(movement.X, HumanoidRootPart.Velocity.Y, movement.Z)
            end
        end)
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
        local speedTween = TweenService:Create(Humanoid, tweenInfo, {WalkSpeed = SpeedhackValue})
        speedTween:Play()
    else
        workspace.Gravity = 196.2
        Humanoid.WalkSpeed = BaseSpeed
    end
end

RunService.Stepped:Connect(function()
    if CheatActive then
        NewSpeedHack()
    end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.WalkSpeed = SpeedHackEnabled and SpeedhackValue or BaseSpeed
    end
end)

if game.PlaceId == 142823291 then
    while wait() do
        if LocalPlayer.Character and SpeedHackEnabled then
            local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.CFrame = rootPart.CFrame + rootPart.CFrame.lookVector * (SpeedhackValue/10)
                rootPart.Velocity = Vector3.new(rootPart.Velocity.X, 0, rootPart.Velocity.Z) * 1.5
                rootPart.AssemblyLinearVelocity = Vector3.new(rootPart.AssemblyLinearVelocity.X, 0, rootPart.AssemblyLinearVelocity.Z) * 1.5
            end
        end
    end
end

CreateGUI()
ESP()