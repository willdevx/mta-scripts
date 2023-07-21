--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "HeadShotSY"
local resourceDescription = "Sistema de HeadShot"

-- this will check the wasted kill way
function checkKill(ammo, killer, killerweapon, bodypart)
	if(killer) then
		if(getElementType(killer)=="player") then
			if(bodypart==9) then
				triggerClientEvent(killer, "onKillerMakeHeadshot", killer)
			end
		end
	end
end

-- events
addEventHandler("onPlayerWasted", getRootElement(), checkKill)