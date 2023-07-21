--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "JobOnibus"
local resourceDescription = "Sistema do Trabalho de Ônibus"
local getX,getY,getZ = 2299.74609375,-1765.4599609375,13.601050376892
local busSpawn =
{
	[1] = {2341.822265625,-1750.806640625,13.389348983765},
	[2] = {2381.8466796875,-1750.9052734375,13.3828125},
	[3] = {2382.5078125,-1730.2490234375,13.3828125},
	[4] = {2312.2470703125,-1730.3837890625,13.3828125},
}
local syStarted = false

-- this will start the job system
function startSy()
	if(syStarted==false) then
		jobIcon = createObject(1239,getX,getY,getZ,0,0,0,true)
		jobMarker = createMarker(getX,getY,getZ-1,"cylinder",1.5,255,153,0,100,true)
		setObjectScale(jobIcon, 2)
		syStarted = true
	end
end

-- this will verify if the player enter in the job marker
function getStarted(hit)
	startState = false
	if(jobMarker~=nil) then
		if(isElementWithinMarker(hit, jobMarker)) then
			startState = true
		end
		if(startState==true) then
			triggerClientEvent(hit,"onJobOnibusRequest",hit)
		end
	end
end

-- this will verify if the player left in the job marker
function getStoped(hit)
	if(source==jobMarker) then
		triggerClientEvent(hit,"onJobOnibusLeftRequest",hit)
	end
end

-- this will start the onibus job
function startOnibusJob()
	selectSpawn = math.random(#busSpawn)
	for k,pos in pairs(busSpawn) do
		if(k==selectSpawn) then
			x = pos[1]
			y = pos[2]
			z = pos[3]
		end
	end
	newBus = createVehicle(431,x,y,z,0,0,90)
	theBusID = getAccountName(getPlayerAccount(client)).."_bus"
	setElementID(newBus,theBusID)
	warpPedIntoVehicle(client, newBus)
end

-- this will stop the job if the player exit the bus
function checkStopJob()
	triggerClientEvent(source, "onPlayerExitBusVehicleCheck", source)
end

-- this will cancel the job
function finishJob()
	theBusID = getAccountName(getPlayerAccount(client)).."_bus"
	theBus = getElementByID(theBusID)
	destroyElement(theBus)
end

-- this will pay the player
function payPlayer(money)
	givePlayerMoney(client, money)
end

-- this will stop the job if the player are wasted
function checkDeath()
	triggerClientEvent(source, "onPlayerWastedBusVehicleCheck", source)
end

-- this will destroy the job bus if the player left the server
function checkLeft()
	theBusID = getAccountName(getPlayerAccount(source)).."_bus"
	theBus = getElementByID(theBusID)
	destroyElement(theBus)
end

-- this will check if the player are job in correctly
function checkJobIn()
	theVehicleID = getElementModel(getPedOccupiedVehicle(client))
	if(theVehicleID~=431) then
		triggerClientEvent(client, "onPlayerExitInBusVehicleCheck", client)
	end
end

-- events
addEventHandler("onResourceStart", getRootElement(), startSy)
addEventHandler("onMarkerHit", getRootElement(), getStarted)
addEventHandler("onMarkerLeave", getRootElement(), getStoped)
addEvent("onJobBusStartedPerRequest", true)
addEventHandler("onJobBusStartedPerRequest", resourceRoot, startOnibusJob)
addEventHandler("onPlayerVehicleExit", getRootElement(), checkStopJob)
addEvent("onPlayerJobFinish", true)
addEventHandler("onPlayerJobFinish", resourceRoot, finishJob)
addEvent("onPlayerBusMoneyRequest", true)
addEventHandler("onPlayerBusMoneyRequest", resourceRoot, payPlayer)
addEventHandler("onPlayerWasted", getRootElement(), checkDeath)
addEventHandler("onPlayerQuit", getRootElement(), checkLeft)
addEvent("onPlayerCheckJobInRequest", true)
addEventHandler("onPlayerCheckJobInRequest", resourceRoot, checkJobIn)