local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create a ScreenGui for the player list
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- Create a ScrollingFrame to hold the player usernames (scrollable frame)
local userFrame = Instance.new("ScrollingFrame")
userFrame.Size = UDim2.new(0, 300, 0, 400)
userFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
userFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black background
userFrame.BackgroundTransparency = 0.5 -- Semi-transparent background
userFrame.BorderSizePixel = 0 -- No border
userFrame.ScrollBarThickness = 10 -- Thickness of the scrollbar
userFrame.Visible = true
userFrame.Parent = screenGui
userFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- We'll adjust this dynamically

-- Create a UIListLayout to arrange player usernames vertically in the scrollable frame
local listLayout = Instance.new("UIListLayout")
listLayout.Parent = userFrame

-- Function to populate usernames
local function populateUsernames()
    -- Clear any existing buttons before populating
    for _, child in ipairs(userFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    -- Create a button for each player
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then -- Don't include yourself
            local playerButton = Instance.new("TextButton")
            playerButton.Size = UDim2.new(1, 0, 0, 50) -- Full width, 50 height
            playerButton.Text = otherPlayer.Name
            playerButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
            playerButton.BackgroundTransparency = 1 -- Fully transparent background
            playerButton.BorderSizePixel = 0 -- No border
            playerButton.Parent = userFrame

            -- Teleport to the player when clicked
            playerButton.MouseButton1Click:Connect(function()
                if otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character:MoveTo(otherPlayer.Character.HumanoidRootPart.Position) -- Teleport to the player
                end
            end)
        end
    end

    -- Adjust the canvas size of the scrollable frame based on the number of players
    userFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end

-- Populate usernames initially
populateUsernames()

-- Update usernames when a player joins or leaves
Players.PlayerAdded:Connect(function()
    wait(0.1) -- Wait a moment for the new player to fully join
    populateUsernames()
end)

Players.PlayerRemoving:Connect(function()
    wait(0.1) -- Wait a moment for the player to leave
    populateUsernames()
end)

-- Create a ScreenGui for the control buttons (exit and open)
local controlGui = Instance.new("ScreenGui")
controlGui.Parent = playerGui

-- Create the "Open" button
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 100, 0, 50)
openButton.Position = UDim2.new(0, 10, 0, 10) -- Top left corner
openButton.Text = "Open"
openButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green background
openButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
openButton.Parent = controlGui
openButton.Visible = false -- Initially hidden (since the GUI is already open)

-- Create a UICorner for rounded corners on the "Open" button
local openButtonCorner = Instance.new("UICorner")
openButtonCorner.CornerRadius = UDim.new(0, 12) -- Adjust for softer corners
openButtonCorner.Parent = openButton

-- Create the "Exit" button
local exitButton = Instance.new("TextButton")
exitButton.Size = UDim2.new(0, 100, 0, 50)
exitButton.Position = UDim2.new(0, 10, 0, 10) -- Top left corner (same position as the Open button)
exitButton.Text = "Exit"
exitButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red background
exitButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
exitButton.Parent = controlGui

-- Create a UICorner for rounded corners on the "Exit" button
local exitButtonCorner = Instance.new("UICorner")
exitButtonCorner.CornerRadius = UDim.new(0, 12) -- Adjust for softer corners
exitButtonCorner.Parent = exitButton

-- Close the GUI when the Exit button is clicked, and show the Open button
exitButton.MouseButton1Click:Connect(function()
    userFrame.Visible = false -- Hide the player list
    exitButton.Visible = false -- Hide the Exit button
    openButton.Visible = true -- Show the Open button
end)

-- Open the GUI when the Open button is clicked, and show the Exit button
openButton.MouseButton1Click:Connect(function()
    userFrame.Visible = true -- Show the player list
    exitButton.Visible = true -- Show the Exit button
    openButton.Visible = false -- Hide the Open button
end)

-- Adjust the canvas size whenever the layout changes (like when players join/leave)
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    userFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end) 
