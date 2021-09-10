-- ServerScriptService/leaderboard

local Players = game:GetService("Players")

local function leaderboardSetup(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = 'leaderstats'
	leaderstats.Parent = player
	
	local jump = Instance.new("IntValue")
	jump.Name = "JUMP"
	jump.Value = 0
	jump.Parent = leaderstats
end

Players.PlayerAdded:Connect(leaderboardSetup)
