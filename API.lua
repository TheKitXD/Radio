local API = {}

API.Settings = require(script.Parent)

function API.IsOnRadioTeam(player:Player)
	local x = nil
	
	for i,v in pairs(API.Settings) do
		if player.Team == v.Team then
			x = true
		end
	end
	
	return x
end

function API.GetPlayerTeamList(player:Player)
	if API.IsOnRadioTeam(player) then
		for i,v in pairs(API.Settings) do
			if player.Team == v.Team then
				return v
			end
		end
	end
end

function API.AddRadio(player:Player)
	local Radio = script.Parent.Radio:Clone()
	Radio.Parent = player.PlayerGui
	
	return Radio
end

function API.RemoveRadio(player:Player)
	if player.PlayerGui:FindFirstChild('Radio') then
		player.PlayerGui.Radio:Destroy()
	end
end

function API.SetCallsign(player:Player, callsign:string)
	local Callsign
	
	for i,v in pairs(API.Settings) do
		if player.Team == v.Team then
			Callsign = v.Callsign
		end
	end
	
	player.Callsign.Value = "["..Callsign.."-"..callsign.."] -"
end

function API.GetAmountOfObjects(player:Player)
	if player.PlayerGui:FindFirstChild('Radio') then
		local x = -1
		
		for i,v in pairs(player.PlayerGui.Radio.MainUIObject.Radio:GetChildren()) do
			if v:IsA("Frame") then
				x += 1
			end
		end
		
		return x
	end
end

function API.NegateAllObject(frame)
	for i,v in pairs(frame:GetChildren()) do
		if v:IsA("Frame") then
			v.LayoutOrder -= 1
		end
	end
end

function API.GetZeroFrame(frame:Frame)
	for i,v in pairs(frame:GetChildren()) do
		if v:IsA('Frame') then
			if v.LayoutOrder == 0 then
				return v
			end
		end
	end
end

return API
