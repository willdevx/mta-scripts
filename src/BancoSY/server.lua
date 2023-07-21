--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "Banco"
local resourceDescription = "Sistema de Banco"
markersSpawned = false
theMarkers =
{
	[1] = {
		{2112.962890625,-1116.2724609375,25.276937484741,-0.5,-197,-0.15},
	},
	[2] = {
		{1443.6884765625,-1583.546875,13.546875,0.5,0,0},
	},
	[3] = {
		{2471.546875,-1724.1177734375,13.546875,0.5,0,0},
	},
	[4] = {
		{1949.2900390625,2121.535546875,10.8203125,0.5,0,0},
	},
	[5] = {
		{2539.3525390625,1641.2021484375,10.8203125,0,90,-0.5},
	},
	[6] = {
		{1499.5361328125,1013.501953125,10.8203125,0,90,-0.5},
	},
	[7] = {
		{290.9990234375,-92.4423828125,1.578125,0,-92,0.5},
	},
	[8] = {
		{-2243.5029296875,-49.9970703125,35.3203125,0,-92,0.5},
	},
	[9] = {
		{-1922.9599609375,742.60271875,45.4453125,0.5,0,0},
	},
	[10] = {
		{-2759.2625390625,771.943359375,54.3828125,0,92,-0.5},
	},
}

-- this will show the resource info to the player
outputChatBox("#F2F2F2(c) "..resourceCreationDate.." - #FFFFFF"..resourceOfficialName.." #F2F2F2(licenciado para BnF™) pelo criador #FF0000Namykaze#F2F2F2.", getRootElement(), 255, 255, 255, true)
outputChatBox(resourceOfficialName..": "..resourceDescription.." iniciado.")

-- this will spawn the bank markers to me
function spawnMarkers()
	for id in pairs(theMarkers) do
		for _,location in ipairs(theMarkers[id]) do
			bankMachine = createObject(2942, location[1]+location[6], location[2]+location[4], location[3]-0.8, 0, 0, location[5], false)
			setObjectScale(bankMachine, 2)
			theMarker = createMarker(location[1],location[2],location[3]-1,"cylinder",1.5,0,0,255,125)
			theBlip = createBlipAttachedTo(bankMachine, 52)
			setElementID(theMarker,"BnFbank")
		end
	end
end

-- this will turn on the marker spawn state
if(markersSpawned==false) then
	spawnMarkers()
	markersSpawned = true
end

-- this will verify if the player are hitting a bank marker
function detectBank(theClient)
	if(getElementType(theClient)=="player") then
		markerID = getElementID(source)
		if(markerID=="BnFbank") then
			if(isGuestAccount(getPlayerAccount(theClient))) then
				theClient:outputChat("Desculpe, mas é preciso estar logado para poder ter acesso a uma conta no Banco BnF™",255,0,0,true)
			else
				myMoney = getPlayerMoney(theClient)
				theMoney = getAccountData(getPlayerAccount(theClient), "playermoney")
				if(theMoney~=false) then
					triggerClientEvent(theClient, "onPlayerBankAccountOpen", theClient, theMoney, myMoney)
				else
					setAccountData(getPlayerAccount(theClient), "playermoney", 0)
					triggerClientEvent(theClient, "onPlayerBankAccountOpen", theClient, theMoney, myMoney)
				end
			end
		end
	end
end

-- this will give the bank money to the player
function sacMoney(theMoney)
	if(tonumber(theMoney)~=nil) then
		myMoney = getAccountData(getPlayerAccount(client), "playermoney")
		if(tonumber(theMoney)>0) then
			if(tonumber(theMoney)<myMoney+1) then
				givePlayerMoney(client, tonumber(theMoney))
				actualMoney = myMoney-tonumber(theMoney)
				setAccountData(getPlayerAccount(client), "playermoney", actualMoney)
				triggerClientEvent(client, "onPlayerBankSac", client, tonumber(theMoney), actualMoney)
			else
				triggerClientEvent(client, "onPlayerBankSacInsMoneyError", client)
			end
		else
			triggerClientEvent(client, "onPlayerBankSacImpossible", client)
		end
	end
end

-- this will increase the bank money to the player
function depMoney(theMoney)
	if(tonumber(theMoney)~=nil) then
		myBankMoney = getAccountData(getPlayerAccount(client), "playermoney")
		myMoney = getPlayerMoney(client)
		if(tonumber(theMoney)>0) then
			if(tonumber(theMoney)<myMoney+1) then
				takePlayerMoney(client, tonumber(theMoney))
				actualMoney = myBankMoney+tonumber(theMoney)
				setAccountData(getPlayerAccount(client), "playermoney", actualMoney)
				triggerClientEvent(client, "onPlayerBankDep", client, tonumber(theMoney), actualMoney)
			else
				triggerClientEvent(client, "onPlayerBankDepInsMoneyError", client)
			end
		else
			triggerClientEvent(client, "onPlayerBankDepImpossible", client)
		end
	end
end

-- this will teleport the player to the random bank location
function teleBank(theClient)
	selPos = math.random(1,10)
	if(selPos==1) then
		dis = 2
	end
	if(selPos==2) then
		dis = -2.5
	end
	if(selPos==3) then
		dis = -2.5
	end
	if(selPos==4) then
		dis = -2.5
	end
	if(selPos==5) then
		dis = 2.5
	end
	if(selPos==6) then
		dis = 2.5
	end
	if(selPos==7) then
		dis = -2.5
	end
	if(selPos==8) then
		dis = -2.5
	end
	if(selPos==9) then
		dis = -2.5
	end
	if(selPos==10) then
		dis = 2.5
	end
	for id in pairs(theMarkers) do
		if(id==selPos) then
			for _,location in ipairs(theMarkers[id]) do
				setElementPosition(theClient, location[1]+dis, location[2], location[3])
			end
		end
	end
	setTimer(function()
		outputChatBox("#FFFFFF* O jogador #00ff90"..getPlayerName(theClient).." #FFFFFFfoi para o #FF9900Banco #FFFFFFutilizando [#FF9900/banco#FFFFFF]",root,0,255,0,true)
	end,2000,1)
end

-- events & command
addEventHandler("onMarkerHit", getRootElement(), detectBank)
addEvent("onPlayerSacMoney", true)
addEventHandler("onPlayerSacMoney", resourceRoot, sacMoney)
addEvent("onPlayerDepMoney", true)
addEventHandler("onPlayerDepMoney", resourceRoot, depMoney)
addCommandHandler("banco", teleBank)