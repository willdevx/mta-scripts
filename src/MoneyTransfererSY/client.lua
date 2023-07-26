--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2018 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local screenx, screeny = guiGetScreenSize()
local theClient = nil
local theValue = nil
local messContent = nil
local showTransfererMessages = true
local rectangleFade = 150
local textFade = 250
local startFadeout = false

-- this will info the players the system function
function infoSYFunction()
	if(showSYFunctionMessageOnKey==true) then
		outputChatBox("#EEEEEE["..onBindKey.."] #FFFFFFPara #FF0000transferir dinheiro#FFFFFF, utilize o comando [/trans ID valor].", 255, 255, 255, true)
		outputChatBox("Ex: /trans 12 25000 ~ transfere R$25.000,00 para o ID 12.")
		outputChatBox("Dica: você também pode mandar uma mensagem ao transferir dinheiro para alguém. É só escrever depois de informar o valor. Ex: /trans 12 1000 parabéns pelo serviço!")
	end
end

-- this will alert the player when gives money
function alertMoneyTransferer(theServerClient, theServerValue, theServerMessContent)
	rectangleFade = 150
	textFade = 250
	startFadeout = false
	theClient = getPlayerName(theServerClient):gsub('#%x%x%x%x%x%x', '')
	theValue = tonumber(theServerValue)
	messContent = theServerMessContent
	removeNotification = setTimer(function()
		startFadeout = true
	end,3000,1)
	if(showTransfererMessages==true) then
		removeEventHandler("onClientRender", root, alertTransferer)
		addEventHandler("onClientRender", root, alertTransferer)
	else
		removeEventHandler("onClientRender", root, alertTransferer)
		outputChatBox("#000000[#FFFFFF Transferência de Dinheiro #000000]  ~  #FFFFFF"..getPlayerName(theServerClient).." te enviou #FF0000R$"..theValue..",00!",255,255,255,true)
	end
end

-- this will draw the alert
function alertTransferer()
	if(startFadeout==true) then
		if(rectangleFade>=2) then
			rectangleFade = rectangleFade-2
		end
		if(textFade>=2) then
			textFade = textFade-2
		end
		if(textFade==0 and rectangleFade==0) then
			startFadeout = false
		end
	end
	dxDrawRectangle(0, 0, screenx, screeny, tocolor(0,0,0,rectangleFade))
	dxDrawText(theClient.." te enviou",0,screeny/2-138,screenx,100,tocolor(0,0,0,textFade),2,"default-bold","center")
	dxDrawText(theClient.." te enviou",0,screeny/2-140,screenx,100,tocolor(0,255,167,textFade),2,"default-bold","center")
	dxDrawText("R$"..theValue..",00",2,screeny/2-103,screenx,100,tocolor(0,0,0,textFade),2.5,"default-bold","center")
	dxDrawText("R$"..theValue..",00",0,screeny/2-105,screenx,100,tocolor(255,255,255,textFade),2.5,"default-bold","center")
	dxDrawText("Dê /stm para não mostrar mais essas mensagens na tela",0,screeny/2+30,screenx,100,tocolor(255,255,255,textFade),1,"default-bold","center")
	if(messContent) then
		dxDrawText(messContent,2,screeny/2-60,screenx,100,tocolor(0,0,0,textFade),1.5,"default-bold","center","top",false,true)
		dxDrawText(messContent,0,screeny/2-58,screenx,100,tocolor(255,255,255,textFade),1.5,"default-bold","center","top",false,true)
	end
end

function toggleTransfererMessages()
	if(showTransfererMessages==true) then
		showTransfererMessages = false
		outputChatBox("* As mensagens de transferência de dinheiro na tela foram desativas. Você receberá essas mensagens no chat a partir de agora.")
		outputChatBox("Digite /stm novamente para reativar as mensagens na tela.")
	else
		showTransfererMessages = true
		outputChatBox("* As mensagens de transferência de dinheiro na tela foram reativadas.")
	end
end

-- events & command
bindKey(onBindKey, "down", infoSYFunction)
addEvent("onPlayerTransfererMoney", true)
addEventHandler("onPlayerTransfererMoney", localPlayer, alertMoneyTransferer)
addCommandHandler("stm", toggleTransfererMessages)