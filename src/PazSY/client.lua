--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
screenx, screeny = guiGetScreenSize()

-- this will verify if the mode is actived or not
function fireMode()
	myself = getLocalPlayer()
	myMode = getElementData(myself, "invulnerable")
	if(myMode=="yes") then
		triggerServerEvent("onFireModeFire", resourceRoot)
	end
end

-- this will make the player invulnerable if the mode is actived
function damageMode()
	myself = getLocalPlayer()
	myMode = getElementData(myself, "invulnerable")
	if(myMode=="yes") then
		cancelEvent()
	end
end

-- this will make the player invulnerable on stealth kill if the mode is actived
function stealthMode(theClient)
	myMode = getElementData(theClient, "invulnerable")
	if(myMode=="yes") then
		cancelEvent()
	end
end

-- this will show to the player if the mode is actived
function toggleMode(theMode)
	if(theMode~="yes") then
		addEventHandler("onClientRender", root, modeDx)
	else
		removeEventHandler("onClientRender", root, modeDx)
	end
	setTimer(function()
		triggerServerEvent("onModeReady", resourceRoot)
	end,5000,1)
end

-- this is what will show if the mode are actived
function modeDx()
	dxDrawText("Você está no Modo Passivo", screenx-180, screeny-60, 0, 0, tocolor(255, 255, 255, 255), 1, "default-bold")
end

-- events
addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(), fireMode)
addEventHandler("onClientPlayerDamage", getLocalPlayer(), damageMode)
addEventHandler("onClientPlayerStealthKill", localPlayer, stealthMode)
addEvent("onModeToggled", true)
addEventHandler("onModeToggled", localPlayer, toggleMode)