local GameConfig = require(script.Parent.GameConfig)
local UpgradeConfig = require(script.Parent.UpgradeConfig)

local ComputeRules = {}

function ComputeRules.newDefaultState(now)
	return {
		schemaVersion = GameConfig.SchemaVersion,
		compute = GameConfig.StartingCompute,
		cores = GameConfig.StartingCores,
		cache = GameConfig.StartingCache,
		lastAccrualUnix = now,
	}
end

function ComputeRules.normalizeState(rawState, now)
	if type(rawState) ~= "table" then
		return ComputeRules.newDefaultState(now)
	end

	local state = ComputeRules.newDefaultState(now)
	state.compute = math.max(0, math.floor(tonumber(rawState.compute) or state.compute))
	state.cores = math.max(1, math.floor(tonumber(rawState.cores) or state.cores))
	state.cache = math.max(1, math.floor(tonumber(rawState.cache) or state.cache))
	state.lastAccrualUnix = math.max(0, math.floor(tonumber(rawState.lastAccrualUnix) or now))
	state.compute = math.min(state.compute, ComputeRules.getCapacity(state))
	return state
end

function ComputeRules.getRate(state)
	return state.cores * GameConfig.ComputePerCorePerSecond
end

function ComputeRules.getCapacity(state)
	return state.cache * GameConfig.CapacityPerCache
end

function ComputeRules.accrue(state, elapsedSeconds)
	local wholeSeconds = math.max(0, math.floor(elapsedSeconds))
	state.compute = math.min(ComputeRules.getCapacity(state), state.compute + ComputeRules.getRate(state) * wholeSeconds)
	return state
end

function ComputeRules.applyOfflineAccrual(state, now)
	local elapsedSeconds = math.clamp(now - state.lastAccrualUnix, 0, GameConfig.OfflineAccrualLimitSeconds)
	ComputeRules.accrue(state, elapsedSeconds)
	state.lastAccrualUnix = now
	return state
end

function ComputeRules.tryPurchase(state, upgradeName)
	if upgradeName ~= "Cores" and upgradeName ~= "Cache" then
		return false, "Unknown upgrade"
	end

	local statName = string.lower(upgradeName)
	local nextLevel = state[statName] + 1
	local cost = UpgradeConfig.getCost(upgradeName, nextLevel)
	if not cost then
		return false, "Maximum test level reached"
	end
	if state.compute < cost then
		return false, "Not enough Compute"
	end

	state.compute -= cost
	state[statName] = nextLevel
	state.compute = math.min(state.compute, ComputeRules.getCapacity(state))
	return true, cost
end

return ComputeRules
