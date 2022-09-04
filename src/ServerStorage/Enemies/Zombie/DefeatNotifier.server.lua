
-- Members
local zombie = script.Parent
local humanoid:Humanoid = zombie.Humanoid
local EnemyDefeatedBindableEvent = game:GetService("ServerStorage").Network.EnemyDefeated

local connection: RBXScriptSignal

connection = humanoid.Died:Connect(function()
	local playerId = humanoid:GetAttribute("LastDamageBy")
	
	EnemyDefeatedBindableEvent:Fire(playerId)
	connection:Disconnect()
end)

