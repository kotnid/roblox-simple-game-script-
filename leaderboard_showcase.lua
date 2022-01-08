local DataStoreService = game:GetService("DataStoreService")
local WinsODS = DataStoreService:GetOrderedDataStore("Wins") 

local function printTopTenPlayers()
	
	game.Workspace.leaderboard.board.SurfaceGui.Holder:ClearAllChildren()
	local isAscending = false
	local pageSize = 10
	local pages = WinsODS:GetSortedAsync(isAscending, pageSize)
	local topTen = pages:GetCurrentPage()

	-- The data in 'topTen' is stored with the index being the index on the page
	-- For each item, 'data.key' is the key in the OrderedDataStore and 'data.value' is the value
	for rank, data in ipairs(topTen) do
		local name = game.Players:GetNameFromUserIdAsync(tonumber(data.key))
		local points = data.value
		local new_frame = game.ReplicatedStorage:WaitForChild("LeaderboardFrame"):Clone()
		new_frame.Player.Text = name
		new_frame.Wins.Text = points
		new_frame.Rank.Text = "#"..rank
		new_frame.Position = UDim2.new(0,0,new_frame.Position.Y.Scale + (0.08 * #game.Workspace.leaderboard.board.SurfaceGui.Holder:GetChildren()),0)
		new_frame.Parent = game.Workspace.leaderboard.board.SurfaceGui.Holder
	end


end


while true do
	printTopTenPlayers()
	wait(60)
end
