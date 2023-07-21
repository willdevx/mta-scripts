--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
detectedHouseID = "0"
enteredHouseID = "0"

-- save detected house id
function detectHouse(theHouseID)
	detectedHouseID = theHouseID
end

-- event detectHouse
addEvent("detectHouse", true)
addEventHandler("detectHouse", localPlayer, detectHouse)

-- remove detected house id
function leaveDetectHouse(theHouseID)
	detectedHouseID = theHouseID
end

-- event leaveDetectHouse
addEvent("leaveDetectHouse", true)
addEventHandler("leaveDetectHouse", localPlayer, leaveDetectHouse)

-- buy a house
function buyHouse(theCommand, thePassword)
	if(thePassword) then
		if(detectedHouseID~="0") then
			triggerServerEvent("buyHouse", resourceRoot, detectedHouseID, thePassword)
		end
	else
		outputChatBox("Por favor, informe uma senha para a sua casa.",255,0,0)
	end
end

-- command buyHouse
addCommandHandler("comprar", buyHouse)

-- enter a house
function enterHouse(theCommand, thePassword)
	if(thePassword) then
		if(detectedHouseID~="0") then
			triggerServerEvent("enterHouse", resourceRoot, detectedHouseID, thePassword)
		end
	else
		outputChatBox("Por favor, informe a senha da casa.",255,0,0)
	end
end

-- command enterHouse
addCommandHandler("entrar", enterHouse)

-- entered house id
function enteredHouse(theHouseID)
	enteredHouseID = theHouseID
end

-- event enteredHouse
addEvent("enteredHouse", true)
addEventHandler("enteredHouse", localPlayer, enteredHouse)

-- exit a house
function exitHouse()
	if(enteredHouseID~="0") then
		triggerServerEvent("exitHouse", resourceRoot, enteredHouseID)
		enteredHouseID = "0"
	end
end

-- command exitHouse
addCommandHandler("sair", exitHouse)

-- anim house icons
setTimer(function()
	for _, object in ipairs(getElementsByType("object")) do
		theModel = getElementModel(object)
		if(theModel==1273 or theModel==1272) then
			x,y,z = getElementPosition(object)
			moveObject(object, 10000, x, y, z, 0, 0, 360)
		end
	end
end,10000,0)

-- show free houses
function showFreeHouses()
	if(showFreeHouses~=true) then
		showFreeHouses = true
		for _, object in ipairs(getElementsByType("object")) do
			theModel = getElementModel(object)
			if(theModel==1273) then
				theBlip = createBlipAttachedTo(object, 31)
			end
		end
	else
		showFreeHouses = false
		for _, blip in ipairs(getElementsByType("blip")) do
			theBlip = getBlipIcon(blip)
			if(theBlip==31) then
				destroyElement(blip)
			end
		end
	end
end

-- key showFreeHouses
bindKey("q", "down", showFreeHouses)