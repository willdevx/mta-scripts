--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
theStation = ""
radioStatus = "offline"
x,y = guiGetScreenSize()
musicList = 0
soundStopped = "false"
theRemixer = ""
blockAds =
{
	[1] = "none",
}
blockState = false

-- this will start the station selected
function playStation(theURL, theName)
	if(radioStatus=="online") then
		stopSound(theRadio)
	end
	theStation = theURL
	theRemixer = theName
	theRadio = playSound(theStation, true)
	if(theStation==defaultStation) then
		listeningNow = "Estamos ao vivo na Rádio BnF™! ~ RaidCall: 6367487 ~ para mutar/desmutar, aperte [M]"
	else
		listeningNow = "Rádio BnF™ Online! ~ RaidCall: 6367487 ~ para mutar/desmutar, aperte [M]"
	end
	setElementData(getLocalPlayer(), "listeningNow", listeningNow)
end

-- streamTitle event
addEventHandler("onClientSoundChangedMeta", root, function(streamTitle)
	playSound("sound.mp3")
	musicList = musicList+1
	blockAdsState = false
	for _,ad in pairs(blockAds) do
		if(streamTitle==ad) then
			blockAdsState = true
		end
	end
	if(blockAdsState==false) then
		if(blockState==true) then
			if(radioStatus~="offline") then
				if(soundStopped=="true") then
					blockState = false
					setSoundVolume(theRadio, 1)
					soundStopped = "false"
					outputChatBox("A Rádio BnF™ está desmutada.")
				end
			end
		end
		if(theRemixer~="") then
			listeningNow = "Locutor: "..theRemixer.." ~ "..musicList..". "..streamTitle
		else
			listeningNow = musicList..". "..streamTitle
		end
	else
		if(radioStatus~="offline") then
			if(soundStopped=="false") then
				blockState = true
				setSoundVolume(theRadio, 0)
				soundStopped = "true"
				outputChatBox("A Rádio BnF™ está mutada.")
				listeningNow = "A rádio BnF™ bloqueou esta propaganda. A rádio irá voltar assim que ela acabar."
			end
		end
	end
	setElementData(getLocalPlayer(), "listeningNow", listeningNow)
end)

-- this will show the radio
function startRadio(reason)
	if(reason=="play" or reason=="resumed") then
		radioStatus = "online"
	end
end

-- this will set the radio vol status to mute or unmute
function radioVolState()
	bindKey("M", "down", muteRadio)
end

-- this function mute/unmute the radio
function muteRadio()
	if(radioStatus~="offline") then
		if(soundStopped=="false") then
			setSoundVolume(theRadio, 0)
			soundStopped = "true"
			outputChatBox("A Rádio BnF™ está mutada.")
		else
			setSoundVolume(theRadio, 1)
			soundStopped = "false"
			outputChatBox("A Rádio BnF™ está desmutada.")
		end
	end
end

-- events
addEvent("onStationRadio", true)
addEventHandler("onStationRadio", localPlayer, playStation)
addEventHandler("onClientSoundStarted", getRootElement(), startRadio)
addEventHandler("onClientResourceStart", resourceRoot, radioVolState)