--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
px,py = guiGetScreenSize()
local imageIn = false
local soundIn = false

-- this will show the headshot effect
function showHeadshot()
	if(soundIn==true) then
		killTimer(soundTimer)
		stopSound(theSound)
	end
	theSound = playSound("fuck.mp3")
	soundTimer = setTimer(function()
		soundIn = false
	end,14000,1)
	soundIn = true

	if(imageIn==false) then
		setTimer(function()
			addEventHandler("onClientRender", root, headShot)
			imageIn = true
		end,750,1)
	else
		killTimer(removeTimer)
		removeEventHandler("onClientRender", root, headShot)
		setTimer(function()
			addEventHandler("onClientRender", root, headShot)
			imageIn = true
		end,750,1)
	end
	removeTimer = setTimer(function()
		if(imageIn==true) then
			removeEventHandler("onClientRender", root, headShot)
			imageIn = false
		end
	end,5000,1)
end

-- headshot event
function headShot()
	dxDrawImage(px/2-115,100,241,150,"headshot.png")
end

-- events
addEvent("onKillerMakeHeadshot", true)
addEventHandler("onKillerMakeHeadshot", localPlayer, showHeadshot)