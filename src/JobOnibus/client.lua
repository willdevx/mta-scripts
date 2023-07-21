--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local jobState = false
local inJob = false
local jobDescr = "#FF0000Trabalho de Motorista de Ônibus #FFFFFF→  Neste trabalho você terá que buscar e levar os passageiros até o seu destino. Sua recompensa depende de quantas pessoas irão entrar no seu ônibus."
local px,py = guiGetScreenSize()
local alertFade = 0
local fadePos = true
local alertText = ""
local alert2Text = ""
local missionObjectiveText = ""
local missionFailed = false
local missionSuccess = false
local objective1 = false
local objective2 = false
local busPeoples =
{
	[1] = {1232.0947265625,-1849.783203125,13.3828125},
	[2] = {2867.67578125,-1356.318359375,10.920665740967},
	[3] = {2679.7470703125,-2153.1591796875,10.915885925293},
	[4] = {2685.83984375,-2470.3984375,13.524890899658},
}
local busDestiny =
{
	[1] = {1413.56640625,-1734.4453125,13.390607833862},
	[2] = {830.2265625,-1407.2490234375,13.303194046021},
	[3] = {798.3388671875,-1076.677734375,24.219123840332},
	[4] = {481.82421875,-1726.72265625,11.021469116211},
}
local busPeopleQuan = {46,50,32,24,27,42,40,36,38}
local busQuan = 0

-- this will start the job
function startJob()
	if(inJob==false) then
		jobState = true
		outputChatBox("⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯   Trabalho BnF™  ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯",255,153,0)
		outputChatBox(jobDescr,255,255,255,true)
		outputChatBox(" ")
		outputChatBox("* Digite #FF0000/aceitar #FFFFFFpara aceitar o trabalho.",255,255,255,true)
		outputChatBox("⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯",255,153,0)
	else
		outputChatBox("* Você já está trabalhando.",255,0,0)
	end
end

-- this will stop the job
function stopJob()
	jobState = false
end

