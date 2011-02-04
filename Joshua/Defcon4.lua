Defcon4 = {}

Defcon4.FirstTick = function(Joshua)
	--Deployment.DeployAirbases(Joshua)
	Deployment.DeployRadar(Joshua)
	
	Multithreading.StartLongTask(function()
		SendChat("Drawing RADAR range circles")
		local count = 0
		for k, v in pairs(Joshua.buildings.radars) do
			count = count + 1
			lat, long, range = v:GetLongitude(), v:GetLatitude(), 20 * 1 / (GetOptionValue ("WorldScale") / 100)
			Whiteboard.drawCircle(lat, long, range, 20)
			Multithreading.YieldLongTask(true)
		end
		SendChat(count .. " radar dishes")
	end)
	
	SendChat("Defcon 4")
end

Defcon4.Tick = function(Joshua)
	
end