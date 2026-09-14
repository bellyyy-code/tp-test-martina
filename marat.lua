local Players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Variables
local autoJumpEnabled = false
local jumpInterval = 0.07 -- Set the interval to 0.07 seconds

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoJumpGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame for GUI
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.85, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Draggable = true
frame.Active = true
frame.Parent = screenGui

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "Auto Jump"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.Parent = frame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.8, 0, 0, 30)
toggleBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleBtn.Text = "Enable Auto Jump"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSans
toggleBtn.TextSize = 16
toggleBtn.Parent = frame

-- Interval Label
local intervalLabel = Instance.new("TextLabel")
intervalLabel.Size = UDim2.new(1, 0, 0, 30)
intervalLabel.Position = UDim2.new(0, 0, 0.4, 0)
intervalLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
intervalLabel.Text = "Jump Interval: " .. jumpInterval
intervalLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
intervalLabel.Font = Enum.Font.SourceSans
intervalLabel.TextSize = 14
intervalLabel.Parent = frame

-- Toggle Auto Jump Function
local function toggleAutoJump()
    autoJumpEnabled = not autoJumpEnabled
    toggleBtn.Text = autoJumpEnabled and "Disable Auto Jump" or "Enable Auto Jump"
    
    if autoJumpEnabled then
        while autoJumpEnabled do
            -- Wait for the specified interval and jump
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                humanoid.Jump = true -- Trigger the jump
            end
            wait(jumpInterval) -- Wait for the next interval before jumping again
        end
    end
end

-- Toggle Button Click Event
toggleBtn.MouseButton1Click:Connect(toggleAutoJump)
