--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "RadioSY"
local resourceDescription = "Sistema de Rádio"
theStation = defaultStation
theRemixer = ""
defaultState = ""

-- this will start the radio
function playRadio()
	triggerClientEvent(source, "onStationRadio", source, theStation, theRemixer)
end

-- this will set a station to the radio
function setStation(theClient, theCommand, theURL)
	if(hasObjectPermissionTo(theClient, "function.kickPlayer")) then
		if(theURL) then
			theStation = theURL
			outputChatBox("#CCCCCCO staff #FFCC40"..getPlayerName(theClient).."#CCCCCC alterou o status da Rádio BnF™ para ~ Locutor Automático.", getRootElement(), 255,255,255, true)
		else
			theStation = defaultStation
			outputChatBox("#CCCCCCO staff #FFCC40"..getPlayerName(theClient).."#CCCCCC alterou o status da Rádio BnF™ para ~ Ao Vivo.", getRootElement(), 255,255,255, true)
		end
		for _, player in ipairs(getElementsByType("player")) do
			triggerClientEvent(player, "onStationRadio", player, theStation, theRemixer)
		end
	else
		theClient:outputChat("Você não tem permissão para fazer isso!")
	end
end

-- this will set a remixer to the radio
function setRemixer(theClient, theCommand, theName)
	if(hasObjectPermissionTo(theClient, "function.kickPlayer")) then
		if(theName) then
			theRemixer = theName
			theClient:outputChat("Você definiu o nome do Remixer da estação. Digite /radio para atualizar os ouvintes.")
		else
			theRemixer = ""
			theClient:outputChat("Você removeu o nome do Remixer da estação. Digite /radio para atualizar os ouvintes.")
		end
	else
		theClient:outputChat("Você não tem permissão para fazer isso!")
	end
end

-- events & commands
addEventHandler("onPlayerJoin", getRootElement(), playRadio)
addCommandHandler("radio", setStation)
addCommandHandler("remixer", setRemixer)