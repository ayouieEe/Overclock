local Players = game:GetService("Players")

local ComputeService = {}
ComputeService.__index = ComputeService

function ComputeService.new(playerDataService)
	return setmetatable({ playerDataService = playerDataService }, ComputeService)
end

function ComputeService:start()
	task.spawn(function()
		while true do
			task.wait(1)
			local now = os.time()
			for _, player in Players:GetPlayers() do
				self.playerDataService:accrue(player, now)
			end
		end
	end)
end

return ComputeService
