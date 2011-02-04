-- Written by Martin
-- martindevans@gmail.com
-- http://martindevans.appspot.com/blog

require "Utilities/Minmaxheap"

--DeploySubs
--DeployRadar
--DeploySilos
--DeployAirbases
--DeployFleet
Deployment = {}
local helpers = {}

local siloPlacementScoreInfluenceRange = 5

Deployment.DeployRadar = function(JoshuaInstance)
	Multithreading.StartLongTask(function()
		SendChat("Starting Deploying RADAR")
		
		Whiteboard.clear()
		local minLatitude, minLongitude, maxLatitude, maxLongitude = helpers.GenerateCityBoundingBox(JoshuaInstance)
		Whiteboard.clear()
		Whiteboard.DrawBox(minLongitude, minLatitude, maxLongitude, maxLatitude)
		
		SendChat("Generating score set")
		set = helpers.GenerateScoreSet(JoshuaInstance, minLatitude, minLongitude, maxLatitude, maxLongitude)
		Whiteboard.clear()
		SendChat("done")
		
		local available = GetRemainingUnits("RadarStation")
		local placed = 0
		while placed < available do
			local maxPoint = set.DeleteMax()
			local long, lat, score = maxPoint.longitude, maxPoint.latitude, maxPoint.score
			if (IsValidPlacementLocation(long, lat, "RadarStation")) then
				PlaceStructure(long, lat, "RadarStation")
				placed = placed + 1
				Multithreading.YieldLongTask(true)
				Multithreading.YieldLongTask(true)
				Multithreading.YieldLongTask(true)
			else
				Multithreading.YieldLongTask()
			end
		end
		
		SendChat(placed .. " of " .. available .. " available buildings")
		
		Multithreading.YieldLongTask(true)
		
		local returned = 0
		while returned < placed do
			Multithreading.YieldLongTask(true)
			returned = Deployment.FetchUnits(JoshuaInstance.buildings.radars, "RadarStation", function(a) return a end)
		end
		
		SendChat("RADAR Deployed")
	end)
end

Deployment.DeployAirbases = function(JoshuaInstance)
	Multithreading.StartLongTask(function()
		SendChat("Starting deploying airbases")
		
		Whiteboard.clear()
		local minLatitude, minLongitude, maxLatitude, maxLongitude = helpers.GenerateCityBoundingBox(JoshuaInstance)
		Whiteboard.clear()
		Whiteboard.DrawBox(minLongitude, minLatitude, maxLongitude, maxLatitude)
		
		SendChat("Generating score set")
		set = helpers.GenerateScoreSet(JoshuaInstance, minLatitude, minLongitude, maxLatitude, maxLongitude)
		Whiteboard.clear()
		SendChat("done")
		
		while GetRemainingUnits("AirBase") > 0 do
			local maxPoint = set.DeleteMax()
			local long, lat, score = maxPoint.longitude, maxPoint.latitude, maxPoint.score
			PlaceStructure(long, lat, "AirBase")
			Multithreading.YieldLongTask()
		end
	end)
end

Deployment.FetchUnits = function(targetTable, unitType, newMethod)
	local allMyUnits = GetOwnUnits()
	local count = 0
	for index, id in pairs(allMyUnits) do
		if (id:GetUnitType() == unitType) then
			targetTable[count] = newMethod(id)
			count = count + 1
		end
		Multithreading.YieldLongTask()
	end
	
	return count
end

helpers.GenerateScoreSet = function(JoshuaInstance, minLatitude, minLongitude, maxLatitude, maxLongitude)
	scoreHeap = MinMaxHeap.new()
	local mt = { __lt = function(a, b)
		return a.score < b.score
	end }
	
	local values = {}
	
	for longitude = minLongitude, maxLongitude, 1 do
		for latitude = minLatitude, maxLatitude, 1 do
			local t = { longitude = longitude, latitude = latitude, score = helpers.CalculatePopulationField(JoshuaInstance, longitude, latitude) }
			setmetatable(t, mt)
			table.insert(values, t)
			Multithreading.YieldLongTask()
		end
		WhiteboardDraw(longitude, minLatitude, longitude, maxLatitude)
	end
	
	scoreHeap.AddMany(values)
	
	return scoreHeap
end

helpers.GenerateCityBoundingBox = function(JoshuaInstance)
	minLatitude = 1000000;
	minLongitude = 1000000;
	maxLatitude = -1000000;
	maxLongitude = -1000000;
	
	for i, city in ipairs(JoshuaInstance.cities.allied) do
		local long, lat, pop = city.Longitude, city.Latitude, city.Population
		
		if lat < minLatitude then
			minLatitude = lat
		elseif lat > maxLatitude then
			maxLatitude = lat
		end
		
		if long < minLongitude then
			minLongitude = long
		elseif long > maxLongitude then
			maxLongitude = long
		end
		
		Whiteboard.DrawCross(long, lat, pop / 5000000)
		
		Multithreading.YieldLongTask()
	end
	
	return math.ceil(minLatitude), math.ceil(minLongitude), math.floor(maxLatitude), math.floor(maxLongitude)
end

helpers.CalculatePopulationField = function(JoshuaInstance, longitude, latitude)
	if (IsValidPlacementLocation (longitude, latitude, "Silo")) then
		local score = 0
		for i, city in ipairs(JoshuaInstance.cities.allied) do
			local long, lat, pop = city.Longitude, city.Latitude, city.Population
			score = score + pop / math.pow(math.pow((long - longitude), 2) + math.pow((lat - latitude), 2), 0.5)
			Multithreading.YieldLongTask()
		end
		return score
	else
		return 0
	end
end