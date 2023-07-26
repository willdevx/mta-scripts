--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "Position"
local resourceDescription = "Sistema para mostrar a posição"

-- this will get the player position
function getPosition(theClient)
	x,y,z = getElementPosition(theClient)
	theClient:outputChat("* Sua posição é (x,y,z): #FF9900"..x.."#FFFFFF, #FF9900"..y.."#FFFFFF, #FF9900"..z,255,255,255,true)
end

-- command
addCommandHandler("pos", getPosition)