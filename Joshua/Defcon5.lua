Defcon5 = {}

Defcon5.FirstTick = function(Joshua)
	for _, v in pairs(GetAllTeamIDs()) do
		Joshua.ShotTrackers[v] = TeamShotTracker.new()
	end
	
	Survey.ScanCities(Joshua)
	Survey.ScanEnemyTerritory(Joshua)
	
	Multithreading.StartLongTask(function()
		Whiteboard.clear()
		Multithreading.YieldLongTask()
		
		Joshua.Quadtree.Draw(function(a, b, c, d)
			Multithreading.StartLongTask(function()
				Whiteboard.DrawLine(a, b, c, d)
				Multithreading.YieldLongTask()
			end)
		end)
	end)
end

Defcon5.Tick = function(Joshua)
	
end