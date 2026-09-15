-- Auto-exec script with PlaceId check + small GUI
local slapBattlesId = 6403373529

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")

ScreenGui.Parent = game:GetService("CoreGui")
Frame.Parent = ScreenGui
TextLabel.Parent = Frame

-- Style GUI
Frame.Size = UDim2.new(0, 250, 0, 100)
Frame.Position = UDim2.new(0.5, -125, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0

TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Checking if Slap Battles..."
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.Font = Enum.Font.GothamBold

-- Wait 3 seconds before checking
task.wait(3)

-- Check PlaceId
if game.PlaceId == slapBattlesId then
    TextLabel.Text = "Slap Battles found! Loading..."
    task.wait(1)
    ScreenGui:Destroy()
    
    -- Run your script
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ZulimaDoma/ZuluGrowAGarden/refs/heads/main/SlapBattle"))()
else
    TextLabel.Text = "Not Slap Battles. Closing..."
    task.wait(1.5)
    ScreenGui:Destroy()
end
