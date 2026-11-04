local RunService = game:GetService("RunService")

if not RunService:IsStudio() then
	return
end

local ComputeRules = require(game:GetService("ReplicatedStorage").Shared.ComputeRules)
local GameConfig = require(game:GetService("ReplicatedStorage").Shared.GameConfig)

local state = ComputeRules.newDefaultState(100)
assert(ComputeRules.getRate(state) == 1, "Default rate must be 1 Compute/s")
assert(ComputeRules.getCapacity(state) == 50, "Default capacity must be 50")

ComputeRules.accrue(state, 999)
assert(state.compute == 50, "Compute must not exceed capacity")

state.compute = 0
local unaffordablePurchase = ComputeRules.tryPurchase(state, "Cores")
assert(not unaffordablePurchase and state.compute == 0 and state.cores == 1, "Unaffordable upgrades must not change state")

state.compute = 15
local boughtCache = ComputeRules.tryPurchase(state, "Cache")
assert(boughtCache and state.cache == 2 and ComputeRules.getCapacity(state) == 100, "Cache level 2 must cost 15 and grant 100 capacity")

state.compute = 20
local boughtCore = ComputeRules.tryPurchase(state, "Cores")
assert(boughtCore and state.cores == 2 and ComputeRules.getRate(state) == 2, "Core level 2 must cost 20 and grant 2 Compute/s")

local invalidPurchase = ComputeRules.tryPurchase(state, "ClockSpeed")
assert(not invalidPurchase, "Unknown upgrades must be rejected")

local offlineState = ComputeRules.newDefaultState(100)
offlineState.cache = 1000
offlineState.lastAccrualUnix = 100
ComputeRules.applyOfflineAccrual(offlineState, 100 + GameConfig.OfflineAccrualLimitSeconds * 10)
assert(offlineState.compute == GameConfig.OfflineAccrualLimitSeconds, "Offline accrual must stop at four hours")
