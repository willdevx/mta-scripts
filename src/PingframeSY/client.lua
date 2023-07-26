--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "PingframeSY"
local resourceDescription = "Sistema para mostrar o Ping e FPS"
screenx, screeny = guiGetScreenSize()
myFPS = 0
myPing = 0
upTime = 0

-- this will update the framerate and the ping
function update(lastFrame)
    FPS = string.match((1/lastFrame)*1000, "%d+")
	Ping = getPlayerPing(getLocalPlayer())
	upTime = upTime+1
	if(upTime==15) then
		myFPS = FPS
		myPing = Ping
		upTime = 0
	end
end

-- this will show the pingframe to me
function drawPingframe()
	dxDrawText("fps", screenx-85, 6, screenx, screeny, tocolor(0, 0, 0, 200), 0.5, "pricedown")
	dxDrawText("fps", screenx-86, 5, screenx, screeny, tocolor(255, 255, 255, 255), 0.5, "pricedown")
	dxDrawText(myFPS, screenx-89, 11, screenx, screeny, tocolor(0, 0, 0, 200), 1, "pricedown")
	dxDrawText(myFPS, screenx-90, 10, screenx, screeny, tocolor(255, 153, 0, 255), 1, "pricedown")
	dxDrawText("pInG", screenx-45, 6, screenx, screeny, tocolor(0, 0, 0, 200), 0.5, "pricedown")
	dxDrawText("pInG", screenx-46, 5, screenx, screeny, tocolor(255, 255, 255, 255), 0.5, "pricedown")
	dxDrawText(myPing, screenx-49, 11, screenx, screeny, tocolor(0, 0, 0, 200), 1, "pricedown")
	dxDrawText(myPing, screenx-50, 10, screenx, screeny, tocolor(255, 153, 0, 255), 1, "pricedown")
end

-- events
addEventHandler("onClientPreRender", root, update)
addEventHandler("onClientRender", root, drawPingframe)