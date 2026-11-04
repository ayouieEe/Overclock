local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("OverclockRemotes")
local getState = remotes:WaitForChild("GetState")
local stateChanged = remotes:WaitForChild("StateChanged")

local existingDesk = workspace:FindFirstChild("OverclockLocalDesk")
if existingDesk then
	existingDesk:Destroy()
end

local desk = Instance.new("Model")
desk.Name = "OverclockLocalDesk"
desk.Parent = workspace

local function part(name, size, position, color, parent)
	local instance = Instance.new("Part")
	instance.Name = name
	instance.Anchored = true
	instance.CanCollide = false
	instance.Material = Enum.Material.SmoothPlastic
	instance.Size = size
	instance.Position = position
	instance.Color = color
	instance.Parent = parent or desk
	return instance
end

part("Desk", Vector3.new(12, 1, 7), Vector3.new(0, 3, 0), Color3.fromRGB(65, 49, 38))
part("DeskLegLeft", Vector3.new(0.6, 5, 0.6), Vector3.new(-5, 0.5, -2.5), Color3.fromRGB(42, 32, 27))
part("DeskLegRight", Vector3.new(0.6, 5, 0.6), Vector3.new(5, 0.5, -2.5), Color3.fromRGB(42, 32, 27))
part("DeskLegBackLeft", Vector3.new(0.6, 5, 0.6), Vector3.new(-5, 0.5, 2.5), Color3.fromRGB(42, 32, 27))
part("DeskLegBackRight", Vector3.new(0.6, 5, 0.6), Vector3.new(5, 0.5, 2.5), Color3.fromRGB(42, 32, 27))

local cpu = Instance.new("Model")
cpu.Name = "CPU"
cpu.Parent = desk
part("CPUCase", Vector3.new(4, 2.2, 3.5), Vector3.new(0, 4.6, 0), Color3.fromRGB(30, 39, 56), cpu)
part("CPUAccent", Vector3.new(3.6, 0.2, 3.1), Vector3.new(0, 5.75, 0), Color3.fromRGB(84, 202, 255), cpu)

local coreModules = Instance.new("Folder")
coreModules.Name = "CoreModules"
coreModules.Parent = cpu

local function render(snapshot)
	coreModules:ClearAllChildren()
	for core = 1, snapshot.cores do
		local offset = (core - 1) * 0.85 - ((snapshot.cores - 1) * 0.425)
		part("Core" .. core, Vector3.new(0.65, 0.45, 1.2), Vector3.new(offset, 6.08, 0), Color3.fromRGB(111, 218, 255), coreModules)
	end
end

stateChanged.OnClientEvent:Connect(render)
render(getState:InvokeServer())
