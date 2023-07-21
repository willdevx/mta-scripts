--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "AntiLogoutSY"
local resourceDescription = "Sistema de AntiLogout"

-- this will make impossible the logout
function antiLogout()
	cancelEvent()
	source:outputChat("#FF0000【 Inteligência BnF™ 】:#999999 Atenção, #FFFFFF"..getPlayerName(source).."#999999: tentativa de logout detectada. Por favor, não faça mais isso.", 255,255,255, true)
end

-- events
addEventHandler("onPlayerLogout", getRootElement(), antiLogout)