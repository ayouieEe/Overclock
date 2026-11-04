local UpgradeConfig = {
	Cores = {
		[2] = 20,
		[3] = 60,
	},
	Cache = {
		[2] = 15,
		[3] = 50,
	},
}

function UpgradeConfig.getCost(upgradeName, nextLevel)
	local levels = UpgradeConfig[upgradeName]
	return levels and levels[nextLevel] or nil
end

return UpgradeConfig
