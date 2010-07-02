-- Written by Martin
-- martindevans@gmail.com
-- http://martindevans.appspot.com/blog

function SurveyCities(Joshua)
	Multithreading.StartLongTask(
		function()
			SendChat("Starting City Survey")
			local allCities = GetCityIDs()
			local us = GetOwnTeamID()
			for i, city in ipairs(allCities) do
				local long, lat, pop = city:GetLongitude(), city:GetLatitude(), city:GetCityPopulation()
				if city:GetTeamID() == us then
					Whiteboard.DrawSquare(long, lat, pop / 5000000)
					table.insert(Joshua.cities.allied, city)
				else
					Whiteboard.DrawCross(long, lat, pop / 5000000)
					table.insert(Joshua.cities.enemy, city)
				end
				Multithreading.YieldLongTask()
			end
			table.sort(Joshua.cities.allied, function(a, b) return a:GetCityPopulation() < b:GetCityPopulation() end)
			table.sort(Joshua.cities.enemy, function(a, b) return a:GetCityPopulation() < b:GetCityPopulation() end)
			SendChat("City Survey Complete")
		end
	)
end