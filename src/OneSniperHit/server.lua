--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2018 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2018"
local resourceOfficialName = "OneSniperHit"
local resourceDescription = "Sistema para Matar com 1 tiro com a Sniper"

-- this will check the sniper hit to damange
function checkSniperHit(k, w)
	if(getElementType(source)=="player") then
		if(w==34) then
			killPed(source, k, 34)
		end
	end
end

-- events
addEventHandler("onPlayerDamage", getRootElement(), checkSniperHit)