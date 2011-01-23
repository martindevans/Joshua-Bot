Defcon3 = {}

Defcon3.FirstTick = function(Joshua)
	Multithreading.StartLongTask(function()
		for _, v in pairs(Joshua.buildings.airbases) do
			SendChat("Launching a fighter")
			
			v.launchFighter(v.longitude, v.latitude + 10)
			Multithreading.YieldLongTask()
			v.launchFighter(v.longitude + 10, v.latitude)
			Multithreading.YieldLongTask()
			v.launchFighter(v.longitude, v.latitude - 10)
			Multithreading.YieldLongTask()
			v.launchFighter(v.longitude - 10, v.latitude)
			Multithreading.YieldLongTask()
		end
	end)
end

local planes = nil

Defcon3.Tick = function(Joshua)

end