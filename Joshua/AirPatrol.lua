-- Written by Martin
-- martindevans@gmail.com
-- http://martindevans.appspot.com/blog

AirPatrol = {}

AirPatrol.new = function()
	local t = {}
	t.fighters = {}
	t.bombers = {}
	
	t.protectionTargets = {}
	t.sources = {}
	
	t.AddNewProtectionTarget = function(unit)
		table.insert(t.protectionTargets, unit)
	end
	
	t.AddPlaneSource = function(unit)
		table.insert(t.sources, unit)
	end
	
	return t
end