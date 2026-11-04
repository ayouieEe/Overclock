local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("OverclockRemotes")
local getState = remotes:WaitForChild("GetState")
local requestUpgrade = remotes:WaitForChild("RequestUpgrade")
local stateChanged = remotes:WaitForChild("StateChanged")

local gui = Instance.new("ScreenGui")
gui.Name = "OverclockHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.AnchorPoint = Vector2.new(0.5, 1)
panel.Position = UDim2.fromScale(0.5, 0.96)
panel.Size = UDim2.new(0.92, 0, 0, 230)
panel.BackgroundColor3 = Color3.fromRGB(15, 19, 28)
panel.BorderSizePixel = 0
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(72, 195, 255)
stroke.Transparency = 0.45
stroke.Parent = panel

local title = Instance.new("TextLabel")
title.Position = UDim2.fromOffset(16, 12)
title.Size = UDim2.new(1, -32, 0, 26)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "OVERCLOCK // CPU STATUS"
title.TextColor3 = Color3.fromRGB(181, 233, 255)
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local status = Instance.new("TextLabel")
status.Position = UDim2.fromOffset(16, 46)
status.Size = UDim2.new(1, -32, 0, 42)
status.BackgroundTransparency = 1
status.Font = Enum.Font.GothamBold
status.TextColor3 = Color3.fromRGB(242, 247, 255)
status.TextSize = 20
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = panel

local saveWarning = Instance.new("TextLabel")
saveWarning.Position = UDim2.fromOffset(16, 86)
saveWarning.Size = UDim2.new(1, -32, 0, 18)
saveWarning.BackgroundTransparency = 1
saveWarning.Font = Enum.Font.Gotham
saveWarning.TextColor3 = Color3.fromRGB(255, 185, 103)
saveWarning.TextSize = 12
saveWarning.TextXAlignment = Enum.TextXAlignment.Left
saveWarning.Parent = panel

local function createUpgradeButton(position, accent)
	local button = Instance.new("TextButton")
	button.Position = position
	button.Size = UDim2.new(0.5, -24, 0, 96)
	button.BackgroundColor3 = Color3.fromRGB(29, 38, 54)
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Font = Enum.Font.GothamBold
	button.TextColor3 = Color3.fromRGB(243, 248, 255)
	button.TextSize = 15
	button.TextWrapped = true
	button.Parent = panel

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 10)
	buttonCorner.Parent = button

	local buttonStroke = Instance.new("UIStroke")
	buttonStroke.Color = accent
	buttonStroke.Transparency = 0.3
	buttonStroke.Parent = button

	button:SetAttribute("Accent", accent)
	return button
end

local coreButton = createUpgradeButton(UDim2.fromOffset(16, 118), Color3.fromRGB(111, 218, 255))
local cacheButton = createUpgradeButton(UDim2.new(0.5, 8, 0, 118), Color3.fromRGB(139, 255, 185))

local currentState

local function upgradeText(name, level, compute)
	local nextLevel = level + 1
	local costs = name == "Cores" and { [2] = 20, [3] = 60 } or { [2] = 15, [3] = 50 }
	local cost = costs[nextLevel]
	if not cost then
		return string.upper(name) .. "\nMAX TEST LEVEL"
	end
	return string.upper(name) .. "\nLEVEL " .. level .. " → " .. nextLevel .. "\n" .. cost .. " COMPUTE"
end

local function updateButton(button, name, level, compute)
	local costs = name == "Cores" and { [2] = 20, [3] = 60 } or { [2] = 15, [3] = 50 }
	local affordable = costs[level + 1] and compute >= costs[level + 1]
	button.Text = upgradeText(name, level, compute)
	button.BackgroundColor3 = affordable and Color3.fromRGB(38, 68, 84) or Color3.fromRGB(29, 38, 54)
	button.TextTransparency = affordable and 0 or 0.35
end

local function update(snapshot)
	currentState = snapshot
	status.Text = string.format("%d / %d COMPUTE  •  %d COMPUTE/S", snapshot.compute, snapshot.capacity, snapshot.rate)
	if snapshot.saveStatus == "Unavailable" then
		saveWarning.Text = "SAVE UNAVAILABLE — Enable Studio API Services before persistence testing"
	elseif snapshot.saveStatus == "Loading" then
		saveWarning.Text = "LOADING CPU DATA..."
	elseif snapshot.saveStatus == "Unsaved" then
		saveWarning.Text = "LOCAL CHANGES WAITING TO SAVE"
	else
		saveWarning.Text = "DEVELOPMENT DATA STORE CONNECTED"
	end
	updateButton(coreButton, "Cores", snapshot.cores, snapshot.compute)
	updateButton(cacheButton, "Cache", snapshot.cache, snapshot.compute)
end

coreButton.Activated:Connect(function()
	if currentState and currentState.loaded then
		requestUpgrade:FireServer("Cores")
	end
end)

cacheButton.Activated:Connect(function()
	if currentState and currentState.loaded then
		requestUpgrade:FireServer("Cache")
	end
end)

stateChanged.OnClientEvent:Connect(update)
update(getState:InvokeServer())
