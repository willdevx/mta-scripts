--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2018 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
screenx, screeny = guiGetScreenSize()

-- this will draw the update info message
function drawUpdateInfo()
	dxDrawText("[BnF v2.0] O server foi atualizado.", screenx-205, screeny-46, 0, 0, tocolor(0, 0, 0, 255), 1, "default-bold")
	dxDrawText("[BnF v2.0] O server foi atualizado.", screenx-206, screeny-47, 0, 0, tocolor(255, 0, 0, 255), 1, "default-bold")
end

-- event
addEventHandler("onClientRender", root, drawUpdateInfo)