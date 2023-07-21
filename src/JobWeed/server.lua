--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "JobWeed"
local resourceDescription = "Sistema do Trabalho de Traficante"
local syStarted = false
local getX,getY,getZ = -1092.9384765625,-1612.6708984375,76.3671875
local theMachines =
{
	["weedJobMachine_1"] = {-1110.095703125,-1648.5166015625,76.3671875,0,0,268},
	["weedJobMachine_2"] = {-1110.095703125,-1658.5166015625,76.3671875,0,0,268},
	["weedJobMachine_3"] = {-1107.9130859375,-1621.2177734375,76.3671875,0,0,268},
}

-- this will start the system
function startSy()
	jobIcon = createObject(1239,getX,getY,getZ,0,0,0,true)
	jobMarker = createMarker(getX,getY,getZ-1,"cylinder",1.5,255,153,0,100,true)
	setObjectScale(jobIcon, 2)
	for k,pos in pairs(theMachines) do
		theVehicle = createVehicle(532,pos[1],pos[2],pos[3],pos[4],pos[5],pos[6])
		setElementID(theVehicle,k)
	end
	syStarted = true
end

-- this will verify if the player enter in the job marker
function getStarted(hit)
	startState = false
	if(jobMarker~=nil) then
		if(isElementWithinMarker(hit, jobMarker)) then
			startState = true
		end
		if(startState==true) then
			triggerClientEvent(hit,"onJobWeedRequest",hit)
		end
	end
end

-- this will verify if the player left in the job marker
function getStoped(hit)
	if(source==jobMarker) then
		triggerClientEvent(hit,"onJobWeedLeftRequest",hit)
	end
end

-- this will check if the machines are destroyed
function checkDestroy()
	theVehicleID = getElementID(source)
	for k,pos in pairs(theMachines) do
		if(k==theVehicleID) then
			destroyElement(source)
			setTimer(function()
				theVehicle = createVehicle(532,pos[1],pos[2],pos[3],pos[4],pos[5],pos[6])
				setElementID(theVehicle,k)
			end,1000,1)
		end
	end
end

-- this will check if the player enter in a machine
function checkEnter(p)
	theVehicleID = getElementID(source)
	setElementData(p, "occupiedjobmachine", theVehicleID)
	for k,pos in pairs(theMachines) do
		if(k==theVehicleID) then
			triggerClientEvent(p,"onPlayerEnterWeedMachine",p)
		end
	end
end

-- this will check if the player exit from a machine
function checkExit(p)
	theVehicleID = getElementID(source)
	setElementData(p, "occupiedjobmachine", false)
	for k,pos in pairs(theMachines) do
		if(k==theVehicleID) then
			triggerClientEvent(p,"onPlayerExitWeedMachine",p)
			destroyElement(source)
			setTimer(function()
				theVehicle = createVehicle(532,pos[1],pos[2],pos[3],pos[4],pos[5],pos[6])
				setElementID(theVehicle,k)
			end,1000,1)
		end
	end
end

-- this will check if the player left from the game
function checkLeft()
	theVehicleID = getElementData(source, "occupiedjobmachine")
	for k,pos in pairs(theMachines) do
		if(k==theVehicleID) then
			destroyElement(theVehicle)
			setTimer(function()
				newVehicle = createVehicle(532,pos[1],pos[2],pos[3],pos[4],pos[5],pos[6])
				setElementID(newVehicle,k)
			end,1000,1)
		end
	end
end

-- this will kick the player from the weed machine
function kickFromMachine()
	removePedFromVehicle(client)
	client:outputChat("* Você não pode entrar nesta máquina sem estar trabalhando.",255,0,0)
	setElementData(client, "occupiedjobmachine", false)
end

-- this will save the weed colected
function saveColectedWeed(weedColected)
	theAccount = getPlayerAccount(client)
	theName = getAccountName(theAccount)
	if not(isGuestAccount(theAccount)) then
		accountWeed = getAccountData(theAccount, "colectedweed")
		if(accountWeed~=false) then
			colectedWeed = accountWeed+weedColected
		else
			colectedWeed = weedColected
		end
		setAccountData(theAccount, "colectedweed", colectedWeed)
		client:outputChat("* Você colheu "..weedColected.." erva(s)!",0,255,0)
		client:outputChat("Obs: quando quiser abandonar o trabalho de maconheiro, digite /abandonar. Se quiser colher mais drogas, é só voltar na máquina.")
	else
		client:outputChat("* Não foi possível salvar as ervas. Desculpe, mas é necessário estar logado para salvar.",255,0,0)
	end
