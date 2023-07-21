--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017-2018 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
typingPlayers = {}
typingStatus = false

-- this will end the chat status
function chatMessage()
	--playSound("song/pop.mp3")
end

-- this will send to the server the typing status
function imTyping()
	myself = getLocalPlayer()
	if not(typingPlayers[myself]) then
		triggerServerEvent("onPlayerTyping", resourceRoot)
		addEventHandler("onClientPreRender", getRootElement(), waitTypingChange)
	end
end

-- this will wait for typing change
function waitTypingChange()
	if(isChatBoxInputActive()) then
		typingStatus = true
	end
	if(typingStatus==true) then
		if not(isChatBoxInputActive()) then
			removeEventHandler("onClientPreRender", getRootElement(), waitTypingChange)
			triggerServerEvent("onStopTyping", resourceRoot)
			typingStatus = false
		end
	end
end

-- this will add the player to the typing table
function addTyping(thePlayer)
	if not(typingPlayers[thePlayer]) then
		typingPlayers[thePlayer] = true
	end
end

-- this will remove the player to the typing table
function removeTyping(thePlayer)
	if(typingPlayers[thePlayer]) then
		typingPlayers[thePlayer] = nil
	end
end

-- this will draw the typing players
function drawTyping()
	px, py, pz = getCameraMatrix()
	for player in pairs(typingPlayers) do
		x,y,z = getPedBonePosition(player, 8)
		sX,sY = getScreenFromWorldPosition(x,y,z+0.4)
		dist = math.sqrt((px-x)^2+(py-y)^2+(pz-z)^2)
		if(dist<50 and sX and sY) then
			dxDrawImage(sX, sY, 200, 40, "image/typing.png", 0, 0, 0, tocolor(255,255,255,dxAlpha))
		end
	end
end

-- events
bindKey("T", "down", imTyping)
addEvent("onPlayerChatTag", true)
addEventHandler("onPlayerChatTag", localPlayer, chatMessage)
addEvent("onPlayerStartTyping", true)
addEventHandler("onPlayerStartTyping", localPlayer, addTyping)
addEvent("onPlayerStopTyping", true)
addEventHandler("onPlayerStopTyping", localPlayer, removeTyping)
addEventHandler("onClientPreRender", getRootElement(), drawTyping)