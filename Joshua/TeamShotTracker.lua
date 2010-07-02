-- Written by Martin
-- martindevans@gmail.com
-- http://martindevans.appspot.com/blog

TeamShotTracker = {}

TeamShotTracker.new = function(TeamId)
	local t = {}
	
	t.TeamId = function()
		return TeamId
	end
	
	t.Hit = function(sourceId, targetId)
		local shot = t[sourceId]
		t[sourceId] = nil --remove this shot from tracker
		
		if (shot ~= nil) then
			local lastPos = nil
			if (shot ~= nil) then
				for _, v in pairs(shot) do
					if (lastPos ~= nil) then
						Whiteboard.DrawAToB(lastPos, v)
						lastPos = v
					end
				end
			end
		end
	end
	
	t.UpdateUnit = function(UnitId)
		if (t[UnitId] == nil) then
			t[UnitId] = {}
			SendChat("Don't shoot me :S")
		end
		table.insert(t[UnitId], Location.new(unitID:GetLongitude(), unitID:GetLatitude()))
	end
	
	return t
end