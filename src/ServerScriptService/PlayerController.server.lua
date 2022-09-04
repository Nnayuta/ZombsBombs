-- Services
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RP = game:GetService("ReplicatedStorage")
local MarketPlaceService = game:GetService("MarketplaceService")
local ProximityPromptService = game:GetService("ProximityPromptService")

-- Events
local RequestPowerUpgradeRemoteEvent = RP.RequestPowerUpgrade
local RequestSpeedUpgradeRemoteEvent = RP.RequestSpeedUpgrade
local RequestBombLimitUpgradeRemoteEvent = RP.RequestBombLimitUpgrade

-- Members
local EnemyDefeatedBindableEvent = game:GetService("ServerStorage").Network.EnemyDefeated
local PlayerloadedRemoteEvent = game:GetService("ReplicatedStorage").PlayerLoaded

local database = DataStoreService:GetDataStore("Zombie_Production")
local playersData = {}

-- Constants
local GOLD_EARNED_ON_ENEMY_DEFEAT = 10
local UPGRADE_COST_BASE = 10
local PLAYER_DEFAULT_DATA = {
	gold = 0;
	speed = 16;
	power = 25;
	bombLimit = 1;
	upgradesBuyed = 0;
	cost = 10;
}

local function UpdateGUI(player: Player)
	-- Fire player loaded event
	PlayerloadedRemoteEvent:FireClient(player, playersData[player.UserId])
	
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		leaderstats:FindFirstChild("Gold").Value = playersData[player.UserId].gold
		leaderstats:FindFirstChild("Speed").Value = playersData[player.UserId].speed
		leaderstats:FindFirstChild("Power").Value = playersData[player.UserId].power
		leaderstats:FindFirstChild("BombLimit").Value = playersData[player.UserId].bombLimit
	end
end


--- UPGRADE

local function onRequestPowerUpgrade(player: Player)	
	local data = playersData[player.UserId]
	
	local cost = UPGRADE_COST_BASE * data.upgradesBuyed
	playersData[player.UserId].cost = cost
	
	if data.gold < cost then
		print("Not enough gold")
		--1309131400
		MarketPlaceService:PromptProductPurchase(player, 1309131400)
		return
	end
	playersData[player.UserId].gold -= cost
	playersData[player.UserId].power += 1
	playersData[player.UserId].upgradesBuyed += 1
	
	player:SetAttribute("Power", playersData[player.UserId].power)

	-- Fire player loaded event
	UpdateGUI(player)

end

local function onRequestBombLimitUpgrade(player: Player)	
	local data = playersData[player.UserId]
	
	local cost = UPGRADE_COST_BASE * data.upgradesBuyed
	playersData[player.UserId].cost = cost
	
	if data.gold < cost then
		print("Not enough gold")
		--1309131400
		MarketPlaceService:PromptProductPurchase(player, 1309131400)
		return
	end
	playersData[player.UserId].gold -= cost
	playersData[player.UserId].bombLimit += 1
	playersData[player.UserId].upgradesBuyed += 1

	player:SetAttribute("BombLimit", playersData[player.UserId].bombLimit - 1)

	-- Fire player loaded event
	UpdateGUI(player)

end

local function onRequestSpeedUpgrade(player: Player)
	local data = playersData[player.UserId]
	
	local cost = UPGRADE_COST_BASE * data.upgradesBuyed
	playersData[player.UserId].cost = cost
	
	if data.gold < cost then
		MarketPlaceService:PromptProductPurchase(player, 1309131400)
		return
	end
	playersData[player.UserId].gold -= cost
	playersData[player.UserId].speed += 1
	playersData[player.UserId].upgradesBuyed += 1
	
	local humanoid:Humanoid = player.Character:FindFirstChild("Humanoid")
	humanoid.WalkSpeed = data.speed

	UpdateGUI(player)

end

-- DEFEAT ENEMY


local function onEnemyDefeated(playerId: number)
	local player = Players:GetPlayerByUserId(playerId)
	playersData[player.UserId].gold += GOLD_EARNED_ON_ENEMY_DEFEAT
	
	UpdateGUI(player)
end



local function generateLeaderstats (player)
	-- Leaderstats do Player
	local leaderstats = Instance.new("Folder")
	leaderstats.Name ="leaderstats"
	leaderstats.Parent = player

	local Gold = Instance.new("IntValue")
	Gold.Name = "Gold"
	Gold.Parent = leaderstats

	local Speed = Instance.new("IntValue")
	Speed.Name = "Speed"
	Speed.Parent = leaderstats

	local Power = Instance.new("IntValue")
	Power.Name = "Power"
	Power.Parent = leaderstats

	local bombLimit = Instance.new("IntValue")
	bombLimit.Name = "BombLimit"
	bombLimit.Parent = leaderstats
end

-- PLAYER
local function onPlayerAdded(player: Player)	
	local dataFromDB = database:GetAsync(player.UserId)
	if not dataFromDB then
		dataFromDB = PLAYER_DEFAULT_DATA
	end
	playersData[player.UserId] = dataFromDB
	
	generateLeaderstats(player)
	
	player.CharacterAdded:Connect(function(character)
		
		local data = playersData[player.UserId]
		player:SetAttribute("Power", data.power)
		player:SetAttribute("BombLimit", playersData[player.UserId].bombLimit - 1)

		local humanoid = character:FindFirstChild("Humanoid")
		humanoid.WalkSpeed = data.speed
		wait(1)
		UpdateGUI(player)
	end)
end

local function onPlayerRemoving(player: Player)
	database:SetAsync(player.UserId, playersData[player.UserId])
	playersData[player.UserId] = nil
end


-- Listener
EnemyDefeatedBindableEvent.Event:Connect(onEnemyDefeated)
Players.PlayerRemoving:Connect(onPlayerRemoving)
Players.PlayerAdded:Connect(onPlayerAdded)

RequestPowerUpgradeRemoteEvent.OnServerEvent:Connect(onRequestPowerUpgrade)
RequestSpeedUpgradeRemoteEvent.OnServerEvent:Connect(onRequestSpeedUpgrade)
RequestBombLimitUpgradeRemoteEvent.OnServerEvent:Connect(onRequestBombLimitUpgrade)


MarketPlaceService.ProcessReceipt = function(receiptInfo)
	
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	
	if receiptInfo.ProductId == 1309131400 then
		playersData[player.UserId].gold += 1000
	end
	
	UpdateGUI(player)
end

ProximityPromptService.PromptTriggered:Connect(function(promptObject, player)
	MarketPlaceService:PromptProductPurchase(player, 1309131400)
end)
