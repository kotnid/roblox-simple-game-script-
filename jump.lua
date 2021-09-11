-- StarterPlayer/StaterPlayerScripts/LocalScript

local userInputService = game:GetService("UserInputService")
local Player = script.Parent.Parent

function jumpRequest()
	print("jump")
	local leaderstats = Player.leaderstats
	local jumpStat = leaderstats and leaderstats:FindFirstChild("JUMP")
	if jumpStat then
		jumpStat.Value = jumpStat.Value + 1
	end
end

userInputService.JumpRequest:Connect(jumpRequest)
