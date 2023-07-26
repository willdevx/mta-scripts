--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]] -----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "LetreiroSY"
local resourceDescription = "Sistema de Letreiro"
x, y = guiGetScreenSize()
alpha = 0
inter = 0
theChosen = 0
total = false

-- the informations that will appear in the signboard
function setText()
    if (theChosenText[theChosen]) then
        chosenText = theChosenText[theChosen]
    else
        theChosen = 0
    end
end

-- the signboard
function showLetter()
    if (total == false) then
        alpha = alpha + 4
    end
    if (total == true) then
        alpha = alpha - 4
    end
    if (alpha > 244) then
        total = true
        inter = inter + 1
    end
    if (alpha < 1) then
        total = false
    end
    if (inter == 5) then
        inter = 0
        theChosen = theChosen + 1
        setText()
    end
    if (theChosen == 0) then
        theChosen = theChosen + 1
        setText()
    end
    theText = dxDrawText(chosenText, 161, 10, x, y, tocolor(0, 0, 0, 200), 1.5, "default-bold", "center")
    theText = dxDrawText(chosenText, 160, 8, x, y, tocolor(255, 153, 0, alpha), 1.5, "default-bold", "center")
end

-- events
addEventHandler("onClientRender", root, showLetter)
