local DataStoreService = game:GetService("DataStoreService")
local SaveDataStore = DataStoreService:GetDataStore("SaveData")
local WinsODS = DataStoreService:GetOrderedDataStore("Wins") 
local Players = game:GetService("Players")




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
	
	local Vote = Instance.new("StringValue") --create a string value to check if player has voted
	Vote.Name = "Vote"
	Vote.Parent = player
	Vote.Value = "NA"
	
	local Data = SaveDataStore:GetAsync(player.UserId)

	if Data then

		for i, stats in pairs(leaderstats:GetChildren()) do

			stats.Value = Data[stats.Name]
		end		

	else		
		print(player.Name .. " has no data.")			
	end
	
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
