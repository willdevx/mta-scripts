--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
screenW, screenH = guiGetScreenSize()
panelVisible = false
theManager = ""
selectedPlayer = ""
theInvitedGroup = ""

-- the group panel
thePanel = guiCreateWindow(0, 0, screenW/2, screenW/2, "Grupos BnF™ - Gerenciamento de gangues e corporações", false)
windowW, windowH = guiGetSize(thePanel, false)
x, y = (screenW - windowW) /2,(screenH - windowH) /2
guiSetPosition(thePanel, x, y, false)
guiWindowSetSizable(thePanel, false)
guiSetVisible(thePanel, false)
theManagerInfo = guiCreateLabel(0.02,0.04,0.94,0.2, "Você gerencia: ", true, thePanel)
theAdInfo = guiCreateLabel(0.02,0.065,0.94,0.2, "Selecione um jogador que deseje enviar um convite para entrar no seu grupo.", true, thePanel)
theBoInfo = guiCreateLabel(0.02,0.92,0.94,0.2, "2017 (c) Grupos BnF™ feito com <3 por Namykazesz.", true, thePanel)
guiLabelSetColor(theManagerInfo, 0, 100, 255)
playerList = guiCreateGridList(0, 0.10, 1, 0.8, true, thePanel)
inviteButton = guiCreateButton(0.8, 0.91, 0.2, 0.06, "Enviar convite", true, thePanel)
guiSetVisible(inviteButton, false)

-- toggle the panel visibility
function togglePanel()
	if(theManager~="") then
		if(panelVisible==false) then
			playSound("sound/open_panel.mp3")
			guiSetVisible(thePanel, true)
			panelVisible = true
			showCursor(true)
			guiGridListRemoveColumn(playerList, columnA)
			guiGridListRemoveColumn(playerList, columnB)
			guiGridListRemoveColumn(playerList, columnC)
			columnA = guiGridListAddColumn(playerList, "#", 0.05)
			columnB = guiGridListAddColumn(playerList, "Nicknames", 0.20)
			columnC = guiGridListAddColumn(playerList, "Nicknames com CSS", 0.70)
			if(selectedPlayer=="") then
				guiSetText(theBoInfo, "2017 (c) Grupos BnF™ feito com <3 por Namykazesz.")
			end
			iA = 0
			for _, player in ipairs(getElementsByType("player")) do
				iA = iA+1
				row = guiGridListAddRow(playerList)
				guiGridListSetItemText(playerList, row, columnA, iA, false, false)
				guiGridListSetItemText(playerList, row, columnB, getPlayerName(player):gsub('#%x%x%x%x%x%x', ''), false, false)
				guiGridListSetItemText(playerList, row, columnC, getPlayerName(player), false, false)
			end
		else
			playSound("sound/close_panel.mp3")
			guiSetVisible(thePanel, false)
			panelVisible = false
			showCursor(false)
			guiGridListRemoveColumn(playerList, columnA)
			guiGridListRemoveColumn(playerList, columnB)
			guiGridListRemoveColumn(playerList, columnC)
		end
	else
		triggerServerEvent("onGroupManagerPermissionRequest", resourceRoot)
	end
end

-- this will select the player to invite
function invitePlayer()
	playerName = guiGridListGetItemText(playerList, guiGridListGetSelectedItem(playerList), 3)
	if(playerName~="") then
		selectedPlayer = playerName
		guiSetText(theBoInfo, "Deseja enviar o convite para "..playerName:gsub('#%x%x%x%x%x%x', '').." ("..playerName..")?")
		guiSetVisible(inviteButton, true)
	else
		selectedPlayer = ""
		guiSetText(theBoInfo, "Nenhum jogador selecionado.")
		guiSetVisible(inviteButton, false)
	end
end

-- this will send the invite to the selected player
function playerInvite()
	if(source==inviteButton) then
		triggerServerEvent("onPlayerInviteGroup", resourceRoot, theManager, selectedPlayer)
		guiSetText(theBoInfo, "O convite foi enviado para "..selectedPlayer..".")
		guiSetVisible(inviteButton, false)
		selectedPlayer = ""
		setTimer(function()
			if(selectedPlayer=="") then
				guiSetText(theBoInfo, "Nenhum jogador selecionado.")
			end
		end, 5000, 1)
	end
end

-- this will give the permissions to manager the group to me
function managerPermissions(theGroup)
	theManager = theGroup
	guiSetText(theManagerInfo, "Você gerencia: "..theManager)
	togglePanel()
end

-- this will show the group invite to me
function receiveInvite(theGroup)
	if(theInvitedGroup=="") then
		theInvitedGroup = theGroup
		outputChatBox("========== ☛ #FFFFFFVocê recebeu um convite! #0064FF☚ ==========", 0, 100, 255, true)
		outputChatBox("Você foi convidado a participar do grupo '"..theGroup.."'!", 255, 255, 255, true)
		outputChatBox("Aceita participar?", 255, 255, 255, true)
		outputChatBox("", 255, 255, 255, true)
		outputChatBox("Digite /aceitar para aceitar o convite.", 255, 255, 255, true)
		outputChatBox("==============================================", 0, 100, 255, true)
		setTimer(function()
			if(theInvitedGroup==theGroup) then
				outputChatBox("Atenção, você tem 15 segundos para aceitar o convite.")
			end
		end, 5000, 1)
		setTimer(function()
			if(theInvitedGroup==theGroup) then
				theInvitedGroup = ""
				outputChatBox("Você rejeitou o convite.", 255, 0, 0)
			end
		end, 20000, 1)
	end
end

-- this will acceppt the invite
function acceptInvite()
	theGroup = theInvitedGroup
	if(theGroup~="") then
		triggerServerEvent("onPlayerAcceptInvite", resourceRoot, theInvitedGroup)
		theInvitedGroup = ""
	end
end

-- key, events & command
bindKey("Z", "down",  togglePanel)
addEventHandler("onClientGUIClick", playerList, invitePlayer)
addEventHandler("onClientGUIClick", inviteButton, playerInvite)
addEvent("onGroupManagerGivePlayerPermissions", true)
addEventHandler("onGroupManagerGivePlayerPermissions", localPlayer, managerPermissions)
addEvent("onPlayerReceiveInvite", true)
addEventHandler("onPlayerReceiveInvite", localPlayer, receiveInvite)
addCommandHandler("aceitar", acceptInvite)