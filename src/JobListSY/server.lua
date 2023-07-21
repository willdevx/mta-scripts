--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "JobListSY"
local resourceDescription = "Sistema de Listar Trabalhos"

-- this will alert to the players when someone make a job list request
function jobListAlert()
	outputChatBox("* [#77CCFF/trabalhos#FFFFFF] O jogador #77CCFF"..getPlayerName(client).." #FFFFFFestá vendo a lista de trabalhos.",getRootElement(),255,255,255,true)
end

-- this will alert to the player when someone select a job to go
function jobListSelectedAlert(job)
	outputChatBox("* [#77CCFF/trabalhos#FFFFFF] O jogador #77CCFF"..getPlayerName(client).." #FFFFFFfoi trabalhar de #77CCFF"..job.."#FFFFFF.",getRootElement(),255,255,255,true)
end

-- events
addEvent("onPlayerJobListRequest", true)
addEventHandler("onPlayerJobListRequest", resourceRoot, jobListAlert)
addEvent("onPlayerJobListSelected", true)
addEventHandler("onPlayerJobListSelected", resourceRoot, jobListSelectedAlert)