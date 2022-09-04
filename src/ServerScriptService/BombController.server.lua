local dropBombRemoteEvent = game:GetService("ReplicatedStorage").DropBombEvent

-- Members
local bombFolder = game:GetService("ServerStorage").Bombs
local bombTemplate = bombFolder.Bomb

dropBombRemoteEvent.OnServerEvent:Connect(function(player)
	local bombLimit = player:GetAttribute("BombLimit")
	
	local bombQuantity = #workspace.SpawnedBombs:GetChildren()
	if bombQuantity > bombLimit then
		return
	end
	
	local bomb = bombTemplate:Clone()
	bomb.CFrame = player.Character.PrimaryPart.CFrame
	
	bomb.Collider.CFrame = bomb.CFrame * CFrame.new(0,-3, 0)
	bomb:SetAttribute("Owner", player.UserId)
	bomb:SetAttribute("Power", player:GetAttribute("Power"))
	bomb.Parent = workspace.SpawnedBombs
	
end)