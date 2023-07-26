--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2018 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2018"
local resourceOfficialName = "PrivateMessageSY"
local resourceDescription = "Sistema de Chat Privado"

-- this will send the message to the player
function sendMessage(theClient, theCommand, thePlayer, ...)
	thePlayer = getElementByData(thePlayer)
	if(thePlayer~=false) then
		if(thePlayer~=theClient) then
			arg = {...}
			textContent = table.concat(arg, " ")
			theClient:outputChat("#FF0040【 ✡  PM ✡ 】 #FFFFFFVocê para "..getPlayerName(thePlayer).." #EFFFF7[ID "..getElementData(thePlayer, "ID").."]: #FFFFFF"..textContent, 255, 255, 255, true)
			thePlayer:outputChat("#FF0040【 ✡  PM ✡ 】 #FFFFFF"..getPlayerName(theClient).." #EFFFF7[ID "..getElementData(theClient, "ID").."]: #FFFFFF"..textContent, 255, 255, 255, true)
			outputServerLog("MENSAGEM PRIVADA: "..getPlayerName(theClient).." ("..getAccountName(getPlayerAccount(theClient))..") para "..getPlayerName(thePlayer).." ("..getAccountName(getPlayerAccount(thePlayer)).."): "..textContent)
			for _, player in ipairs(getElementsByType("player")) do
				if(player~=theClient and player~=thePlayer) then
					local superiorStatus = false
					for _, group in pairs(theSupervisors) do
						if(aclGetGroup(group)) then
							if(isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup(group))) then
								superiorStatus = true
							end
						end
					end
					if(superiorStatus==true) then
						player:outputChat("#FF0040【 ✡  PM (Supervisão) ✡ 】 #FFFFFF"..getPlayerName(theClient).." #EFFFF7[ID "..getElementData(theClient, "ID").."] para "..getPlayerName(thePlayer).." #EFFFF7[ID "..getElementData(thePlayer, "ID").."]: #FFFFFF"..textContent, 255, 255, 255, true)
					end
				end
			end
		else
			theClient:outputChat("* Você não precisa enviar mensagem para si mesmo.", 255, 0, 0)
		end
	else
		theClient:outputChat("* Não encontramos nenhum player com este ID.", 255, 0, 0)
	end
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

-- command
addCommandHandler("pm", sendMessage)