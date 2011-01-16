-- Written by Martin
-- martindevans@gmail.com
-- http://martindevans.appspot.com/blog

SurveyCities = {}

SurveyCities.ScanWorld = function(Joshua)
	Multithreading.StartLongTask(function()
		SendChat("Starting City Scan")
		
		local allCities = GetCityIDs()
		local us = GetOwnTeamID()
		
		subdivide = function(node)
			if (node.CityCount > 1 and node.Depth() < 5) then
				node.Subdivide()
				node.TopLeft.Cities = {}
				node.TopLeft.CityCount = 0
				node.TopRight.Cities = {}
				node.TopRight.CityCount = 0
				node.BottomLeft.Cities = {}
				node.BottomLeft.CityCount = 0
				node.BottomRight.Cities = {}
				node.BottomRight.CityCount = 0
				
				for _, c in ipairs(node.Cities) do
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
			local long, lat, pop = city:GetLongitude(), city:GetLatitude(), city:GetCityPopulation()
			Whiteboard.DrawSquare(long, lat, pop / 1000000)
			
			local c = {}
			c.City = city
			c.Longitude = long
			c.Latitude = lat
			c.Population = pop
			
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
		
		SendChat("City Scan Complete")
	end)
end