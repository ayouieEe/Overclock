local UpgradeService = {}
UpgradeService.__index = UpgradeService

function UpgradeService.new(playerDataService)
	return setmetatable({ playerDataService = playerDataService }, UpgradeService)
end

function UpgradeService:request(player, upgradeName)
	if type(upgradeName) ~= "string" then
		return false, "Invalid upgrade request"
	end
	return self.playerDataService:tryPurchase(player, upgradeName)
end

return UpgradeService
