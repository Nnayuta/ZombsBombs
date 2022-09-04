-- Constants
local EXPLOSION_TIME:IntValue = script.Parent:FindFirstChild("ExplosionTime").Value
local EXPLOSION_AREA:IntValue = script.Parent:FindFirstChild("ExplosionArea").Value

-- Members
local bomb = script.Parent
local owner = bomb:GetAttribute("Owner")
local power = bomb:GetAttribute("Power")
local explosionSound = game:GetService("SoundService").BombExplosion

local humanoids = {}

-- Bomb Behaviour
delay(EXPLOSION_TIME, function()
	local explosion = Instance.new("Explosion")
	explosion.Parent = workspace
	
	explosion.BlastRadius = EXPLOSION_AREA
	explosion.BlastPressure = 0
	explosion.DestroyJointRadiusPercent = 0
	explosion.Position = bomb.Position
	
	local explosionSoundClone = explosionSound:Clone()
	explosionSoundClone.Parent = workspace
	explosionSoundClone:Play()
	
	local collider = bomb.Collider
	collider.Touched:Connect(function(hit) end)
	local parts = collider:GetTouchingParts()
	
	for _, part in parts do
		local sucess, message = pcall(function()
			local character = part.Parent
			if character then
				local humanoid:Model = character:FindFirstChild("Humanoid")
				if humanoid and not humanoids[humanoid] then
					humanoids[humanoid] = true
					humanoid.Health -= power
					
					humanoid:SetAttribute("LastDamageBy", owner)
				end
				
			end
		end)
		
		if not sucess then
			warn(message)
		end
	end
	
	bomb:Destroy()
end)