-- Written by Martin
-- martindevans@gmail.com
-- http://martindevans.appspot.com/blog

Whiteboard = {}

Whiteboard.clear = function()
	WhiteboardClear()
end

Whiteboard.drawCircle = function (x, y, radius)
	Multithreading.StartLongTask(function(x, y, radius)
		local segments = 7
		local theta_step = math.pi * 2 / segments
		local sin, cos = math.sin(theta_step), math.cos(theta_step)
		local dx = radius
		local dy = 0
		for i = 1, segments do
			local nx = cos * dx - sin * dy
			local ny = sin * dx + cos * dy
		
			WhiteboardDraw(x + dx, y + dy, x + nx, y + ny)
			dx, dy = nx, ny
		end
	end)
end

Whiteboard.DrawCross = function (long, lat, size)
	WhiteboardDraw(long - size, lat - size, long + size, lat + size)
	WhiteboardDraw(long - size, lat + size, long + size, lat - size)
end

Whiteboard.DrawBox = function(minX, minY, maxX, maxY)
	WhiteboardDraw(minX, minY, maxX, minY)
	WhiteboardDraw(maxX, minY, maxX, maxY)
	WhiteboardDraw(maxX, maxY, minX, maxY)
	WhiteboardDraw(minX, maxY, minX, minY)
end
	
Whiteboard.DrawSquare = function (x, y, size)
	WhiteboardDraw(x - size, y - size, x + size, y - size)
	WhiteboardDraw(x + size, y - size, x + size, y + size)
	WhiteboardDraw(x + size, y + size, x - size, y + size)
	WhiteboardDraw(x - size, y + size, x - size, y - size)
end

Whiteboard.DrawLine = function(x, y, x2, y2)
	WhiteboardDraw(x, y, x2, y2)
end

Whiteboard.DrawAToB = function(l1, l2)
	Whiteboard.DrawLine(l1.Longitude, l1.Latitude, l2.Longitude, l2.Latitude)
end
