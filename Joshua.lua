-- Written by Martin
-- martindevans@gmail.com
-- http://martindevans.appspot.com/blog

require "Joshua/CitySurvey"
require "Joshua/AirPatrol"
require "Joshua/AirBase"
require "Joshua/Deployment"
require "Joshua/Location"
require "Joshua/TeamShotTracker"
require "Joshua/UpdateAllUnits"

-- table acts as a namespace
Joshua = {}

Joshua.new = function()
	local t = {}
	
	t.cities = {}
	t.cities.allied = {}
	t.cities.enemy = {}
	
	t.units = {}
	t.units.airPatrol = AirPatrol.new()
	t.units.carriers = {}
	t.units.navalAirPatrol = AirPatrol.new()
	t.units.battleships = {}
	t.units.submarines = {}
	
	t.buildings = {}
	t.buildings.airbases = {}
	
	t.ShotTrackers = {}
	
	t.OnFirstTickDefcon5 = function()
		SendChat("Defcon 5")
		RequestGameSpeed(1)
		
		for _, v in pairs(GetAllTeamIDs()) do
			t.ShotTrackers[v] = TeamShotTracker.new()
		end
		
		SurveyCities(t)
		Deployment.DeployAirbases(t)
		
		Deployment.FetchUnits(t.buildings.airbases, "AirBase", AirBase.new)		
	end
	
	t.OnFirstTickDefcon4 = function()
		SendChat("Defcon 4")
	end
	
	t.OnFirstTickDefcon3 = function()
		SendChat("Defcon 3")
		
		Multithreading.StartLongTask(function()
			for _, v in pairs(t.buildings.airbases) do
				SendChat("Launching a fighter")
				v.launchFighter(v.longitude, v.latitude + 10)
				Whiteboard.DrawCross(v.longitude, v.latitude + 10, 1)
				WhiteboardDraw(v.longitude, v.latitude, v.longitude, v.latitude + 10)
				Multithreading.YieldLongTask()
			end
		end)
	end
	
	t.OnFirstTickDefcon2 = function()
		SendChat("Defcon 2")
	end
	
	t.OnFirstTickDefcon1 = function()
		SendChat("Defcon 1")
	end
	
	t.TickDefcon5 = function()
		
	end
	
	t.TickDefcon4 = function()
		
	end
	
	t.TickDefcon3 = function()
		UpdateAllUnits.Update(Instance)
	end
	
	t.TickDefcon2 = function()
		
	end
	
	t.TickDefcon1 = function()
		
	end
	
	return t
end