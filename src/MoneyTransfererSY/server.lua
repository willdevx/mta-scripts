--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2018 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2018"
local resourceOfficialName = "MoneyTransfererSY"
local resourceDescription = "Sistema de Transferir Dinheiro"

-- this will to transfer the money to the player
function transferMoney(theClient, theCommand, thePlayerID, theValue, ...)
	if(isGuestAccount(getPlayerAccount(theClient))==false) then
		thePlayer = getElementByData(thePlayerID)
		if(thePlayer~=false) then
			if(theClient~=thePlayer) then
				if(tonumber(theValue)) then
					if(tonumber(getPlayerMoney(theClient))>=tonumber(theValue)) then
						if(tonumber(theValue)>0) then
							takePlayerMoney(theClient, tonumber(theValue))
							givePlayerMoney(thePlayer, tonumber(theValue))
							messArg = {...}
							messContent = table.concat(messArg, " ")
							theClient:outputChat("Você transferiu #FF0000R$"..tonumber(theValue)..",00 #FFFFFFpara "..getPlayerName(thePlayer).." #EFFFF7[ID "..thePlayerID.."]#FFFFFF.", 255, 255, 255, true)
							if(...) then
								theClient:outputChat("Com a mensagem: '"..messContent.."'.")
							else
								theClient:outputChat("* Dica: você pode mandar uma mensagem na notificação que os jogadores recebem ao transferir dinheiro. Ex: /trans 12 1000 Está pago! ~ O jogador com ID 12 irá receber R$1.000,00 com a mensagem 'Está pago!'.")
								messContent = false
							end
							triggerClientEvent(thePlayer, "onPlayerTransfererMoney", thePlayer, theClient, theValue, messContent)
							if(messContent) then
								outputServerLog("TRANSFERIDOR DE DINHEIRO: O jogador "..getPlayerName(theClient).." ("..getAccountName(getPlayerAccount(theClient))..") enviou R$"..tonumber(theValue)..",00 para "..getPlayerName(thePlayer).." ("..getAccountName(getPlayerAccount(thePlayer))..") com a mensagem '"..messContent.."'.")
							else
								outputServerLog("TRANSFERIDOR DE DINHEIRO: O jogador "..getPlayerName(theClient).." ("..getAccountName(getPlayerAccount(theClient))..") enviou R$"..tonumber(theValue)..",00 para "..getPlayerName(thePlayer).." ("..getAccountName(getPlayerAccount(thePlayer))..").")
							end
						else
							theClient:outputChat("* Você não pode transferir um valor nulo.", 255, 0, 0)
						end
					else
						theClient:outputChat("* Você não tem esse dinheiro.", 255, 0, 0)
					end
				else
					theClient:outputChat("* Por favor, insira um valor válido para transferir.", 255, 0, 0)
				end
			else
				theClient:outputChat("* Você não precisa transferir dinheiro para você mesmo.", 255, 0, 0)
			end
		else
			theClient:outputChat("* Não encontramos nenhum player com este ID.", 255, 0, 0)
		end
	else
		theClient:outputChat("* Você precisa estar logado para transferir dinheiro.", 255, 0, 0)
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
addCommandHandler("trans", transferMoney)