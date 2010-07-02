-- Written by Martin
-- martindevans@gmail.com
-- http://martindevans.appspot.com/blog

Location = {}

Location.new = function(long, lat)
	local t = {}
	
	t.Longitude = long
	t.Latitude = lat
	
	return t
end