--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017-2018 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017-2018"
local resourceOfficialName = "ChatTagSY"
local resourceDescription = "Sistema de Chat"

-- this will send the text to the players
function sendText(m, t)
	cancelEvent()
	myName = getPlayerName(source)
	myAccount = getPlayerAccount(source)
	myAccountName = getAccountName(myAccount)
	myMainGroup = system["ACL"][2][1]
	myMainGroupName = system["ACL"][1][1]
	staffStatus = false
	playerFreq = getElementData(source, "chatfreq")
	if(playerFreq~=false) then
		setElementData(source, "chatfreq", playerFreq+1)
	else
		setElementData(source, "chatfreq", 1)
		playerFreq = 0
	end
	if(playerFreq==0) then
		if(t==0) then
			for _, v in ipairs(system["ACL"]) do
				if(aclGetGroup(v[1])~=false) then
					if(isObjectInACLGroup("user."..myAccountName, aclGetGroup(v[1]))) then
						if not(isGuestAccount(myAccount)) then
							myMainGroup = v[2]
							myMainGroupName = v[1]
						else
							myMainGroup = system["ACL"][2][2]
						end
					end
				end
			end
			invalidWords = {}
			for word in m:gmatch("%a+") do
				for _, v in ipairs(system["Censure"]) do
					if(v:upper()==word:upper()) then
						table.insert(invalidWords, word)
					end
				end
			end
			for _,invalidword in ipairs(invalidWords) do
				m = m:gsub(invalidword, "**")
			end
			nickColorSel = math.random(5)
			if(nickColorSel==1) then
				nickColorSel = "#8181F7"
			elseif(nickColorSel==2) then
				nickColorSel = "#F7819F"
			elseif(nickColorSel==3) then
				nickColorSel = "#A9F5A9"
			elseif(nickColorSel==4) then
				nickColorSel = "#F2F5A9"
			elseif(nickColorSel==5) then
				nickColorSel = "#F79F81"
			end
			for _, v in ipairs(system["ColoredStaff"]) do
				if(v==myMainGroupName) then
					staffStatus = true
				end
			end
			if(staffStatus~=true) then
				outputMessage = myMainGroup..nickColorSel..myName.." #EFFFF7[ID "..getElementData(source, "ID").."]: #FFFFFF"..string.sub(m, 1, 1):upper()..string.sub(m, 2)
			else
				outputMessage = myMainGroup..nickColorSel..myName.." #EFFFF7[ID "..getElementData(source, "ID").."]: #FF9900"..string.sub(m, 1, 1):upper()..string.sub(m, 2)
			end
			outputChatBox(outputMessage, getRootElement(), 255, 255, 255, true)
			outputServerLog("CHAT: "..myName.." ("..myAccountName.."): "..m)
			for _, player in ipairs(getElementsByType("player")) do
				triggerClientEvent(player, "onPlayerChatTag", player)
			end
		elseif(t==1) then
			source:outputChat("Não é permitido /me no nosso servidor.", 255, 0, 0)
		elseif(t==2) then
			source:outputChat("Não é permitido chat por time no nosso servidor.", 255, 0, 0)
		end
	else
		if(playerFreq<3) then
			source:outputChat("Por favor, não faça flood no chat, ou será mutado por 2 minutos.", 255, 0, 0)
		else
			setPlayerMuted(source, true)
			setElementData(source, "chatmute", 120)
			source:outputChat("Você foi mutado por 2 minutos por fazer flood no chat.", 255, 0, 0)
			outputChatBox("#FF0000* #999999O "..getPlayerName(source).." #999999foi mutado pela #FFFFFFInteligência BnF™ #999999por tentativa de flood.", getRootElement(), 255,255,255, true)
			outputServerLog("MUTE: "..myName.." ("..myAccountName..") foi mutado pela Inteligência BnF™.")
		end
	end
end

-- this will check the players typing frequence
setTimer(function()
	for _, player in ipairs(getElementsByType("player")) do
		playerFreq = getElementData(player, "chatfreq")
		playerMute = getElementData(player, "chatmute")
		if(playerFreq~=false) then
			if(playerFreq>0) then
				setElementData(player, "chatfreq", playerFreq-1)
			end
		end
		if(playerMute~=false) then
			if(playerMute<2) then
				setPlayerMuted(player, false)
				setElementData(player, "chatmute", false)
				player:outputChat("Você foi desmutado. Por favor, não faça mais flood no chat.", 0, 255, 0)
				outputServerLog("DESMUTE: "..myName.." ("..myAccountName..") foi desmutado pela Inteligência BnF™.")
			else
				setElementData(player, "chatmute", playerMute-1)
			end
		end
	end
end, 1000, 0)

-- this will add to the typing players to all players
function imTyping()
	for _, player in ipairs(getElementsByType("player")) do
		triggerClientEvent(player, "onPlayerStartTyping", player, client)
	end
end

-- this will stop the typing status
function stopTyping()
	for _, player in ipairs(getElementsByType("player")) do
		triggerClientEvent(player, "onPlayerStopTyping", player, client)
	end
end

-- this will stop the typing when the player quit the server
function stopQuitTyping()
	for _, player in ipairs(getElementsByType("player")) do
		triggerClientEvent(player, "onPlayerStopTyping", player, source)
	end
end

-- events
addEventHandler("onPlayerChat", getRootElement(), sendText)
addEvent("onPlayerTyping", true)
addEventHandler("onPlayerTyping", resourceRoot, imTyping)
addEvent("onStopTyping", true)
addEventHandler("onStopTyping", resourceRoot, stopTyping)
addEventHandler("onPlayerQuit", getRootElement(), stopQuitTyping)