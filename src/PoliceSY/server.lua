--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2018 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2018"
local resourceOfficialName = "PoliceSY"
local resourceDescription = "Sistema de Polícia"

-- this will create the clean wanted area
thePoliceStationMarker = createMarker(1555.478515625, -1675.568359375, 16.1953125-1, "cylinder", 2.5, 0, 0, 255, 255)
theBlip = createBlipAttachedTo(thePoliceStationMarker, 30)

-- this will clean the player wanted level
function cleanPlayerWanted(theClient)
	if(isElementWithinMarker(theClient, thePoliceStationMarker)) then
		if(getPlayerMoney(theClient)>=750) then
			takePlayerMoney(theClient, 750)
			setPlayerWantedLevel(theClient, 0)
			theClient:outputChat("*-------------------------------------------------*", 0, 0, 200)
			theClient:outputChat("           Você limpou a sua ficha!", 255, 255, 255)
			theClient:outputChat("           Custo pago: R$750,00", 255, 255, 255)
			theClient:outputChat("*-------------------------------------------------*", 0, 0, 200)
		else
			theClient:outputChat("* Desculpe, mas você não tem dinheiro suficiente. (R$750,00)", 255, 0, 0)
		end
	end
end

-- this will show the clean wanted command
function showCleanCommandMessage(hitElement)
	if(getElementType(hitElement)=="player") then
		hitElement:outputChat("* Digite [/limparficha] (R$750,00) para retirar os seus níveis de procurado.")
	end
end

-- this will check the police for player wanted status
function checkWanted(theClient, theCommand, thePlayer)
	if(checkPolicePermission(theClient)==true) then
		if(thePlayer) then
			if(getElementByData(thePlayer)) then
				thePlayer = getElementByData(thePlayer)
				if(thePlayer~=theClient) then
					triggerClientEvent(theClient, "checkPlayerRangePosition", theClient, "wanted", thePlayer)
				else
					theClient:outputChat("* Você não precisa se revistar.", 255, 0, 0)
				end
			else
				theClient:outputChat("* Não encontramos nenhum jogador com esta ID.", 255, 0, 0)
			end
		else
			theClient:outputChat("* Por favor, informe o ID do jogador que deseja revistar.", 255, 0, 0)
		end
	end
end

-- this will check the player wanted status
function checkConcededPlayerWanted(thePlayer)
	i = 0
	wantedStarsLevel = ""
	setPedAnimation(client, "police", "plc_drgbst_01", 3100, true, false, false, false)
	while i<getPlayerWantedLevel(thePlayer) do
		i = i+1
		wantedStarsLevel = wantedStarsLevel.."★"
	end
	client:outputChat("*-------------------------------------------------*", 255, 0, 0)
	client:outputChat("    Nível de procurado do indivíduo:", 255, 255, 255)
	if(getPlayerWantedLevel(thePlayer)>0) then
		setElementData(thePlayer, "abletojail", "yes")
		client:outputChat("    "..wantedStarsLevel.."  ("..getPlayerWantedLevel(thePlayer).." estrelas)", 255, 255, 255)
		client:outputChat("    Convém prender o indivíduo (/prender ID).", 255, 255, 255)
	else
		client:outputChat("    Nenhum nível (0 estrelas). Convém liberar o indivíduo.", 255, 255, 255)
	end
	client:outputChat("*-------------------------------------------------*", 255, 0, 0)
end

-- this will check the police to hold the wanted player in the jail
function holdToJailWantedPlayer(theClient, theCommand, thePlayer)
	if(checkPolicePermission(theClient)==true) then
		if(thePlayer) then
			if(getElementByData(thePlayer)) then
				thePlayer = getElementByData(thePlayer)
				if(thePlayer~=theClient) then
					triggerClientEvent(theClient, "checkPlayerRangePosition", theClient, "jail", thePlayer)
				else
					theClient:outputChat("* Você não precisa se prender.", 255, 0, 0)
				end
			else
				theClient:outputChat("* Não encontramos nenhum jogador com esta ID.", 255, 0, 0)
			end
		else
			theClient:outputChat("* Por favor, informe o ID do jogador que deseja prender.", 255, 0, 0)
		end
	end
end

-- this will hold the wanted player in the jail
function jailConcededPlayerWanted(thePlayer)
	if(getElementData(thePlayer, "abletojail")=="yes") then
		setElementFrozen(thePlayer, false)
		takeAllWeapons(thePlayer)
		setElementModel(thePlayer, 137)
		setElementDimension(thePlayer, 1)
		setElementInterior(thePlayer, 6)
		setElementPosition(thePlayer, 264.091796875, 77.3642578125, 1001.0390625)
		triggerClientEvent(thePlayer, "onHoldedInTheJail", thePlayer)
		setElementData(thePlayer, "abletojail", "in")
	else
		client:outputChat("* Não é possível prender um cidadão que não seja suspeito.", 255, 0, 0)
	end
end

