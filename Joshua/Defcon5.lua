Defcon5 = {}

Defcon5.FirstTick = function(Joshua)
	Joshua.RequiredSpeed = 1
	Joshua.EnforceRequiredSpeed = true
	
	for _, v in pairs(GetAllTeamIDs()) do
		Joshua.ShotTrackers[v] = TeamShotTracker.new()
	end
	
	SurveyCities.ScanWorld(Joshua)
	
	Multithreading.StartLongTask(function()
		Whiteboard.clear()
	
		Joshua.Quadtree.Draw(function(a, b, c, d)
			Multithreading.StartLongTask(function()
				Whiteboard.DrawLine(a, b, c, d)
				Multithreading.YieldLongTask()
			end)
		end)
			
		Joshua.RequiredSpeed = 20
	end)
end

Defcon5.Tick = function(Joshua)
	
end