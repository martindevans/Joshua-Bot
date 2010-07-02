-- Written by Martin
-- martindevans@gmail.com
-- http://martindevans.appspot.com/blog

AirBase = {}

AirBase.new = function(unitID)	
	if (unitID:GetUnitType() ~= "AirBase") then
		error("Tried to created an airbase on a unitID of type " .. unitID:GetUnitType())
	end
	
	local t = {}

	t.unitId = unitID
	t.longitude = unitID:GetLongitude()
	t.latitude = unitID:GetLatitude()
	
	t.launchFighter = function(longitude, latitude)
		t.unitId:SetActionTarget(nil, longitude, latitude)
	end
	
	return t
end