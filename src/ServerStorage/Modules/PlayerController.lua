local PlayerController = {}

--#region SERVICES
local Players: Players = game:GetService("Players")
local DataStoreService: DataStoreService = game:GetService("DataStoreService")

--#endregion

--#region MEMBERS
local database = DataStoreService:GetDataStore("Data123")
local PlayerloadedRemoteEvent: RemoteEvent = game:GetService("ReplicatedStorage").PlayerLoaded

--#endregion

--#region CONSTATNS
local PLAYER_DEFAULT_DATA = {
	gold = 0,
	speed = 16,
	power = 25,
	bombLimit = 1,
	upgradesBuyed = 0,
	cost = 10,
}
--#endregion

local playersData = {}

local function generateLeaderstats(player)
	-- Leaderstats do Player
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
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

local function UpdateGUI(player: Player)
	-- Fire player loaded event
	PlayerloadedRemoteEvent:FireClient(player, playersData[player.UserId])

	-- local leaderstats = player:FindFirstChild("leaderstats")
	-- if leaderstats then
	-- 	leaderstats:FindFirstChild("Gold").Value = playersData[player.UserId].gold
	-- 	leaderstats:FindFirstChild("Speed").Value = playersData[player.UserId].speed
	-- 	leaderstats:FindFirstChild("Power").Value = playersData[player.UserId].power
	-- 	leaderstats:FindFirstChild("BombLimit").Value = playersData[player.UserId].bombLimit
	-- end
end

local function onPlayerAdded(player: Player)
	local dataFromDB = database:GetAsync(player.UserId)
	if not dataFromDB then
		dataFromDB = PLAYER_DEFAULT_DATA
	end
	playersData[player.UserId] = dataFromDB

	player.CharacterAdded:Connect(function(character)
		local data = playersData[player.UserId]
		player:SetAttribute("Power", data.power)
		player:SetAttribute("BombLimit", playersData[player.UserId].bombLimit - 1)

		local humanoid = character:FindFirstChild("Humanoid")
		humanoid.WalkSpeed = data.speed

		PlayerloadedRemoteEvent:FireClient(player, playersData[player.UserId])
	end)
end

local function onPlayerRemoving(player: Player)
	database:SetAsync(player.UserId, playersData[player.UserId])
	playersData[player.UserId] = nil
end

function PlayerController.GetPlayers()
	return playersData
end

--#region LISTENERS
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

--#endregion

return PlayerController
