Defcon4 = {}

Defcon4.FirstTick = function(Joshua)
	--Deployment.DeployAirbases(Joshua)
	Deployment.DeployRadar(Joshua)

	--Deployment.FetchUnits(Joshua.buildings.airbases, "AirBase", AirBase.new)
	Deployment.FetchUnits(Joshua.buildings.radars, "RadarStation", function(a) return a end)
	
	Multithreading.StartLongTask(function()
		SendChat("Finding radars")
		local count = 0
		for _, v in ipairs(Joshua.buildings.radars) do
			count = count + 1
			lat, long, range = v:GetLongitude(), v:GetLatitude(), v:GetRange()
			Whiteboard.drawCircle(lat, long, range)
			SendChat(lat .. " " .. long .. " " .. range)
		end
		SendChat(count .. " radar dishes")
	end)
	
	SendChat("Defcon 4")
end

Defcon4.Tick = function(Joshua)
	
end