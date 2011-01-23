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

require "Joshua/Defcon5"
require "Joshua/Defcon4"
require "Joshua/Defcon3"
require "Joshua/Defcon2"
require "Joshua/Defcon1"

require "Utilities/Quadtree"
require "whiteboard"

Joshua = {}

Joshua.new = function()
	local t = {}

	t.EnforceRequiredSpeed = false
	t.RequiredSpeed = 1
	
	t.Quadtree = Quadtree.new(-180, -90, 180, 90)

	t.cities = {}
	t.cities.all = {}
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
	t.buildings.silos = {}
	t.buildings.radars = {}

	t.ShotTrackers = {}
	
	t.OnFirstTickDefcon5 = function() Defcon5.FirstTick(t) end
	t.OnFirstTickDefcon4 = function() Defcon4.FirstTick(t) end
	t.OnFirstTickDefcon3 = function() Defcon3.FirstTick(t) end
	t.OnFirstTickDefcon2 = function() Defcon2.FirstTick(t) end
	t.OnFirstTickDefcon1 = function() Defcon1.FirstTick(t) end

	t.TickDefcon5 = function() Defcon5.Tick(t) end
	t.TickDefcon4 = function() Defcon4.Tick(t) end
	t.TickDefcon3 = function() Defcon3.Tick(t) end
	t.TickDefcon2 = function() Defcon2.Tick(t) end
	t.TickDefcon1 = function() Defcon1.Tick(t) end
	
	t.Tick = function()
		UpdateAllUnits.Update(Instance)
	
		if t.EnforceRequiredSpeed then
			RequestGameSpeed(t.RequiredSpeed)
		end
	end

	return t
end
