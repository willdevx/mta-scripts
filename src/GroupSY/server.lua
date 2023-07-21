--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "GroupSY"
local resourceDescription = "Sistema de Grupos"

-- this will verify the player permissions
function managerRequest()
	theAccount = getAccountName(getPlayerAccount(client))
	theManager = ""
	for key, value in pairs(theGroups) do
		if(aclGetGroup(value)~=false) then
			if(isObjectInACLGroup("user."..theAccount, aclGetGroup(value))) then
				theManager = key
			end
		end
	end
	if(theManager~="") then
		triggerClientEvent(client, "onGroupManagerGivePlayerPermissions", client, theManager)
	end
end

-- this will invite the player to the group
function invitePlayer(theGroup, thePlayer)
	thePlayer = getPlayerFromName(thePlayer)
	theAccount = getAccountName(getPlayerAccount(thePlayer))
	receiveStatus = true
	for key, value in pairs(theGroups) do
		if(aclGetGroup(key)~=false) then
			if(isObjectInACLGroup("user."..theAccount, aclGetGroup(key))) then
				receiveStatus = false
			end
		end
	end
	if(receiveStatus==true) then
		triggerClientEvent(thePlayer, "onPlayerReceiveInvite", thePlayer, theGroup)
	end
end

-- this will accept the invite
function acceptInvite(theGroup)
	theAccount = getAccountName(getPlayerAccount(client))
	if(theAccount=="guest") then
		client:outputChat("Desculpe, mas é preciso estar logado para participar de grupos.", 255, 0, 0)
	else
		if(aclGetGroup(theGroup)~=false) then
			aclGroupAddObject(aclGetGroup(theGroup), "user."..theAccount)
			client:outputChat("Você agora participa do(a) "..theGroup.."!", 0, 255, 0)
			client:outputChat("Para sair do grupo, é só digitar /sairgrupo.")
			outputChatBox("#0064FF【 ✡  Grupos BnF™ ✡ 】: #FFFFFFO jogador "..getPlayerName(client).." entrou no(a) #FFFFFF"..theGroup.."!", getRootElement(), 0, 0, 0, true)
		else
			client:outputChat("Ocorreu um erro ao entrar no grupo. Por favor, contate o administrador.", 255, 0, 0)
		end
	end
end

-- this will exit the player from the group
function leaveGroup(theClient)
	theAccount = getAccountName(getPlayerAccount(theClient))
	exitStatus = false
	for key, value in pairs(theGroups) do
		if(aclGetGroup(key)~=false) then
			if(isObjectInACLGroup("user."..theAccount, aclGetGroup(key))) then
				exitStatus = true
				theGroup = key
			end
		end
	end
	if(exitStatus==true) then
		if(aclGetGroup(theGroup)~=false) then
			aclGroupRemoveObject(aclGetGroup(theGroup), "user."..theAccount)
			theClient:outputChat("Você saiu do(a) "..theGroup.."!",0,255,0)
			outputChatBox("#0064FF【 ✡  Grupos BnF™ ✡ 】: #FFFFFFO jogador "..getPlayerName(theClient).." saiu do(a) #FFFFFF"..theGroup.."!", getRootElement(), 0,0,0,true)
		else
			theClient:outputChat("Ocorreu um erro ao sair do grupo. Por favor, contate o administrador.", 255, 0, 0)
		end
	end
end

-- events & command
addEvent("onGroupManagerPermissionRequest", true)
addEventHandler("onGroupManagerPermissionRequest", resourceRoot, managerRequest)
addEvent("onPlayerInviteGroup", true)
addEventHandler("onPlayerInviteGroup", resourceRoot, invitePlayer)
addEvent("onPlayerAcceptInvite", true)
addEventHandler("onPlayerAcceptInvite", resourceRoot, acceptInvite)
addCommandHandler("sairgrupo", leaveGroup)