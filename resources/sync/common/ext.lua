function round( n, precision )
	if precision then
		return math.floor( (n * 10^precision) + 0.5 ) / (10^precision)
	end
	
	return math.floor( n + 0.5 )
end

function find( tbl, value )
	if type( tbl ) ~= "table" then
		return nil
	end
	
	for k,v in pairs( tbl ) do
		if v == value then
			return k
		end
	end
	
	return nil
end

function findi( tbl, value )
	if type( tbl ) ~= "table" then
		return nil
	end
	
	value = string.lower( value )
	
	for k,v in pairs( tbl ) do
		if string.lower( v ) == value then
			return k
		end
	end
	
	return nil
end

-- Converts degrees to (inter)cardinal directions.
-- @param1	float	Degrees. Expects EAST to be 90° and WEST to be 270°.
-- 					In GTA, WEST is usually 90°, EAST is usually 270°. To convert, subtract that value from 360.
--
-- @return			The converted (inter)cardinal direction.
function degreesToIntercardinalDirection( dgr )
	dgr = dgr % 360.0
	
	if (dgr >= 0.0 and dgr < 22.5) or dgr >= 337.5 then
		return "N "
	elseif dgr >= 22.5 and dgr < 67.5 then
		return "NE"
	elseif dgr >= 67.5 and dgr < 112.5 then
		return "E"
	elseif dgr >= 112.5 and dgr < 157.5 then
		return "SE"
	elseif dgr >= 157.5 and dgr < 202.5 then
		return "S"
	elseif dgr >= 202.5 and dgr < 247.5 then
		return "SW"
	elseif dgr >= 247.5 and dgr < 292.5 then
		return "W"
	elseif dgr >= 292.5 and dgr < 337.5 then
		return "NW"
	end
end