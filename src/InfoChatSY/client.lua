--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "InfoChatSY"
local resourceDescription = "Sistema de Informações no Chat"

-- this will select the information to alert the player
setTimer(function()
	theText = theInfos[math.random(#theInfos)]
	outputChatBox("#FFFFFFInfo BnF™ ⎯  #FF9900"..theText,255,255,255,true)
end,300000,0)