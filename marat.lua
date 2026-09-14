local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local VERSION = "v2.5"

-- Настройки (Config)
local Config = {
    Aimbot = false,
    AimbotKey = Enum.UserInputType.MouseButton2, -- ПКМ
    AimbotSmooth = 5,
    BoxESP = false,
    SkeletonESP = false,
    Fullbright = false
}

-- Главный GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScriptSenseMainGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 360)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BackgroundTransparency = 1
MainFrame.Parent = ScreenGui

-- Анимация появления (Fade-in)
TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.05}):Play()

-- Заголовок с анимированным текстом
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -35, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SCRIPTSENSE [" .. VERSION .. "]"
Title.TextColor3 = Color3.fromRGB(255, 60, 60)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Эффект переливания цвета заголовка
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            Title.TextColor3 = Color3.fromHSV(i, 0.8, 1)
            task.wait(0.05)
        end
    end
end)

local CloseButton = Instance.new("TextButton")
CloseButton.Position = UDim2.new(1, -35, 0, 0)
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 16
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Контейнер опций
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 42)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 4
Container.CanvasSize = UDim2.new(0, 0, 0, 280)
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Container

-- Функция создания кнопки-тогла
local function CreateToggle(name, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, 0, 0, 40)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Text = name .. ": OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Font = Enum.Font.SourceSansBold
    ToggleBtn.TextSize = 15
    ToggleBtn.Parent = Container

    local state = false
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            ToggleBtn.Text = name .. ": ON"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        else
            ToggleBtn.Text = name .. ": OFF"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end
        callback(state)
    end)
end

-- Создание функционала в меню
CreateToggle("Aimbot", function(state)
    Config.Aimbot = state
end)

CreateToggle("White Box ESP", function(state)
    Config.BoxESP = state
end)

CreateToggle("White Skeleton ESP", function(state)
    Config.SkeletonESP = state
end)

CreateToggle("Fullbright", function(state)
    Config.Fullbright = state
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    else
        Lighting.GlobalShadows = true
    end
end)

-- Поиск ближайшего игрока для Aimbot
local function GetClosestPlayer()
    local target = nil
    local shortestDist = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
            local rootPart = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    target = player.Character.HumanoidRootPart
                end
            end
        end
    end
    return target
end

-- Логика Aimbot
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Config.AimbotKey then
        Config.AimbotHolding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Config.AimbotKey then
        Config.AimbotHolding = false
    end
end)

RunService.RenderStepped:Connect(function()
    if Config.Aimbot and Config.AimbotHolding then
        local targetRoot = GetClosestPlayer()
        if targetRoot then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetRoot.Position)
        end
    end
    
    -- Белый Box ESP в реальном времени
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            if root and Config.BoxESP then
                if not char:FindFirstChild("ScriptSenseBox") then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "ScriptSenseBox"
                    box.Adornee = root
                    box.AlwaysOnTop = true
                    box.Size = Vector3.new(3, 5, 3)
                    box.Color3 = Color3.fromRGB(255, 255, 255)
                    box.Transparency = 0.5
                    box.Parent = char
                end
            else
                local box = char:FindFirstChild("ScriptSenseBox")
                if box then box:Destroy() end
            end
        end
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ScriptSense",
    Text = "Loaded Successfully " .. VERSION,
    Duration = 3
})
