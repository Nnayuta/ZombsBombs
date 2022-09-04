local RP = game:GetService("ReplicatedStorage")

local RequestPowerUpgradeRemoteEvent = RP.RequestPowerUpgrade
local RequestSpeedUpgradeRemoteEvent = RP.RequestSpeedUpgrade
local RequestBombLimitUpgradeRemoteEvent = RP.RequestBombLimitUpgrade

local PlayerloadedRemoteEvent = RP.PlayerLoaded

local Players = game:GetService("Players")
local PlayerGUI = Players.LocalPlayer:WaitForChild("PlayerGui")
local Hud = PlayerGUI:WaitForChild("HUD")

local addSpeedButton:TextButton = Hud:WaitForChild("AddSpeed")
local addPowerButton:TextButton = Hud:WaitForChild("AddPower")
local addBombButton:TextButton = Hud:WaitForChild("AddBomb")

local goldTag:TextLabel = Hud:WaitForChild("Gold")
local powerTag:TextLabel = Hud:WaitForChild("Power")
local speedTag:TextLabel = Hud:WaitForChild("Speed")
local bombTag:TextLabel = Hud:WaitForChild("Bomb")
local upgradeTag:TextLabel = Hud:WaitForChild("UpgradePrice")

PlayerloadedRemoteEvent.OnClientEvent:Connect(function(data)
	goldTag.Text = string.format("GOLD: %s", data.gold) 
	powerTag.Text = data.power
	speedTag.Text = data.speed
	bombTag.Text = data.bombLimit
	upgradeTag.Text = string.format("COST: %s", data.cost) 
end)

addPowerButton.MouseButton1Click:Connect(function()
	print("Upgrade Power")
	RequestPowerUpgradeRemoteEvent:FireServer()
end)

addSpeedButton.MouseButton1Click:Connect(function()
	print("Upgrade Speed")
	RequestSpeedUpgradeRemoteEvent:FireServer()
end)

addBombButton.MouseButton1Click:Connect(function()
	print("Bomb Upgrade")
	RequestBombLimitUpgradeRemoteEvent:FireServer()
end)
