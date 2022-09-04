local Shop = {}

local MarketPlaceService = game:GetService("MarketplaceService")

Shop.products = {
	["1309131400"] = {
		productId = 1309131400,
		productName = "Gold Pack 1",
		reward = 1000,
	},
}

function Shop.BuyGold(player: Player)
	local product = Shop.products["1309131400"].productId
	MarketPlaceService:PromptProductPurchase(player, product)
end

return Shop
