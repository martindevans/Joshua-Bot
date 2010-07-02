-- Make require look in this folder
package.path = debug.getinfo(1, "S").source:match[[^@?(.*[\/])[^\/]-$]] .."?.lua;".. package.path

-- Load up required files
require "Whiteboard"
require "Utilities/Multithreading"
require "Utilities/Set"

require "Joshua"

--Variables
DefconLevel = 6

Instance = Joshua.new()

function OnInit()
	SendChat("/name [Lua Bot]Joshua")
	SendChat("Hello, I am Joshua, I'm a bot written by martin")
	SendChat("I'm written using the lua version of the defcon API")
	SendChat("you can contact martin via the forums, or email (martindevans@gmail.com)")
end

function OnTick()
	if (DefconLevel ~= GetDefconLevel()) then
		DefconLevel = GetDefconLevel()
		if (DefconLevel == 5) then
			Instance.OnFirstTickDefcon5()
		elseif (DefconLevel == 4) then
			Instance.OnFirstTickDefcon4()
		elseif (DefconLevel == 3) then
			Instance.OnFirstTickDefcon3()
		elseif (DefconLevel == 2) then
			Instance.OnFirstTickDefcon2()
		elseif (DefconLevel == 1) then
			Instance.OnFirstTickDefcon1()
		end
	end

	if (DefconLevel == 5) then
		Instance.TickDefcon5()
	elseif (DefconLevel == 4) then
		Instance.TickDefcon4()
	elseif (DefconLevel == 3) then
		Instance.TickDefcon3()
	elseif (DefconLevel == 2) then
		Instance.TickDefcon2()
	elseif (DefconLevel == 1) then
		Instance.TickDefcon1()
	end

	Multithreading.WorkOnLongTasks()
end

function OnEvent(eventType, sourceID, targetID, unitType, longitude, latitude)
	if (eventType == "CeasedFire") then
		--A team ceased fire to another team.
	elseif (eventType == "Destroyed") then
		--An object has been destroyed.
	elseif (eventType == "Hit") then
		--An object has been hit by a gunshot (ie. from a battleship, fighter etc).
		local tracker = Instance.ShotTrackers[sourceID:GetTeamID()]
		tracker.Hit(sourceID, targetID)
	elseif (eventType == "NewVote") then
		--A new vote has been started
	elseif (eventType == "NukeLaunchSilo") then
		--A missile has been launched from a silo at given coordinates.
	elseif (eventType == "NukeLaunchSub") then
		--A missile has been launched from a sub at given coordinates.
	elseif (eventType == "PingCarrier") then
		--A sonar ping from a carrier has been detected (gives object id).
	elseif (eventType == "PingDetection") then
		--An object has been detected by a ping event (reveals type and coordinates).
	elseif (eventType == "PingSub") then
		--A sonar ping from a submarine has been detected (only reveals coordinates).
	elseif (eventType == "SharedRadar") then
		--A team shared its radar with another team.
	elseif (eventType == "TeamRetractedVote") then
		--?
	elseif (eventType == "TeamVoted") then
		--?
	elseif (eventType == "UnceasedFire") then
		--A cease fire agreement has been ended.
	elseif (eventType == "UnsharedRadar") then
		--A team stopped sharing its radar with another team.
	elseif (eventType == "VoteFinishedNo") then
		--A vote finished with no result/change.
	elseif (eventType == "VoteFinishedYes") then
		--A vote finished, and its contents were accepted.
	end
end