end

-- this will make a request to sell weed
function sellWeedRequest(player, quantity, price)
	thePlayer = getPlayerFromName(player)
	playerAccount = getPlayerAccount(thePlayer)
	if not(isGuestAccount(playerAccount)) then
		triggerClientEvent(thePlayer, "onPlayerSellToMeRequest", thePlayer, client, quantity, price)
	else
		client:outputChat("* Não é possível vender ervas para este player pois ele não está logado.",255,0,0)
	end
end

-- this will buy a weed
function buyWeedRequest(player, quantity, price)
	playerAccount = getPlayerAccount(player)
	playerWeed = getAccountData(playerAccount, "colectedweed")
	if(playerWeed==false) then
		playerWeed = 0
	end
	playerNewWeed = playerWeed-quantity
	setAccountData(playerAccount, "colectedweed", playerNewWeed)
	givePlayerMoney(player, price)
	player:outputChat("* O "..getPlayerName(client).." comprou o seu tratamento por R$"..price..",00!",0,255,0,true)
	clientAccount = getPlayerAccount(client)
	clientWeed = getAccountData(clientAccount, "myweed")
	if(clientWeed==false) then
		clientWeed = 0
	end
	clientWeed = clientWeed+quantity
	setAccountData(clientAccount, "myweed", clientWeed)
	takePlayerMoney(client, price)
	client:outputChat("* Você comprou o tratamento de "..getPlayerName(player).." por R$"..price..",00!",0,255,0,true)
	client:outputChat("Aperte 'U' para abrir o Painel de Ervas.")
end

-- this will send the colected weed to the client
function colWeedRequest()
	clientAccount = getPlayerAccount(client)
	clientWeed = getAccountData(clientAccount, "colectedweed")
	if(clientWeed==false) then
		clientWeed = 0
	end
	triggerClientEvent(client, "onColWeedQuantityUpdate", client, clientWeed)
end

-- this will send the main weed to the client
function mainPanelRequest()
	clientAccount = getPlayerAccount(client)
	clientWeed = getAccountData(clientAccount, "myweed")
	if(clientWeed==false) then
		clientWeed = 0
	end
	triggerClientEvent(client, "onMainWeedUpdate", client, clientWeed)
end

-- this will send the permission to use the weed
function useWeedRequest()
	clientAccount = getPlayerAccount(client)
	clientWeed = getAccountData(clientAccount, "myweed")
	if(clientWeed==false) then
		clientWeed = 0
	end
	if(clientWeed>0) then
		clientWeed = clientWeed-1
		setAccountData(clientAccount, "myweed", clientWeed)
		triggerClientEvent(client, "onPermissionToUseWeed", client)
		setPedAnimation(client, "smoking", "m_smk_in",7,false)
		for _, player in ipairs(getElementsByType("player")) do
			triggerClientEvent(player, "onPermissionToUseWeedSound", player, client)
		end
	else
		client:outputChat("* Desculpe, mas você não tem drogas para usar.",255,0,0)
	end
end

-- events
addEventHandler("onMarkerHit", getRootElement(), getStarted)
addEventHandler("onMarkerLeave", getRootElement(), getStoped)
addEventHandler("onVehicleExplode", getRootElement(), checkDestroy)
addEventHandler("onVehicleEnter", getRootElement(), checkEnter)
addEventHandler("onVehicleExit", getRootElement(), checkExit)
addEventHandler("onPlayerQuit", getRootElement(), checkLeft)
addEvent("onPlayerKickWeedMachine", true)
addEventHandler("onPlayerKickWeedMachine", resourceRoot, kickFromMachine)
addEvent("onWeedColectedSaveRequest", true)
addEventHandler("onWeedColectedSaveRequest", resourceRoot, saveColectedWeed)
addEvent("onPlayerSellWeedRequest", true)
addEventHandler("onPlayerSellWeedRequest", resourceRoot, sellWeedRequest)
addEvent("onPlayerBuyWeedRequest", true)
addEventHandler("onPlayerBuyWeedRequest", resourceRoot, buyWeedRequest)
addEvent("onColWeedQuantityRequest", true)
addEventHandler("onColWeedQuantityRequest", resourceRoot, colWeedRequest)
addEvent("onWeedMainPanelRequest", true)
addEventHandler("onWeedMainPanelRequest", resourceRoot, mainPanelRequest)
addEvent("onUseWeedRequest", true)
addEventHandler("onUseWeedRequest", resourceRoot, useWeedRequest)

startSy() -- start system