local DataStoreService = game:GetService("DataStoreService")

local GameConfig = require(game:GetService("ReplicatedStorage").Shared.GameConfig)
local ComputeRules = require(game:GetService("ReplicatedStorage").Shared.ComputeRules)

local PlayerDataService = {}
PlayerDataService.__index = PlayerDataService

function PlayerDataService.new(onStateChanged)
	return setmetatable({
		dataStore = DataStoreService:GetDataStore(GameConfig.DataStoreName),
		records = {},
		onStateChanged = onStateChanged,
	}, PlayerDataService)
end

function PlayerDataService:_emit(player)
	if self.onStateChanged and self.records[player] then
		self.onStateChanged(player, self:getSnapshot(player))
	end
end

function PlayerDataService:_getRecord(player)
	return self.records[player]
end

function PlayerDataService:getSnapshot(player)
	local record = self:_getRecord(player)
	if not record then
		local state = ComputeRules.newDefaultState(os.time())
		return {
			compute = state.compute,
			cores = state.cores,
			cache = state.cache,
			rate = ComputeRules.getRate(state),
			capacity = ComputeRules.getCapacity(state),
			loaded = false,
			saveStatus = "Loading",
		}
	end

	local state = record.state
	return {
		compute = state.compute,
		cores = state.cores,
		cache = state.cache,
		rate = ComputeRules.getRate(state),
		capacity = ComputeRules.getCapacity(state),
		loaded = record.loaded,
		saveStatus = record.saveStatus,
	}
end

function PlayerDataService:load(player)
	local now = os.time()
	local record = {
		state = ComputeRules.newDefaultState(now),
		loaded = false,
		saveStatus = "Loading",
	}
	self.records[player] = record
	self:_emit(player)

	local success, storedState = pcall(function()
		return self.dataStore:GetAsync(tostring(player.UserId))
	end)

	if success then
		record.state = ComputeRules.normalizeState(storedState, now)
		ComputeRules.applyOfflineAccrual(record.state, now)
		record.loaded = true
		record.saveStatus = "Saved"
	else
		record.loaded = true
		record.saveStatus = "Unavailable"
		warn("Overclock Simulator could not load data for " .. player.Name .. ": " .. tostring(storedState))
	end
	self:_emit(player)
end

function PlayerDataService:accrue(player, now)
	local record = self:_getRecord(player)
	if not record or not record.loaded then
		return
	end
	local elapsedSeconds = math.max(0, now - record.state.lastAccrualUnix)
	if elapsedSeconds < 1 then
		return
	end
	ComputeRules.accrue(record.state, elapsedSeconds)
	record.state.lastAccrualUnix = now
	self:_emit(player)
end

function PlayerDataService:tryPurchase(player, upgradeName)
	local record = self:_getRecord(player)
	if not record or not record.loaded then
		return false, "Still loading"
	end

	self:accrue(player, os.time())
	local success, result = ComputeRules.tryPurchase(record.state, upgradeName)
	if success then
		if record.saveStatus ~= "Unavailable" then
			record.saveStatus = "Unsaved"
		end
		self:_emit(player)
		self:save(player)
	end
	return success, result
end

function PlayerDataService:save(player)
	local record = self:_getRecord(player)
	if not record or not record.loaded then
		return false
	end

	record.state.lastAccrualUnix = os.time()
	local stateToSave = table.clone(record.state)
	local success, errorMessage = pcall(function()
		self.dataStore:UpdateAsync(tostring(player.UserId), function()
			return stateToSave
		end)
	end)

	if success then
		record.saveStatus = "Saved"
	else
		record.saveStatus = "Unavailable"
		warn("Overclock Simulator could not save data for " .. player.Name .. ": " .. tostring(errorMessage))
	end
	self:_emit(player)
	return success
end

function PlayerDataService:saveAll()
	for player in pairs(self.records) do
		self:save(player)
	end
end

function PlayerDataService:remove(player)
	self:save(player)
	self.records[player] = nil
end

return PlayerDataService
