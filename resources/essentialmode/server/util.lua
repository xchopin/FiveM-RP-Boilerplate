function stringsplit(self, delimiter)
  local a = self:Split(delimiter)
  local t = {}

  for i = 0, #a - 1 do
     table.insert(t, a[i])
  end

  return t
end

function startswith(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function returnIndexesInTable(t)
	local i = 0;
	for _,v in pairs(t)do
 		i = i + 1
	end
	return i;
end

function debugMsg(msg)
  if(settings.defaultSettings.debugInformation and msg)then
    print("ES_DEBUG: " .. msg)
  end
end

AddEventHandler("es:debugMsg", debugMsg)