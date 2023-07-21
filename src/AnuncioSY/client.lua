--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
x,y = guiGetScreenSize()
theText = ""
adStaff = "off"
adStatus = "on"

-- this will catch the ad
function adSend(theAd, theType)
	if(adStatus=="on") then
		adStaff = theType
		theText = theAd
		killTimer(timer)
		removeEventHandler("onClientRender", root, showAd)
		addEventHandler("onClientRender", root, showAd)
		timer = setTimer(removeAd, 5000, 1)
		adStatus = "off"
	end
end

-- this will show the ad
function showAd()
	if(adStaff=="off") then
		dxDrawText(theText, 2, y/2, x, y, tocolor(0, 0, 0, 255), 2.5, "default-bold", "center", "top", false, true)
		dxDrawText(theText, 0, y/2, x, y, tocolor(0, 175, 255, 255), 2.5, "default-bold", "center", "top", false, true)
	else
		dxDrawText(adStaff..": "..theText, 2, y/2, x, y, tocolor(0, 0, 0, 255), 2.5, "default-bold", "center", "top", false, true)
		dxDrawText(adStaff..": "..theText, 0, y/2, x, y, tocolor(255, 0, 0, 255), 2.5, "default-bold", "center", "top", false, true)
	end
end

-- this will remove the ad
function removeAd()
	removeEventHandler("onClientRender", root, showAd)
	adStatus = "on"
end

-- events
addEvent("onAdSend", true)
addEventHandler("onAdSend", localPlayer, adSend)