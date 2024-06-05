local API = require(script.Parent:WaitForChild('API'))

function addRadio(player)
	local Radio = API.AddRadio(player)
	local TeamData = API.GetPlayerTeamList(player)
	local tsdb = false
	
	Radio.LocalScript.Enabled = true
	
	Radio.MainUIObject.Panic.MouseButton1Click:Connect(function()
		if API.IsOnRadioTeam(player) then	
			for i,x in pairs(game:GetService('Players'):GetPlayers()) do
				if API.GetAmountOfObjects(x) >= 5 then	
					local f = API.GetZeroFrame(x.PlayerGui.Radio.MainUIObject.Radio) f:Destroy()
					API.NegateAllObject(x.PlayerGui.Radio.MainUIObject.Radio)
				end

				if x.PlayerGui:FindFirstChild('Radio') then
					local RadioInstance = script.Parent.RadioInstance:Clone()
					RadioInstance.Parent = x.PlayerGui.Radio.MainUIObject.Radio
					RadioInstance.Text.TextColor = BrickColor.new('Really red')
					RadioInstance.Text.Text = player.Callsign.Value.." has pressed the panic button!"
					RadioInstance.Visible = true
					print(API.GetAmountOfObjects(x))
					RadioInstance.LayoutOrder += API.GetAmountOfObjects(x)
					print(RadioInstance.LayoutOrder)
				end
			end
		end
	end)
	
	Radio.MainUIObject.Transmitting.MouseButton1Click:Connect(function()
		if tsdb == false then
			tsdb = true
			Radio.MainUIObject.Transmitting.BackgroundColor3 = Color3.fromRGB(0, 145, 17)
			player.Transmitting.Value = true
		else
			tsdb = false
			Radio.MainUIObject.Transmitting.BackgroundColor3 = Color3.fromRGB(145, 0, 0)
			player.Transmitting.Value = false
		end
	end)
	
	game:GetService('ReplicatedStorage').RadioStorage.TransmitRemote.OnServerEvent:Connect(function(LPlayer)
		if player == LPlayer then
			if tsdb == false then
				tsdb = true
				Radio.MainUIObject.Transmitting.BackgroundColor3 = Color3.fromRGB(0, 145, 17)
				player.Transmitting.Value = true
			else
				tsdb = false
				Radio.MainUIObject.Transmitting.BackgroundColor3 = Color3.fromRGB(145, 0, 0)
				player.Transmitting.Value = false
			end
		end
	end)
	
	return Radio
end

game.Players.PlayerAdded:Connect(function(player:Player)
	local Callsign = Instance.new('StringValue', player) 
	Callsign.Name = 'Callsign' 
	Callsign.Value = ''
	
	local Channel = Instance.new('StringValue',player) 
	Channel.Name = 'Channel' 
	Channel.Value = ''
	
	local Transmitting = Instance.new('BoolValue', player) 
	Transmitting.Name = 'Transmitting' 
	Transmitting.Value = false
	
	player:GetPropertyChangedSignal('Team'):Connect(function()
		Callsign.Value = ''
		Transmitting.Value = false
		Channel.Value = ''
		
		if API.IsOnRadioTeam(player) then
			if player.PlayerGui:FindFirstChild('Radio') then
				API.RemoveRadio(player)
				
				local Radio = addRadio(player)
			else
				local Radio = addRadio(player)
			end
		else
			API.RemoveRadio(player)
			Transmitting.Value = false
			Channel.Value = ''
			Callsign.Value = ''
		end
	end)
	
	player.Chatted:Connect(function(message:string)
		if API.IsOnRadioTeam(player) and Transmitting.Value == true then	
			for i,x in pairs(game:GetService('Players'):GetPlayers()) do
				if API.GetAmountOfObjects(x) >= 5 then	
					local f = API.GetZeroFrame(x.PlayerGui.Radio.MainUIObject.Radio) f:Destroy()
					API.NegateAllObject(x.PlayerGui.Radio.MainUIObject.Radio)
				end
				
				if x.PlayerGui:FindFirstChild('Radio') then
					local RadioInstance = script.Parent.RadioInstance:Clone()
					RadioInstance.Parent = x.PlayerGui.Radio.MainUIObject.Radio
					RadioInstance.Text.Text = player.Callsign.Value.." "..message
					RadioInstance.Visible = true
					print(API.GetAmountOfObjects(x))
					RadioInstance.LayoutOrder += API.GetAmountOfObjects(x)
					print(RadioInstance.LayoutOrder)
				end
			end
		end
	end)
	
	game:GetService('ReplicatedStorage').RadioStorage.CallsignChoosen.OnServerEvent:Connect(function(LPlayer, callsign:string)
		if LPlayer == player then
			API.SetCallsign(LPlayer, callsign)
			
			player.PlayerGui.Radio.MainUIObject.CallsignChooser.Visible = false
		end
	end)
end)
