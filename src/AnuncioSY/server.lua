--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "AnuncioSY"
local resourceDescription = "Sistema de Anúncio"

-- this will send a advertisement to all players
function sendAd(theClient, theCommand, ...)
	if(hasObjectPermissionTo(theClient, "function.kickPlayer")) then
		arg = {...}
		adContent = table.concat(arg, " ")
		for _, player in ipairs(getElementsByType("player")) do
			if(theCommand=="anuncio") then
				triggerClientEvent(player, "onAdSend", player, adContent, "off")
			end
			if(theCommand=="o") then
				theStaff = getPlayerName(theClient):gsub('#%x%x%x%x%x%x', '')
				triggerClientEvent(player, "onAdSend", player, adContent, theStaff)
			end
		end
	else
		theClient:outputChat("Você não tem permissão para isso!")
	end
end

-- commands
addCommandHandler("anuncio", sendAd)
addCommandHandler("o", sendAd)