-- this will start the accepted job
function getJobStarted()
	if(jobState==true) then
		inJob = true
		triggerServerEvent("onJobBusStartedPerRequest", resourceRoot)
		selectPeoples = math.random(#busPeoples)
		for k,ps in pairs(busPeoples) do
			if(k==selectPeoples) then
				x = ps[1]
				y = ps[2]
				z = ps[3]
			end
		end
		ob1Marker = createMarker(x,y,z-1,"cylinder",5,255,153,0,100,true)
		ob1Blip = createBlipAttachedTo(ob1Marker, 21)
		missionObjectiveText = "Vá buscar os passageiros no ponto marcado em coração no minimapa."
		addEventHandler("onClientRender", root, missionObjective)
	end
end

-- thsi will show the mission objective
function missionObjective()
	dxDrawText("Objetivo do trabalho",px-219,161,px,py,tocolor(0,0,0,255),1,"default-bold")
	dxDrawText(missionObjectiveText,px-219,176,px,py,tocolor(0,0,0,255),1,"default-bold","left","top",false,true)
	dxDrawText("Objetivo do trabalho",px-220,160,px,py,tocolor(255,153,0,255),1,"default-bold")
	dxDrawText(missionObjectiveText,px-220,175,px,py,tocolor(255,255,255,255),1,"default-bold","left","top",false,true)
end

-- objectives
function objectives(hit)
	if(hit==getLocalPlayer()) then
		if(source==ob1Marker) then
			if(objective1==false) then
				objective2 = true
				missionObjectiveText = "Aguarde os passageiros entrarem no ônibus."
				setTimer(function()
					outputChatBox("Os passageiros estão entrando no ônibus. Aguarde...",255,153,0)
				end,2000,1)
				setTimer(function()
					if(objective2==true) then
						quanPeople = math.random(#busPeopleQuan)
						for k,q in pairs(busPeopleQuan) do
							if(k==quanPeople) then
								peoples = q
							end
						end
						busQuan = peoples
						outputChatBox(peoples.." pessoas entraram no ônibus!",255,153,0)
						destroyElement(ob1Marker)
						destroyElement(ob1Blip)
						selectDestiny = math.random(#busDestiny)
						for k,ds in pairs(busDestiny) do
							if(k==selectDestiny) then
								x = ds[1]
								y = ds[2]
								z = ds[3]
							end
						end
						ob2Marker = createMarker(x,y,z-1,"cylinder",5,255,153,0,100,true)
						ob2Blip = createBlipAttachedTo(ob2Marker, 21)
						missionObjectiveText = "Leve os passageiros no ponto marcado em coração no minimapa."
					end
				end,10000,1)
				objective1 = true
			end
		end
		if(source==ob2Marker) then
			showSM()
		end
	end
end

-- this will show the success mission
function successMission()
	if(fadePos==true) then
		if(alertFade<255) then
			alertFade = alertFade+3
		else
			alertFade = 255
		end
	end
	if(fadePos==false) then
		if(alertFade>0) then
			alertFade = alertFade-3
		else
			alertFade = 0
		end
	end
	dxDrawText("destino alcançado",1,py/2-64,px,py,tocolor(0,0,0,alertFade),2,"pricedown","center")
	dxDrawText("destino alcançado",0,py/2-65,px,py,tocolor(255,153,0,alertFade),2,"pricedown","center")
	dxDrawText(alert2Text,1,py/2-12,px,py,tocolor(0,0,0,alertFade),1,"pricedown","center")
	dxDrawText(alert2Text,0,py/2-13,px,py,tocolor(255,255,255,alertFade),1,"pricedown","center")
end

-- success mission
function showSM()
	missionSuccess = true
	missionObjectiveText = "Não saia do ônibus. Aguarde..."
	busMoney = busQuan*468
	alert2Text = "você ganhou r$"..busMoney..",00!"
	triggerServerEvent("onPlayerBusMoneyRequest", resourceRoot, busMoney)
	if(ob2Marker and ob2Blip) then
		destroyElement(ob2Marker)
		destroyElement(ob2Blip)
	end
	addEventHandler("onClientRender", root, successMission)
	setTimer(function()
		fadePos = false
		setTimer(function()
			fadePos = true
			if(inJob==true) then
				selectPeoples = math.random(#busPeoples)
				for k,ps in pairs(busPeoples) do
					if(k==selectPeoples) then
						x = ps[1]
						y = ps[2]
						z = ps[3]
					end
				end
				ob1Marker = createMarker(x,y,z-1,"cylinder",5,255,153,0,100,true)
				ob1Blip = createBlipAttachedTo(ob1Marker, 21)
				missionObjectiveText = "Vá buscar os passageiros no ponto marcado em coração no minimapa."
			end
			missionSuccess = false
			objective1 = false
			removeEventHandler("onClientRender", root, successMission)
			alert2Text = ""
		end,5000,1)
	end,7000,1)
end

-- this will show the failed mission
function failedMission()
	if(fadePos==true) then
		if(alertFade<255) then
			alertFade = alertFade+3
		else
			alertFade = 255
		end
	end
	if(fadePos==false) then
		if(alertFade>0) then
			alertFade = alertFade-3
		else
			alertFade = 0
		end
	end
	dxDrawText("trabalho perdido",1,py/2-64,px,py,tocolor(0,0,0,alertFade),2,"pricedown","center")
	dxDrawText("trabalho perdido",0,py/2-65,px,py,tocolor(255,0,0,alertFade),2,"pricedown","center")
	dxDrawText(alertText,1,py/2-12,px,py,tocolor(0,0,0,alertFade),1,"pricedown","center")
	dxDrawText(alertText,0,py/2-13,px,py,tocolor(255,255,255,alertFade),1,"pricedown","center")
end

-- failed mission
function showFM()
	removeEventHandler("onClientRender", root, missionObjective)
	if(ob1Marker and ob1Blip) then
		destroyElement(ob1Marker)
		destroyElement(ob1Blip)
	end
	if(ob2Marker and ob2Blip) then
		destroyElement(ob2Marker)
		destroyElement(ob2Blip)
	end
	if(missionSuccess==false and missionFailed==true) then
		objective1 = false
		objective2 = false
		addEventHandler("onClientRender", root, failedMission)
		setTimer(function()
			fadePos = false
			setTimer(function()
				fadePos = true
				inJob = false
				removeEventHandler("onClientRender", root, failedMission)
				alertText = ""
				missionFailed = false
			end,5000,1)
		end,7000,1)
	else
		missionFailed = false
		inJob = false
		alertText = ""
	end
end

-- this will check if the player exit the bus
function checkExitBusState()
	if(inJob==true) then
		missionFailed = true
		triggerServerEvent("onPlayerJobFinish", resourceRoot)
		alertText = "não abandone os passageiros, seu bastardo!"
		showFM()
	end
end

-- this will check if the player exit the bus
function checkWastedBusState()
	if(inJob==true) then
		missionFailed = true
		triggerServerEvent("onPlayerJobFinish", resourceRoot)
		alertText = "não morra no trabalho, seu bastardo!"
		showFM()
	end
end

-- this will check if the player exit the in bus
function checkExitInBusState()
	if(inJob==true) then
		missionFailed = true
		triggerServerEvent("onPlayerJobFinish", resourceRoot)
		alertText = "o que você está fazendo, seu bastardo?!"
		showFM()
	end
end

-- this will check if the player are working correctly
setTimer(function()
	if(inJob==true and missionFailed==false) then
		triggerServerEvent("onPlayerCheckJobInRequest", resourceRoot)
	end
end,5000,0)

-- events & commands
addEvent("onJobOnibusRequest", true)
addEventHandler("onJobOnibusRequest", localPlayer, startJob)
addEvent("onJobOnibusLeftRequest", true)
addEventHandler("onJobOnibusLeftRequest", localPlayer, stopJob)
addCommandHandler("aceitar", getJobStarted)
addEvent("onPlayerExitBusVehicleCheck", true)
addEventHandler("onPlayerExitBusVehicleCheck", localPlayer, checkExitBusState)
addEventHandler("onClientMarkerHit", getRootElement(), objectives)
addEvent("onPlayerWastedBusVehicleCheck", true)
addEventHandler("onPlayerWastedBusVehicleCheck", localPlayer, checkWastedBusState)
addEvent("onPlayerExitInBusVehicleCheck", true)
addEventHandler("onPlayerExitInBusVehicleCheck", localPlayer, checkExitInBusState)