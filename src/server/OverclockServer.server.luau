local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local PlayerDataService = require(script.Parent.PlayerDataService)
local ComputeService = require(script.Parent.ComputeService)
local UpgradeService = require(script.Parent.UpgradeService)

local function getOrCreateRemote(className, name)
	local remotes = ReplicatedStorage:FindFirstChild("OverclockRemotes")
	if not remotes then
		remotes = Instance.new("Folder")
		remotes.Name = "OverclockRemotes"
		remotes.Parent = ReplicatedStorage
	end

	local remote = remotes:FindFirstChild(name)
	if remote then
		assert(remote:IsA(className), name .. " has the wrong class")
		return remote
	end

	remote = Instance.new(className)
	remote.Name = name
	remote.Parent = remotes
	return remote
end

local function createTestWorld()
	if Workspace:FindFirstChild("OverclockTestWorld") then
		return
	end

	local world = Instance.new("Model")
	world.Name = "OverclockTestWorld"
	world.Parent = Workspace

	local floor = Instance.new("Part")
	floor.Name = "Floor"
	floor.Anchored = true
	floor.Size = Vector3.new(80, 1, 80)
	floor.Position = Vector3.new(0, -0.5, 0)
	floor.Color = Color3.fromRGB(24, 29, 39)
	floor.Material = Enum.Material.SmoothPlastic
	floor.Parent = world

	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "TestSpawn"
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Size = Vector3.new(6, 1, 6)
	spawn.Position = Vector3.new(0, 0.5, -10)
	spawn.Color = Color3.fromRGB(44, 75, 99)
	spawn.Parent = world
end

local getState = getOrCreateRemote("RemoteFunction", "GetState")
local requestUpgrade = getOrCreateRemote("RemoteEvent", "RequestUpgrade")
local stateChanged = getOrCreateRemote("RemoteEvent", "StateChanged")

local playerDataService = PlayerDataService.new(function(player, snapshot)
	stateChanged:FireClient(player, snapshot)
end)
local computeService = ComputeService.new(playerDataService)
local upgradeService = UpgradeService.new(playerDataService)

createTestWorld()

getState.OnServerInvoke = function(player)
	return playerDataService:getSnapshot(player)
end

requestUpgrade.OnServerEvent:Connect(function(player, upgradeName)
	upgradeService:request(player, upgradeName)
end)

Players.PlayerAdded:Connect(function(player)
	task.spawn(function()
		playerDataService:load(player)
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	playerDataService:remove(player)
end)

for _, player in Players:GetPlayers() do
	task.spawn(function()
		playerDataService:load(player)
	end)
end

task.spawn(function()
	while true do
		task.wait(60)
		playerDataService:saveAll()
	end
end)

game:BindToClose(function()
	playerDataService:saveAll()
end)

computeService:start()
