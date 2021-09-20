-- ServerScriptService/leaderboard

local DataStoreService = game:GetService("DataStoreService")
local SaveDataStore = DataStoreService:GetDataStore("SaveData")
local WinsODS = DataStoreService:GetOrderedDataStore("Wins") 
local Players = game:GetService("Players")


local function printTopTenPlayers()
	local isAscending = false
	local pageSize = 10
	local pages = WinsODS:GetSortedAsync(isAscending, pageSize)
	local topTen = pages:GetCurrentPage()

	-- The data in 'topTen' is stored with the index being the index on the page
	-- For each item, 'data.key' is the key in the OrderedDataStore and 'data.value' is the value
	for rank, data in ipairs(topTen) do
		local name = data.key
		local points = data.value
		print(data.key .. " is ranked #" .. rank .. " with " .. data.value .. "points")
	end

	-- Potentially load the next page...
	--pages:AdvanceToNextPageAsync()
end

game.Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local money = Instance.new("IntValue") 
	money.Name = "money"
	money.Parent = leaderstats


	local win = Instance.new("IntValue")
	win.Name = "win"
	win.Parent = leaderstats
	
	local Data = SaveDataStore:GetAsync(player.UserId)

	if Data then

		for i, stats in pairs(leaderstats:GetChildren()) do

			stats.Value = Data[stats.Name]
		end		

	else		
		print(player.Name .. " has no data.")			
	end
	WinsODS:SetAsync("Alex", 55)
	WinsODS:SetAsync("Charley", 32)
	WinsODS:SetAsync("Sydney", 68)
	printTopTenPlayers()
end)

local function SavePlayerData(player)

	local success, errormsg = pcall(function()

		local SaveData = {}

		for i, stats in pairs(player.leaderstats:GetChildren()) do
			print(stats)
			SaveData[stats.Name] = stats.Value
		end	
		SaveDataStore:SetAsync(player.UserId, SaveData)
		WinsODS:SetAsync(player.UserId , player.leaderstats:WaitForChild("win").Value)
	end)

	if not success then 
		return errormsg
	end			
end	


Players.PlayerRemoving:Connect(function(player)

	local errormsg = SavePlayerData(player)

	if errormsg then	
		warn(errormsg)		
	end	
end)

game:BindToClose(function()
	for i, player in pairs(Players:GetPlayers()) do	

		local errormsg = SavePlayerData(player)
		if errormsg then
			warn(errormsg)
		end			
	end
	wait(2)	
end)
