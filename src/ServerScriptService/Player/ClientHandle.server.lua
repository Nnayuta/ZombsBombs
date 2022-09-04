local SS: ServerStorage = game:GetService("ServerStorage")
local RS: ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerloadedRemoteEvent: RemoteEvent = RS.PlayerLoaded
local ProductPurchased: BindableEvent = SS.Network.ProductPurchased
local UpgradeRequested: BindableEvent = SS.Network.UpgradeRequested
local PlayerGoldUpdated: BindableEvent = SS.Network.PlayerGoldUpdated

local playerController = require(SS.Modules.PlayerController)
local playersData = playerController.GetPlayers()

local function updatePlayerUI(player: Player)
	PlayerloadedRemoteEvent:FireClient(player, playersData[player.UserId])
end

-- All events responsible for triggering an UI update
ProductPurchased.Event:Connect(updatePlayerUI)
UpgradeRequested.Event:Connect(updatePlayerUI)
PlayerGoldUpdated.Event:Connect(updatePlayerUI)
