--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local inJob = false
local jobState = false
local jobDescr = "#FF0000Trabalho de Traficante #FFFFFF→  Neste trabalho você terá que colhetar ervas. Sua recompensa dependerá de quantas ervas você irá vender para as pessoas."
local px,py = guiGetScreenSize()
local missionObjectiveText = ""
local missionObjectiveStatus = 0
local weedColected = 0
local weedMarkers =
{
	[1] = {-1069.1103515625,-1622.142578125,76.37393951416},
	[2] = {-1035.0625,-1626.2900390625,76.3671875},
	[3] = {-1000.447265625,-1629.671875,76.3671875},
	[4] = {-996.6884765625,-1664.18359375,76.3671875},
	[5] = {-1024.8837890625,-1647.9560546875,76.3671875},
	[6] = {-1052.2373046875,-1634.55078125,76.3671875},
}
local actualMarker = 0
local markerGoinIn = true
local panelOpen = false
local weedSaleFrom, weedSaleQuantity, weedSalePrice = nil,nil,nil
local buyState = false
local colSavedWeed = 0
local mainPanelOpen = false
local mainWeed = 0

-- this will start the job
function startJob()
	if(inJob==false) then
		jobState = true
		outputChatBox("⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯   Trabalho BnF™  ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯",255,153,0)
		outputChatBox(jobDescr,255,255,255,true)
		outputChatBox(" ")
		outputChatBox("* Digite #FF0000/aceitar #FFFFFFpara aceitar o trabalho.",255,255,255,true)
		outputChatBox("⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯",255,153,0)
	else
		outputChatBox("* Você já está trabalhando.",255,0,0)
	end
end

-- this will stop the job
function stopJob()
	jobState = false
end

-- this will start the accepted job
function getJobStarted()
	if(jobState==true) then
		inJob = true
		missionObjectiveStatus = 0
		updateObjective()
		addEventHandler("onClientRender", root, missionObjective)
	end
end

-- this will stop the accepted job
function getJobStopped()
	outputChatBox("* Você deixou o trabalho de Traficante.",255,0,0)
	inJob = false
	removeEventHandler("onClientRender", root, missionObjective)
end

-- this will make the mission objectives
function updateObjective()
	if(missionObjectiveStatus==0) then
		missionObjectiveText = "Entre em uma máquina de colheita para colher as ervas."
	end
	if(missionObjectiveStatus==1) then
		missionObjectiveText = "Colha quantas ervas quiser. Saia da máquina para guardar."
	end
	if(missionObjectiveStatus==2) then
		missionObjectiveText = "Aperte 'N' para vender suas ervas!"
	end
end

-- this will show the mission objective
function missionObjective()
	dxDrawText("Objetivo do trabalho",px-219,161,px,py,tocolor(0,0,0,255),1,"default-bold")
	dxDrawText(missionObjectiveText,px-219,176,px,py,tocolor(0,0,0,255),1,"default-bold","left","top",false,true)
	dxDrawText("Objetivo do trabalho",px-220,160,px,py,tocolor(255,153,0,255),1,"default-bold")
	dxDrawText(missionObjectiveText,px-220,175,px,py,tocolor(255,255,255,255),1,"default-bold","left","top",false,true)
end

-- enter in weed machine
function enterWeedMachine()
	if(inJob==true) then
		missionObjectiveStatus = 1
		updateObjective()
		actualMarker = 1
		weedColected = 0
		doWeedMarkers()
	else
		triggerServerEvent("onPlayerKickWeedMachine", resourceRoot)
	end
end

-- exit from weed machine
function exitWeedMachine()
	if(inJob==true) then
		missionObjectiveStatus = 2
		updateObjective()
		if(theMarker) then
			destroyElement(theMarker)
		end
		triggerServerEvent("onWeedColectedSaveRequest", resourceRoot, weedColected)
	end
end

-- weed markers
function doWeedMarkers()
	for k,pos in pairs(weedMarkers) do
		if(k==actualMarker) then
			if(theMarker) then
				destroyElement(theMarker)
			end
			theMarker = createMarker(pos[1],pos[2],pos[3]-1,"checkpoint",4,0,200,0,255,true)
		end
	end
end

