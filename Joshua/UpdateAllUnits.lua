-- Written by Martin
-- martindevans@gmail.com
-- http://martindevans.appspot.com/blog

UpdateAllUnits = {}

local unitData = {}

UpdateAllUnits.Update = function(JoshuaInstance)
	GetAllUnitData(unitData)
	
	names = Set.new()
	
	local count = 0
	for id, data in pairs(unitData) do
		local unitType = data.type
		names.Add(unitType)
		if (unitType == "AirBase") then
			
		elseif (unitType == "BattleShip") then
			
		elseif (unitType == "Bomber") then
			
		elseif (unitType == "Carrier") then
			
		elseif (unitType == "Fighter") then
			
		elseif (unitType == "Fleet") then
			
		elseif (unitType == "Gunshot") then
			local team = data.team
			SendChat("A gunshot")
			JoshuaInstance.ShotTrackers[team].UpdateUnit(v)
		elseif (unitType == "Nuke") then
		
		elseif (unitType == "RadarStation") then
		
		elseif (unitType == "Silo") then
			
		elseif (unitType == "Sub") then
			
		else
			SendChat("Unknown unit type " .. unitType)
		end
	end
end