--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "PazSY"
local resourceDescription = "Sistema de Paz"

-- this will toggle the player mode to invulnerable or not
function togglePlayer(theClient)
	playerMode = getElementData(theClient, "invulnerable")
	playerStatus = getElementData(theClient, "invulnerable-use")
	if(playerStatus~="wait") then
		theClient:outputChat("Aguarde um momento...")
		setElementData(theClient, "invulnerable-use", "wait")
		setTimer(function()
			if(playerMode=="yes") then
				setElementData(theClient, "invulnerable", "not")
				outputChatBox("#000000[#FFFFFF /paz #000000] #ffffffO jogador "..getPlayerName(theClient).." #ffffffsaiu do modo passivo #000000「 #ff0000Desprotegido #000000」#ffffff !", getRootElement(), 255, 255, 255, true)
			else
				setElementData(theClient, "invulnerable", "yes")
				takeAllWeapons(theClient)
				outputChatBox("#000000[#FFFFFF /paz #000000] #ffffffO jogador "..getPlayerName(theClient).." #ffffffestá no modo passivo #000000「 #00ff00Protegido #000000」#ffffff !", getRootElement(), 255, 255, 255, true)
			end
			triggerClientEvent(theClient, "onModeToggled", theClient, playerMode)
		end,5000,1)
	else
		theClient:outputChat("Você deve esperar 10 segundos para alterar de Modo Paz.",255,0,0)
	end
end

-- this will take all weapons from the player if the mode is actived
function weaponMode()
	myMode = getElementData(source, "invulnerable")
	if(myMode=="yes") then
		takeAllWeapons(source)
	end
end

-- this will kick the player if the player fire with the mode actived
function modeFire()
	kickPlayer(client, "Não atire com o Modo Passivo ativado.")
end

-- this will make the mode be ready to the player
function modeReady()
	setElementData(client, "invulnerable-use", "")
end

-- command & events
addCommandHandler("paz", togglePlayer)
addEventHandler("onPlayerWeaponSwitch", getRootElement(), weaponMode)
addEvent("onFireModeFire", true)
addEventHandler("onFireModeFire", resourceRoot, modeFire)
addEvent("onModeReady", true)
addEventHandler("onModeReady", resourceRoot, modeReady)