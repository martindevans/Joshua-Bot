-- Written by Martin
-- martindevans@gmail.com
-- http://martindevans.appspot.com/blog

require "Utilities/Queue"

local allottedTime
local startTime
local taskQueue = Queue.new()
local taskCount = 0

Multithreading = {}

Multithreading.TaskCount = function()
	return taskCount
end

Multithreading.YieldLongTask = function(unconditional)
	if (unconditional) then
		coroutine.yield()
	elseif (os.clock() - startTime >= allottedTime) then
		coroutine.yield()
	end
end

Multithreading.StartLongTask = function(f)
	taskQueue.enqueue(coroutine.create(f))
	taskCount = taskCount + 1
end

Multithreading.WorkOnLongTasks = function(allotted)
	allottedTime = allotted or 0.0001
	
	local count = 5
	while (allottedTime > 0 and count > 0) do	
		count = count - 1
		task = taskQueue.peek()
		if (task ~= nil) then
			if (coroutine.status(task) == "dead") then
				taskCount = taskCount - 1
				if (taskQueue.dequeue() ~= task) then
					error("Dequeue dead task does not equal this instance!")
				end
			else
				startTime = os.clock()
				assert(coroutine.resume(task))
				allottedTime = allottedTime - (os.clock() - startTime)
			end
		else
			break
		end
	end
end