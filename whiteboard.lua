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

Whiteboard.DrawNumber = function(number, x, y, width, height)
	if number == 0 then
		Whiteboard.DrawLine(x, y, x + width, y)
		Whiteboard.DrawLine(x + width, y, x + width, y + height * 2)
		Whiteboard.DrawLine(x, y + height, x + size, y + height)
		Whiteboard.DrawLine(x, y, x, y + height)
	elseif number == 1 then
		Whiteboard.DrawLine(x, y + height / 2, x + width / 2, y)
		Whiteboard.DrawLine(x + width / 2, y, x + width / 2, y + height)
		Whiteboard.DrawLine(x, y + height, x + width, y + height)
	elseif number == 2 then
		Whiteboard.DrawLine(x, y, x + width, y)
		Whiteboard.DrawLine(x + width, y, x + width, y + height / 2)
		Whiteboard.DrawLine(x, y + height / 2, x + width, y + height / 2)
		Whiteboard.DrawLine(x, y, x, y + height / 2)
		Whiteboard.DrawLine(x, y + height, x + width, y + height)
	elseif number == 3 then
		Whiteboard.DrawLine(x, y, x + width, y)
		Whiteboard.DrawLine(x, y + height / 2, x + width, y + height / 2)
		Whiteboard.DrawLine(x, y + height, x + width, y + height)
		Whiteboard.DrawLine(x + width, y, x + width, y + height)
	elseif number == 4 then
		Whiteboard.DrawLine(x, y, x, y + height / 2)
		Whiteboard.DrawLine(x, y + height / 2, x + width, y + height / 2)
		Whiteboard.DrawLine(x + width, y, x + width, y + height)
	elseif number == 5 then
	
	elseif number == 6 then
	
	elseif number == 7 then
	
	elseif number == 8 then
	
	elseif number == 9 then
	
	end
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
