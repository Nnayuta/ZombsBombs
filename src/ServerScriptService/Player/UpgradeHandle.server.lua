local RP = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")

local RequestPowerUpgradeRemoteEvent: RemoteEvent = RP.RequestPowerUpgrade
local RequestSpeedUpgradeRemoteEvent: RemoteEvent = RP.RequestSpeedUpgrade
local RequestBombLimitUpgradeRemoteEvent: RemoteEvent = RP.RequestBombLimitUpgrade

local playerController = require(SS.Modules.PlayerController)
local playersData = playerController.GetPlayers()
local shop = require(SS.Modules.Shop)

local UpgradeRequested: BindableEvent = SS.Network.UpgradeRequested

local UPGRADE_COST_BASE = 10

local function canPurchaseUpgrade(player)
	local data = playersData[player.UserId]
	local cost = UPGRADE_COST_BASE * data.upgradesBuyed
	playersData[player.UserId].cost = cost

	if data.gold < cost then
		shop.BuyGold(player)
		-- Can't purchase
		return false
	end
	return true
end

--- UPGRADE
local function onRequestPowerUpgrade(player: Player)
	if not canPurchaseUpgrade(player) then
		return
	end

	playersData[player.UserId].gold -= playersData[player.UserId].cost
	playersData[player.UserId].power += 1
	playersData[player.UserId].upgradesBuyed += 1

	player:SetAttribute("Power", playersData[player.UserId].power)

	-- Request update UI
	UpgradeRequested:Fire(player)
end

local function onRequestBombLimitUpgrade(player: Player)
	if not canPurchaseUpgrade(player) then
		return
	end

	playersData[player.UserId].gold -= playersData[player.UserId].cost
	playersData[player.UserId].bombLimit += 1
	playersData[player.UserId].upgradesBuyed += 1

	player:SetAttribute("BombLimit", playersData[player.UserId].bombLimit - 1)

	-- Request update UI
	UpgradeRequested:Fire(player)
end

local function onRequestSpeedUpgrade(player: Player)
	if not canPurchaseUpgrade(player) then
		return
	end

	playersData[player.UserId].gold -= playersData[player.UserId].cost
	playersData[player.UserId].speed += 1
	playersData[player.UserId].upgradesBuyed += 1

	local humanoid: Humanoid = player.Character:FindFirstChild("Humanoid")
	humanoid.WalkSpeed = playersData[player.UserId].speed

	-- Request update UI
	UpgradeRequested:Fire(player)
end

RequestPowerUpgradeRemoteEvent.OnServerEvent:Connect(onRequestPowerUpgrade)
RequestSpeedUpgradeRemoteEvent.OnServerEvent:Connect(onRequestSpeedUpgrade)
RequestBombLimitUpgradeRemoteEvent.OnServerEvent:Connect(onRequestBombLimitUpgrade)
