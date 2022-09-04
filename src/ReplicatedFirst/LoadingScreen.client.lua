local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer 
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui
screenGui.DisplayOrder = 10
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
textLabel.Font = Enum.Font.GothamSemibold
textLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
textLabel.Text = "Loading"
textLabel.TextSize = 28
textLabel.Parent = screenGui
local loadingRing = Instance.new("ImageLabel")
loadingRing.Size = UDim2.new(0, 256, 0, 256)
loadingRing.BackgroundTransparency = 1
loadingRing.Image = "rbxassetid://4965945816"
loadingRing.AnchorPoint = Vector2.new(0.5, 0.5)
loadingRing.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingRing.Parent = screenGui

-- Remove the default loading screen
ReplicatedFirst:RemoveDefaultLoadingScreen()

local tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1)
local tween = TweenService:Create(loadingRing, tweenInfo, {Rotation = 360})
tween:Play()

wait(5)  -- Force screen to appear for a minimum number of seconds
if not game:IsLoaded() then
	game.Loaded:Wait()
end
screenGui:Destroy()