--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "HudSY"
local resourceDescription = "Sistema de HUD"
local me = getLocalPlayer()
local px,py = guiGetScreenSize()
local money = "0"
local health = "0"
local armor = "0"
local weapon = nil
local weapon_loc = nil
local totalAmmo = "0"
local pentAmmo = "0"
local rsr, rsg, rsb = 255,153,0
local hudComps = {"armour","breath","clock","health","money","weapon","ammo","wanted","area_name","vehicle_name","radio"}
local wantedStarsLevel = ""

-- this will start the system
function startSystem(res)
	if(getResourceName(res)=="HudSY") then
		for _,comp in pairs(hudComps) do
			setPlayerHudComponentVisible(comp, false)
		end
		addEventHandler("onClientRender", root, drawHud)
	end
end

-- this will update some system informations
setTimer(function()
	money = getPlayerMoney()
	if(money>-1) then
		rsr, rsg, rsb = 255,153,0
	else
		rsr, rsg, rsb = 255,0,0
	end
	health = 140*getElementHealth(me)/100
	armor = 142*getPedArmor(me)/100
	weapon = string.lower(getWeaponNameFromID(getPedWeapon(me)))
	totalAmmo = getPedTotalAmmo(me)
	pentAmmo = getPedAmmoInClip(me)
	weapon_loc = "img/"..weapon..".png"
	wantedStarsLevel = ""
	i = 0
	while i<getPlayerWantedLevel() do
		i = i+1
		wantedStarsLevel = wantedStarsLevel.."★"
	end
end,100,0)

-- this will to draw the hud to me
function drawHud()
	dxDrawText("r$"..money,px*2-266,51,0,0,tocolor(0,0,0,255),1,"pricedown","center")
	dxDrawText("r$"..money,px*2-265,50,0,0,tocolor(rsr,rsg,rsb,255),1,"pricedown","center")
	dxDrawRectangle(px-202,85,142,14,tocolor(0,0,0,75))
	dxDrawRectangle(px-202,85,armor,14,tocolor(255,255,255,255))
	dxDrawRectangle(px-201,86,health,12,tocolor(255,0,0,215))
	if(weapon~="fist" and weapon~=nil) then
		dxDrawImage(px-201,90,60,60,weapon_loc)
		dxDrawText(weapon,px-134,109,0,0,tocolor(0,0,0,255),0.8,"pricedown")
		dxDrawText(weapon,px-135,108,0,0,tocolor(255,153,0,255),0.8,"pricedown")
		dxDrawText(pentAmmo.." / "..totalAmmo,px-135,128,0,0,tocolor(0,0,0,255),1,"default-bold")
		dxDrawText(pentAmmo.." / "..totalAmmo,px-135,127,0,0,tocolor(255,255,255,255),1,"default-bold")
		dxDrawText(wantedStarsLevel,px-135,147,0,0,tocolor(255,255,255,255),1,"default-bold")
	else
		dxDrawText(wantedStarsLevel,px-201,106,0,0,tocolor(255,255,255,255),1.4,"default-bold")
	end
end

-- this will stop the system
function stopSystem(res)
	if(getResourceName(res)=="HudSY") then
		for _,comp in pairs(hudComps) do
			setPlayerHudComponentVisible(comp, true)
		end
		removeEventHandler("onClientRender", root, drawHud)
	end
end

-- events
addEventHandler("onClientResourceStart", getRootElement(), startSystem)
addEventHandler("onClientResourceStop", getRootElement(), stopSystem)