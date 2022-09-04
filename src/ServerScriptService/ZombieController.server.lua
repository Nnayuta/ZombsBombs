-- Services
local serverStorage = game:GetService("ServerStorage")

-- Constants
local ENEMY_POPULATION = 100

-- Members
local enemies = serverStorage.Enemies
local zombie = enemies:FindFirstChild("Zombie")
local spawnedEnemies = workspace.SpawnedEnemies

local lastNumber: number = 0
local spawnNumber: number = 0

local function spawnZombie()
	--Clona o Zombie
	local zombieCloned = zombie:Clone()
	local EnemySpawnPoints = workspace.EnemiesSpawnPoint:GetChildren()
		
	while spawnNumber == lastNumber  do
		spawnNumber = math.random(1, #EnemySpawnPoints)
		wait(1)
	end
	
	lastNumber = spawnNumber
	
	zombieCloned.PrimaryPart.CFrame = EnemySpawnPoints[spawnNumber].CFrame

	-- Move para Workspace
	zombieCloned.Parent = spawnedEnemies
end

-- Adiciona os primeiros inimigos no mundo
for count = 1, ENEMY_POPULATION do
	spawnZombie()
end

while true do
	local population = #spawnedEnemies:GetChildren()
	
	if population < ENEMY_POPULATION then
		spawnZombie()
	end
	wait(1)
end