local VotingSystem = game.Workspace:WaitForChild("VotingSystem")
local Pad1 = VotingSystem:WaitForChild("Pad1")
local Pad2 = VotingSystem:WaitForChild("Pad2")
local Pad3 = VotingSystem:WaitForChild("Pad3")

local timeLeft = ReplicatedStorage:WaitForChild("timeLeft")
local doneVoting = ReplicatedStorage:WaitForChild("doneVoting")

local function updateDisplay() --update display on pad
	VotingSystem.VotingDisplay.SurfaceGui.Pad1.Counter.Text = Pad1.Votes.Value
	VotingSystem.VotingDisplay.SurfaceGui.Pad2.Counter.Text = Pad2.Votes.Value
	VotingSystem.VotingDisplay.SurfaceGui.Pad3.Counter.Text = Pad3.Votes.Value
end

local function CalculateWinner()  --find which map is winner
	local padVote = {
		["1"] = Pad1.Votes.Value,   
		["2"] = Pad2.Votes.Value,
		["3"] = Pad3.Votes.Value,
	}

	local highest = 0 
	local npad = nil
	for i , v in pairs(padVote) do
		if v > highest then
			highest = v
			npad = i 
		end
	end	  
	return npad
end

local function voting(type) --start voting
	local Chosen = {}
	if type == 1  then
		local Available = MapsFolder:GetChildren()
		for i = 1, 3 do
			local r = math.random(1, #Available)
			Chosen[i] = Available[r]
			table.remove(Available, r)
		end
	else
		local Available = {"1","2","3"}
		for i = 1, 3 do
			local r = math.random(1, #Available)
			Chosen[i] = Available[r]
			table.remove(Available, r)
		end
	end
	
	VotingSystem.VotingDisplay.SurfaceGui.Pad1.Header.Text = Chosen[0]
	VotingSystem.VotingDisplay.SurfaceGui.Pad2.Header.Text = Chosen[1]
	VotingSystem.VotingDisplay.SurfaceGui.Pad3.Header.Text = Chosen[2]
	
	while wait(1)do
		if timeLeft.Value <= 0 then
			doneVoting.Value = true
			local winner = CalculateWinner()
			if winner == nil then 
				write("It was a tie!Vote again!")
				wait(5)
				doneVoting.Value = false
				timeLeft.Value = 10
			else 
				write(winner.." got the most votes!")
				wait(5)
				write(winner.." Chosen")
				wait(2)

				if type == 1 then
					return winner 
				else
					return Chosen[winner] 
				end

			end
		end
		timeLeft.Value = timeLeft.Value -1 
		Status.Value = timeLeft.Value.."seconds left to vote"
	end
end

for i , Pad in pairs(game.Workspace.VotingSystem:GetChildren()) do --add value
	if Pad.Name ~= "VotingDisplay" then
		Pad.Touched:Connect(function(hit)
			if hit.parent:FindFirstChild("Humanoid") then
				local char = hit.Parent
				local player = game.Players:GetPlayerFromCharacter(char)

				if player.Vote.Value ~= Pad then
					Pad.Votes.Value = Pad.Votes.Value +1 
					if player.Vote.Value ~="NA" then
						local padToSuntract = VotingSystem:FindFirstChild(player.Vote.Value)
						padToSuntract.Votes.Value = padToSuntract.Votes.Value -1
					end
					player.Vote.Value = Pad.Name
					updateDisplay()
				end
			end
		end)
	end
end
