--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2018 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local screenx, screeny = guiGetScreenSize()
local thePhrase = "Verá o sol nascer quadrado para aprender!"

-- this will check the player range position
function checkPlayerRangePosition(forWhat, thePlayer)
	x, y, z = getElementPosition(thePlayer)
	if(isElementInRange(getLocalPlayer(), x, y, z, 2)) then
		if(forWhat=="wanted") then
			triggerServerEvent("onPlayerWantedCheckSuccessfully", resourceRoot, thePlayer)
		end
		if(forWhat=="jail") then
			triggerServerEvent("onPlayerWantedJailSuccessfully", resourceRoot, thePlayer)
		end
		if(forWhat=="handcuff") then
			triggerServerEvent("onPlayerWantedHandcuffSuccessfully", resourceRoot, thePlayer)
		end
		if(forWhat=="unbalance") then
			triggerServerEvent("onPlayerWantedUnbalanceSuccessfully", resourceRoot, thePlayer)
		end
	else
		if(forWhat=="wanted") then
			outputChatBox("* Por favor, se aproxime mais do player para revistá-lo.", 255, 0, 0)
		end
		if(forWhat=="jail") then
			outputChatBox("* Por favor, se aproxime mais do player para prendê-lo.", 255, 0, 0)
		end
		if(forWhat=="handcuff") then
			outputChatBox("* Por favor, se aproxime mais do player para algemá-lo.", 255, 0, 0)
		end
		if(forWhat=="unbalance") then
			outputChatBox("* Por favor, se aproxime mais do player para desalgemá-lo.", 255, 0, 0)
		end
	end
end

-- this will alert it jail status
function holdedInTheJailState()
	theTiming = 60
	setTimer(function()
		theTiming =  theTiming-1
		if(theTiming>0) then
			if(theTiming<57) then
				thePhrase = "Por favor espere "..theTiming.." segundos para ser liberado."
			end
		else
			thePhrase = "Aguarde..."
			setTimer(function()
				removeEventHandler("onClientRender", root, showJailAlert)
				triggerServerEvent("onPlayerLeftTheJail", resourceRoot)
				thePhrase = "DE NOVO? '-' SEU BABACA!"
			end,2000, 1)
		end
	end, 1000, 60)
	addEventHandler("onClientRender", root, showJailAlert)
end

-- this will disable the jail state
function disableJailState()
	removeEventHandler("onClientRender", root, showJailAlert)
	triggerServerEvent("onPlayerLeftTheJail", resourceRoot)
	thePhrase = "DE NOVO? '-' SEU BABACA!"
end

-- this will draw the jail alert
function showJailAlert()
	dxDrawText("Você está preso!", -1, screeny/2-99, screenx, screeny, tocolor(0, 0, 0, blackFade), 2.5, "pricedown", "center")
	dxDrawText("Você está preso!", 0, screeny/2-100, screenx, screeny, tocolor(255, 255, 255, whiteFade), 2.5, "pricedown", "center")
	dxDrawText(thePhrase, -1, screeny/2-19, screenx, screeny, tocolor(0, 0, 0, blackFade), 1.2, "default-bold", "center")
	dxDrawText(thePhrase, 0, screeny/2-20, screenx, screeny, tocolor(255, 255, 255, whiteFade), 1.2, "default-bold", "center")
end

-- additional function
function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
   end
   return false
end

-- events
addEvent("checkPlayerRangePosition", true)
addEventHandler("checkPlayerRangePosition", localPlayer, checkPlayerRangePosition)
addEvent("onHoldedInTheJail", true)
addEventHandler("onHoldedInTheJail", localPlayer, holdedInTheJailState)
addEvent("disabledPrisonState", true)
addEventHandler("disabledPrisonState", localPlayer, disableJailState)