-- this will left the player from the jail
function leftPlayerFromTheJail()
	setElementData(client, "abletojail", false)
	setPedAnimation(client)
	setPlayerWantedLevel(client, 0)
	setElementDimension(client, 0)
	setElementInterior(client, 0)
	setElementPosition(client, 1545.12109375, -1675.755859375, 13.559743881226)
	client:outputChat("* Você foi liberado da prisão. Todos os seus níveis de procurado foram retirados.", 0, 255, 0)
end

-- this will check the player command permission
function checkPlayerCommandPermission()
	if(getElementData(source, "abletojail")=="in") then
		cancelEvent()
	end
end

-- this will cancel the prison state unexpectedly
function cancelPrisonState()
	if(getElementData(source, "abletojail")=="in") then
		triggerClientEvent(source, "disabledPrisonState", source)
	end
end

-- this will check the police to handcuff the wanted player
function handcuffWantedPlayer(theClient, theCommand, thePlayer)
	if(checkPolicePermission(theClient)==true) then
		if(thePlayer) then
			if(getElementByData(thePlayer)) then
				thePlayer = getElementByData(thePlayer)
				if(thePlayer~=theClient) then
					triggerClientEvent(theClient, "checkPlayerRangePosition", theClient, "handcuff", thePlayer)
				else
					theClient:outputChat("* Você não precisa se algemar.", 255, 0, 0)
				end
			else
				theClient:outputChat("* Não encontramos nenhum jogador com esta ID.", 255, 0, 0)
			end
		else
			theClient:outputChat("* Por favor, informe o ID do jogador que deseja algemar.", 255, 0, 0)
		end
	end
end

-- this will to handcuff the wanted player
function handcuffConcededPlayerWanted(thePlayer)
	setPedAnimation(client, "police", "plc_drgbst_01", 3100, true, false, false, false)
	setTimer(function()
		setElementFrozen(thePlayer, true)
		setPedAnimation(thePlayer, "graveyard", "mrnM_loop", -1, true, false, false, false)
	end,1000,1)
end

-- this will check the police to unbalance the wanted player
function unbalanceWantedPlayer(theClient, theCommand, thePlayer)
	if(checkPolicePermission(theClient)==true) then
		if(thePlayer) then
			if(getElementByData(thePlayer)) then
				thePlayer = getElementByData(thePlayer)
				if(thePlayer~=theClient) then
					triggerClientEvent(theClient, "checkPlayerRangePosition", theClient, "unbalance", thePlayer)
				else
					theClient:outputChat("* Você não pode se desalgemar.", 255, 0, 0)
				end
			else
				theClient:outputChat("* Não encontramos nenhum jogador com esta ID.", 255, 0, 0)
			end
		else
			theClient:outputChat("* Por favor, informe o ID do jogador que deseja desalgemar.", 255, 0, 0)
		end
	end
end

-- this will to unbalance the wanted player
function unbalanceConcededPlayerWanted(thePlayer)
	setPedAnimation(client, "police", "plc_drgbst_01", 3100, true, false, false, false)
	setTimer(function()
		setElementFrozen(thePlayer, false)
		setPedAnimation(thePlayer)
	end,1000,1)
end

-- this will check the police permission status
function checkPolicePermission(theClient)
	permissionStatus = false
	for _, group in pairs(theGroups) do
		if(aclGetGroup(group)) then
			if(isObjectInACLGroup("user."..getAccountName(getPlayerAccount(theClient)), aclGetGroup(group))) then
				permissionStatus = true
			end
		end
	end
	return permissionStatus
end

-- this will get the player by data
function getElementByData(ID)
	theElement = false
	for _, player in ipairs(getElementsByType("player")) do
		if(getElementData(player, "ID")==tonumber(ID)) then
			theElement = player
		end
	end
	return theElement
end

-- commands & events
addCommandHandler("revistar", checkWanted)
addCommandHandler("prender", holdToJailWantedPlayer)
addCommandHandler("algemar", handcuffWantedPlayer)
addCommandHandler("desalgemar", unbalanceWantedPlayer)
addCommandHandler("limparficha", cleanPlayerWanted)
addEvent("onPlayerWantedCheckSuccessfully", true)
addEventHandler("onPlayerWantedCheckSuccessfully", resourceRoot, checkConcededPlayerWanted)
addEvent("onPlayerWantedJailSuccessfully", true)
addEventHandler("onPlayerWantedJailSuccessfully", resourceRoot, jailConcededPlayerWanted)
addEvent("onPlayerLeftTheJail", true)
addEventHandler("onPlayerLeftTheJail", resourceRoot, leftPlayerFromTheJail)
addEvent("onPlayerWantedHandcuffSuccessfully", true)
addEventHandler("onPlayerWantedHandcuffSuccessfully", resourceRoot, handcuffConcededPlayerWanted)
addEvent("onPlayerWantedUnbalanceSuccessfully", true)
addEventHandler("onPlayerWantedUnbalanceSuccessfully", resourceRoot, unbalanceConcededPlayerWanted)
addEventHandler("onPlayerCommand", root, checkPlayerCommandPermission)
addEventHandler("onPlayerWasted", getRootElement(), cancelPrisonState)
addEventHandler("onPlayerQuit", getRootElement(), cancelPrisonState)
addEventHandler("onMarkerHit", thePoliceStationMarker, showCleanCommandMessage)