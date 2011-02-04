-- Written by Martin
-- martindevans@gmail.com
-- http://martindevans.appspot.com/blog

Survey = {}

Survey.ScanCities = function(Joshua)
	Multithreading.StartLongTask(function()
		local allCities = GetCityIDs()
		local us = GetOwnTeamID()
		
		SendChat("Surveying cities")
		
		subdivide = function(node)
			if (node.CityCount > 1 and node.Depth() < 10) then
				node.Subdivide()
				node.TopLeft.Cities = {}
				node.TopLeft.CityCount = 0
				node.TopRight.Cities = {}
				node.TopRight.CityCount = 0
				node.BottomLeft.Cities = {}
				node.BottomLeft.CityCount = 0
				node.BottomRight.Cities = {}
				node.BottomRight.CityCount = 0
				
				for _, c in pairs(node.Cities) do
					if node.TopLeft.ContainsPoint(c.Longitude, c.Latitude) then
						table.insert(node.TopLeft.Cities, c)
					elseif node.TopRight.ContainsPoint(c.Longitude, c.Latitude) then
						table.insert(node.TopRight.Cities, c)
					elseif node.BottomLeft.ContainsPoint(c.Longitude, c.Latitude) then
						table.insert(node.BottomLeft.Cities, c)
					elseif node.BottomRight.ContainsPoint(c.Longitude, c.Latitude) then
						table.insert(node.BottomRight.Cities, c)
					end
				end
				
				subdivide(node.TopLeft)
				Multithreading.YieldLongTask()
				subdivide(node.TopRight)
				Multithreading.YieldLongTask()
				subdivide(node.BottomLeft)
				Multithreading.YieldLongTask()
				subdivide(node.BottomRight)
				Multithreading.YieldLongTask()
			end
		end
		
		for i, city in ipairs(allCities) do
			local long, lat, pop, team = city:GetLongitude(), city:GetLatitude(), city:GetCityPopulation(), city:GetTeamID()
			
			local c = {}
			c.City = city
			c.Longitude = long
			c.Latitude = lat
			c.Population = pop
			c.Team = team
			
			table.insert(Joshua.cities.all, c)
			if city:GetTeamID() == us then
				table.insert(Joshua.cities.allied, c)
			else
				table.insert(Joshua.cities.enemy, c)
			end
			
			Multithreading.YieldLongTask()
			
			local leaf = Joshua.Quadtree.Root.FindLeafNode(long, lat)
			if (leaf ~= nil) then
				if leaf.Cities == nil then
					leaf.Cities = {}
					leaf.CityCount = 0
				end
				
				table.insert(leaf.Cities, c)
				leaf.CityCount = leaf.CityCount + 1
				
				subdivide(leaf)
			else
				SendChat("No contains node " .. c.Longitude .. " " .. c.Latitude)
			end
		end
		
		table.sort(Joshua.cities.all, function(a, b) return a.Population < b.Population end)
		table.sort(Joshua.cities.allied, function(a, b) return a.Population < b.Population end)
		table.sort(Joshua.cities.enemy, function(a, b) return a.Population < b.Population end)
	end)
end

Survey.ScanEnemyTerritory = function(Joshua)
	Multithreading.StartLongTask(function()
		local teams = {}
		local teamCount = 0
		
		getTable = function(teamId)
			if teams[teamId] == nil then
				teams[teamId] = {}
				teamCount = teamCount + 1
			end
			return teams[teamId]
		end
		
		SendChat("Classifying enemy cities")
		for k, v in pairs(Joshua.cities.enemy) do
			table.insert(getTable(v.Team), Location.new(v.Longitude, v.Latitude))
			Multithreading.YieldLongTask()
		end
		
		scanOut = function(location, team)
			for i = 0, 360, 6 do
				radians = math.rad(i)
				radius = 0
				step = 10
				testPoint = nil
				--establish a point which is outside the territory
				repeat
					radius = radius + step
					testPoint = Location.new(location.Longitude + math.sin(radians) * radius, location.Latitude + math.cos(radians) * radius)
					Multithreading.YieldLongTask()
				until not IsValidTerritory(team, testPoint.Longitude, testPoint.Latitude, false)
				
				--binary search to find a more accurate border point
				maxRadius = radius
				for i = 0, 10, 1 do
					if IsValidTerritory(team, testPoint.Longitude, testPoint.Latitude, false) then
						radius = radius + maxRadius / math.pow(2, i + 1)
					else
						radius = radius - maxRadius / math.pow(2, i + 1)
					end
					testPoint = Location.new(location.Longitude + math.sin(radians) * radius, location.Latitude + math.cos(radians) * radius)
					Multithreading.YieldLongTask()
				end
				
				Whiteboard.DrawCross(testPoint.Longitude, testPoint.Latitude, 1)
			end
			Multithreading.YieldLongTask()
		end
		
		for teamId, startPoints in pairs(teams) do
			SendChat("Scanning " .. teamId:GetTeamName())
			for _, p in pairs(startPoints) do
				scanOut(p, teamId)
				Multithreading.YieldLongTask()
			end
			Multithreading.YieldLongTask()
		end
	end)
end