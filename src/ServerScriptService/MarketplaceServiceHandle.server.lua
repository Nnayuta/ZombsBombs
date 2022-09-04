local MarketplaceService:MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local SS = game:GetService("ServerStorage")

local ProductPurchased:BindableEvent = SS.Network.ProductPurchased

local playerController = require(SS.Modules.PlayerController)
local playersData = playerController.GetPlayers()

local Shop = require(SS.Modules.Shop)

MarketplaceService.ProcessReceipt = function(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	local product = Shop.products[tostring(receiptInfo.ProductId)]

	if product then
		playersData[player.UserId].gold += product.reward
		ProductPurchased:Fire(player)
	end
end
