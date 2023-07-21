--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "GoPosSY"
local resourceDescription = "Sistema de Setar Posições"

-- this will set the player position
function setPosition(theClient, theCommand, x, y, z)
	if(hasObjectPermissionTo(theClient, "function.kickPlayer")) then
		if(x and y and z) then
			setElementPosition(theClient, x, y, z)
		else
			theClient:outputChat("* Por favor, informe o x, y e z.",255,0,0)
		end
	else
		theClient:outputChat("* Você não tem permissão para fazer isso.")
	end
end

-- command
addCommandHandler("setar", setPosition)