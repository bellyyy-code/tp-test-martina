local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Wait a moment to ensure StarterGui is ready
task.wait(1)

-- Safely send purple chat message
local StarterGui = game:GetService("StarterGui")
pcall(function()
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "Thanks for using script! Credit ThatBoiledOne on YT if you wanna showcase. Have fun!";
        Color = Color3.fromRGB(170, 0, 255); -- Purple color
        Font = Enum.Font.SourceSansBold;
        TextSize = 18;
    })
end)

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "TPGui"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 350)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.ClipsDescendants = true
MainFrame.BackgroundTransparency = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Name = "MainFrame"

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "🚀 TP GUI v1"
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true

local PlayerListFrame = Instance.new("ScrollingFrame", MainFrame)
PlayerListFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
PlayerListFrame.Position = UDim2.new(0.05, 0, 0.18, 0)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListFrame.ScrollBarThickness = 8

local UICorner2 = Instance.new("UICorner", PlayerListFrame)
UICorner2.CornerRadius = UDim.new(0, 8)

local UIListLayout = Instance.new("UIListLayout", PlayerListFrame)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

local TeleportButton = Instance.new("TextButton", MainFrame)
TeleportButton.Size = UDim2.new(0.8, 0, 0.1, 0)
TeleportButton.Position = UDim2.new(0.1, 0, 0.85, 0)
TeleportButton.Text = "Teleport to Selected Player"
TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.Font = Enum.Font.GothamSemibold
TeleportButton.TextScaled = true

local UICorner3 = Instance.new("UICorner", TeleportButton)
UICorner3.CornerRadius = UDim.new(0, 8)

local SelectedPlayer = nil

-- Populate player list
local function RefreshPlayerList()
    for _, child in ipairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerButton = Instance.new("TextButton", PlayerListFrame)
            PlayerButton.Size = UDim2.new(1, -10, 0, 40)
            PlayerButton.Text = player.Name
            PlayerButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
            PlayerButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            PlayerButton.Font = Enum.Font.Gotham
            PlayerButton.TextScaled = true
            PlayerButton.BorderSizePixel = 0

            local btnCorner = Instance.new("UICorner", PlayerButton)
            btnCorner.CornerRadius = UDim.new(0, 6)

            PlayerButton.MouseButton1Click:Connect(function()
                -- Unhighlight others
                for _, other in ipairs(PlayerListFrame:GetChildren()) do
                    if other:IsA("TextButton") then
                        other.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                    end
                end
                PlayerButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                SelectedPlayer = player
            end)
        end
    end

    -- Update scroll size
    task.wait(0.1)
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end

RefreshPlayerList()

Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(RefreshPlayerList)

TeleportButton.MouseButton1Click:Connect(function()
    if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 2)
        end
    end
end)