-- this will update the marker when hit a marker
function doMarkerHit(hit)
	if(hit==getLocalPlayer()) then
		if(source==theMarker) then
			selMarker = math.random(#weedMarkers)
			if(selMarker~=actualMarker) then
				actualMarker = selMarker
			else
				if(selMarker<4) then
					actualMarker = 6
				else
					actualMarker = 1
				end
			end
			doWeedMarkers()
			weedColected = weedColected+2
		end
	end
end

-- additional function
function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
   end
   return false
end

-- shop panel
theWindow = guiCreateWindow(0.5-0.15,0.5-0.25,0.3,0.5,"Vender Ervas",true)
quantityInfo = guiCreateLabel(0.04,0.06,0.94,0.2, "Ervas colhetadas: ?", true, theWindow)
quantityLabel = guiCreateLabel(0.04,0.142,0.94,0.2, "Quantidade:", true, theWindow)
quantityValue = guiCreateEdit(0.27,0.12,1,0.10, "", true, theWindow)
priceLabel = guiCreateLabel(0.04,0.262,0.94,0.2, "Preço:", true, theWindow)
priceValue = guiCreateEdit(0.17,0.24,1,0.10, "", true, theWindow)
theList = guiCreateGridList(0,0.36,1,0.8,true,theWindow)
guiLabelSetColor(quantityInfo,0,255,0)
guiLabelSetColor(quantityLabel,0,255,0)
guiLabelSetColor(priceLabel,0,255,0)
guiWindowSetSizable(theWindow, false)
guiSetVisible(theWindow, false)
showCursor(false)
panelOpen = false

-- this will show the shop panel to the player
function showShopPanel()
	if(inJob==true) then
		if(missionObjectiveStatus==2) then
			if(panelOpen==false) then
				if(columnPlayers~=nil) then
					guiGridListRemoveColumn(theList, columnPlayers)
				end
				columnPlayers = guiGridListAddColumn(theList, "Jogadores próximos a mim", 0.94)
				if(columnPlayers) then
					x,y,z = getElementPosition(getLocalPlayer())
					for _,p in ipairs(getElementsByType("player")) do
						if(isElementInRange(p,x,y,z, 10) and getPlayerName(p)~=getPlayerName(getLocalPlayer())) then
							theRow = guiGridListAddRow(theList)
							guiGridListSetItemText(theList, theRow, columnPlayers, getPlayerName(p), false, false)
						end
					end
				end
				triggerServerEvent("onColWeedQuantityRequest", resourceRoot)
				guiSetVisible(theWindow, true)
				showCursor(true)
				panelOpen = true
			else
				guiSetVisible(theWindow, false)
				showCursor(false)
				panelOpen = false
			end
		end
	end
end

-- this will to sell the weed
function sellWeed()
	if(guiGridListGetSelectedItem(theList)~=-1) then
		selectedJob, selectedCol = guiGridListGetSelectedItem(theList)
		thePlayerName = guiGridListGetItemText(theList,selectedJob,selectedCol)
		theQuantity = tonumber(guiGetText(quantityValue))
		if(theQuantity==nil) then
			theQuantity = 0
		end
		thePrice = tonumber(guiGetText(priceValue))
		if(thePrice==nil) then
			thePrice = 0
		end
		if(theQuantity<colSavedWeed+1) then
			if(theQuantity>0) then
				if(thePrice>0) then
					guiSetText(quantityValue, "")
					guiSetText(priceValue, "")
					triggerServerEvent("onPlayerSellWeedRequest", resourceRoot, thePlayerName, theQuantity, thePrice)
					guiSetVisible(theWindow, false)
					showCursor(false)
					panelOpen = false
				else
					outputChatBox("* Por favor, informe um valor acima de 0 para o preço da erva que deseja vender.",255,0,0)
				end
			else
				outputChatBox("* Por favor, informe um valor acima de 0 para a quantidade de ervas que deseja vender.",255,0,0)
			end
		else
			outputChatBox("* Você não pode vender essa quantidade de ervas. Por favor, tente vender a quantidade de ervas que você têm em seu estoque.",255,0,0)
		end
	else
		outputChatBox("* Por favor, selecione um jogador para vender a erva.",255,0,0)
	end
end

-- this will make a sell request to me
function sellToMeRequest(fromplayer, quantity, price)
	if(buyState==false) then
		outputChatBox("⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯   Tráfico BnF™  ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯",255,153,0)
		outputChatBox(getPlayerName(fromplayer).." #FFFFFFdeseja vender #FF0000"..quantity.." #FFFFFFerva(s) de maconha por #FF0000R$"..price..",00 #FFFFFFpara você.",255,255,255,true)
		outputChatBox(" ")
		outputChatBox("* Digite #FF0000/pegar #FFFFFFpara aceitar o tratamento.",255,255,255,true)
		outputChatBox("⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯",255,153,0)
		weedSaleFrom, weedSaleQuantity, weedSalePrice = fromplayer,quantity,price
		buyState = true
		setTimer(function()
			outputChatBox("Você tem 15 segundos para aceitar o tratamento.")
			setTimer(function()
				weedSaleFrom, weedSaleQuantity, weedSalePrice = nil,nil,nil
				if(buyState==true) then
					buyState = false
					outputChatBox("* Você rejeitou o tratamento.",255,0,0)
				end
			end,15000,1)
		end,1500,1)
	end
end

-- this will buy the weed
function buyWeed()
	myMoney = getPlayerMoney(getLocalPlayer())+1
	if(weedSaleFrom~=nil and weedSalePrice~=nil and weedSaleQuantity~=nil) then
		saleFrom = weedSaleFrom
		saleQuantity = weedSaleQuantity
		salePrice = weedSalePrice
		if(myMoney>salePrice) then
			triggerServerEvent("onPlayerBuyWeedRequest", resourceRoot, saleFrom, saleQuantity, salePrice)
			weedSaleFrom, weedSaleQuantity, weedSalePrice = nil,nil,nil
			buyState = false
		else
			outputChatBox("* Você não tem grana suficiente para pegar essa droga.",255,0,0)
		end
	else
		outputChatBox("* Desculpe, mas não foi possível comprar o tratamento.",255,0,0)
	end
end

-- this will update the weed quantity
function updateWeedQuantity(quantity)
	colSavedWeed = quantity
	guiSetText(quantityInfo, "Ervas colhetadas: "..quantity)
end

-- main panel
theMainWindow = guiCreateWindow(0.5-0.15,0.5-0.1,0.3,0.15,"Minhas Ervas",true)
mainQuantityInfo = guiCreateLabel(0.04,0.20,0.94,0.2, "Minhas ervas: ?", true, theMainWindow)
useButton = guiCreateButton(0.03, 0.40, 1, 0.3, "Usar droga", true, theMainWindow)
mainInfo = guiCreateLabel(0.25,0.765,0.54,0.2, "Feito com <3 por Namykazesz.", true, theMainWindow)
guiLabelSetColor(mainQuantityInfo,0,255,0)
guiWindowSetSizable(theMainWindow, false)
guiSetVisible(theMainWindow, false)

-- this will show the main panel
function showMainPanel()
	if(mainPanelOpen==false) then
		guiSetVisible(theMainWindow, true)
		showCursor(true)
		mainPanelOpen = true
	else
		guiSetVisible(theMainWindow, false)
		showCursor(false)
		mainPanelOpen = false
	end
end

-- this will check the main panel show
function checkShowMainPanel()
	triggerServerEvent("onWeedMainPanelRequest", resourceRoot)
end

-- this will update main weed quantity
function updateMainWeedQuantity(quantity)
	mainWeed = quantity
	guiSetText(mainQuantityInfo, "Minhas ervas: "..quantity)
	if(mainWeed>0) then
		showMainPanel()
	end
end

-- this will use the weed
function useWeed()
	if(source==useButton) then
		showMainPanel()
		triggerServerEvent("onUseWeedRequest", resourceRoot)
	end
end

-- this will activate the weed mode
function weedActive()
	showEffectt()
	outputChatBox("O homem quando bebe álcool, afia uma faca e mata. Mas quando fuma erva ele afia uma faca e diz:",0,255,0)
	outputChatBox("Deixa, a vida mostrará a ele.",0,255,0)
	outputChatBox("                                                     ~ Bob Marley",0,255,0)
	setTimer(function()
		hideEffectt()
	end,30000,1)
end

-- show effect
function showEffectt()
	theTimer = setTimer(function()
		setSkyGradient(math.random(50,255),math.random(50,255),math.random(50,255),math.random(50,255),math.random(50,255),math.random(50,255))
		setSunColor(math.random(50,255),math.random(50,255),math.random(50,255),math.random(50,255),math.random(50,255),math.random(50,255))
	end,1000,0)
	setWindVelocity(math.random(50,255), math.random(50,255), math.random(50,255))
	setRainLevel(1)
	setGameSpeed(0.5)
end

-- weed sound
function playWeedSound(player)
	x,y,z = getElementPosition(player)
	weedShound = playSound3D("weed.mp3",x,y,z)
end

-- hide effect
function hideEffectt()
	killTimer(theTimer)
	killTimer(soundTimer)
	resetSkyGradient()
	resetRainLevel()
	resetWindVelocity()
	resetSunColor()
	setGameSpeed(1)
end

-- events & commands
addEvent("onJobWeedRequest", true)
addEventHandler("onJobWeedRequest", localPlayer, startJob)
addEvent("onJobWeedLeftRequest", true)
addEventHandler("onJobWeedLeftRequest", localPlayer, stopJob)
addCommandHandler("aceitar", getJobStarted)
addEvent("onPlayerEnterWeedMachine", true)
addEventHandler("onPlayerEnterWeedMachine", localPlayer, enterWeedMachine)
addEvent("onPlayerExitWeedMachine", true)
addEventHandler("onPlayerExitWeedMachine", localPlayer, exitWeedMachine)
addEventHandler("onClientMarkerHit", getRootElement(), doMarkerHit)
bindKey("N","down",showShopPanel)
addEventHandler("onClientGUIDoubleClick", theList, sellWeed)
addEvent("onPlayerSellToMeRequest", true)
addEventHandler("onPlayerSellToMeRequest", localPlayer, sellToMeRequest)
addCommandHandler("pegar", buyWeed)
addEvent("onColWeedQuantityUpdate", true)
addEventHandler("onColWeedQuantityUpdate", localPlayer, updateWeedQuantity)
bindKey("U","down",checkShowMainPanel)
addEvent("onMainWeedUpdate", true)
addEventHandler("onMainWeedUpdate", localPlayer, updateMainWeedQuantity)
addEventHandler("onClientGUIClick", useButton, useWeed)
addEvent("onPermissionToUseWeed", true)
addEventHandler("onPermissionToUseWeed", localPlayer, weedActive)
addEvent("onPermissionToUseWeedSound", true)
addEventHandler("onPermissionToUseWeedSound", localPlayer, playWeedSound)
addCommandHandler("abandonar", getJobStopped)