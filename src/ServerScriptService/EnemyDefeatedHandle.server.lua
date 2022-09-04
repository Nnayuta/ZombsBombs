local Players = game:GetService("Players")
local SS = game:GetService("ServerStorage")

local EnemyDefeated: BindableEvent = SS.Network.EnemyDefeated
local PlayerGoldUpdated: BindableEvent = SS.Network.PlayerGoldUpdated

local playerController = require(SS.Modules.PlayerController)
local playersData = playerController.GetPlayers()

-- Constants
local GOLD_EARNED_ON_ENEMY_DEFEAT = 10

-- DEFEAT ENEMY
local function onEnemyDefeated(playerId: number)
	local player = Players:GetPlayerByUserId(playerId)
	playersData[player.UserId].gold += GOLD_EARNED_ON_ENEMY_DEFEAT
    PlayerGoldUpdated:Fire(player)
end

-- Listener
EnemyDefeated.Event:Connect(onEnemyDefeated)
