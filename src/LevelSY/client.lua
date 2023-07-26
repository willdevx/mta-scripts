--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017-2018 BnF Server. All rights reserved.
--]] -----------------------------------------

-- initial properties
local connectedAccount = false
local screenx, screeny = guiGetScreenSize()
local notListeningNowPhrase = "#FamiliaBnF diversão & amizades! Não somos os melhores mas fazemos a diferença!"
local myLevel = nil
local myExperience = nil
local myExperiencePercent = nil
local inAfkStatus = false
local whiteFade = 0
local blackFade = 0
local fadeTime = 0
local fade = 155

-- this will to connect the level system
function connectLevelSystem(theLevel, theExperience)
    myLevel = theLevel
    myExperience = theExperience
    connectedAccount = true
end

-- this will count the level experience
function countLevelExperience()
    if (connectedAccount == true) then
        if (inAfkStatus == false) then
            myExperience = myExperience + 24
            if (tonumber(string.match(myExperience * 100 / 86400, "%d+")) < 100) then
                myExperiencePercent = string.match(myExperience * 100 / 86400, "%d+") .. "%"
            else
                myExperiencePercent = "100%"
            end
            if (myExperience > 86400) then
                myExperience = 0
                myLevel = myLevel + 1
                addEventHandler("onClientRender", root, drawLevelUp)
            end
        else
            myExperiencePercent = "Você não está upando!"
        end
    end
end

-- this will save the level experience
function saveLevelExperience()
    if (connectedAccount == true) then
        triggerServerEvent("onSaveLevelExperienceRequest", resourceRoot, myLevel, myExperience)
    end
end

-- this will add the afk status
function addAfkStatus()
    if (connectedAccount == true) then
        if (inAfkStatus ~= true) then
            inAfkStatus = true
            addEventHandler("onClientRender", root, drawAfk)
        end
    end
end

-- this will remove the afk status
function removeAfkStatus()
    if (connectedAccount == true) then
        if (inAfkStatus ~= false) then
            inAfkStatus = false
            removeEventHandler("onClientRender", root, drawAfk)
        end
    end
end

-- this will toggle the afk status
function toggleAfkStatus()
    if (connectedAccount == true) then
        if (inAfkStatus == true) then
            removeAfkStatus()
            x, y, z = getElementPosition(getLocalPlayer())
            setElementPosition(getLocalPlayer(), x + 0.02, y, z)
            outputChatBox("* (/afk) Você voltou a upar!", 0, 255, 0)
        else
            outputChatBox("* Você não está AFK! (Está upando normalmente).")
        end
    end
end

-- draw level system bar
function drawLevelSystem()
    if (connectedAccount == true and myLevel ~= nil and myExperience ~= nil and myExperiencePercent ~= nil) then
        if (fade == 155) then
            fade_status = "in"
        end
        if (fade == 255) then
            fade_status = "out"
        end
        if (fade_status == "in") then
            fade = fade + 1
        end
        if (fade_status == "out") then
            fade = fade - 1
        end
        theListeningNow = getElementData(getLocalPlayer(), "listeningNow")
        if (theListeningNow ~= false) then
            theListeningNowText = " • " .. theListeningNow
        else
            theListeningNowText = " • " .. notListeningNowPhrase
        end
        dxDrawRectangle(30, screeny - 30, screenx, screeny / 20, tocolor(0, 0, 0, fade))
        dxDrawImage(0, screeny - 52, 62, 62, 'img/logo.png')
        dxDrawText("Nível: " .. myLevel .. " (" .. myExperiencePercent .. ")" .. theListeningNowText, 74,
            screeny - 21.05, screenx, screeny, tocolor(0, 0, 0, 200), 1, "default-bold")
        dxDrawText("Nível: " .. myLevel .. " (" .. myExperiencePercent .. ")" .. theListeningNowText, 75,
            screeny - 22.05, screenx, screeny, tocolor(255, fade, 255, 255), 1, "default-bold")
    end
end

-- draw afk status
function drawAfk()
    dxDrawText("VOCÊ PAROU DE UPAR!", 2, screeny / 3.8 + 140, screenx, 100, tocolor(0, 0, 0, fade), 3, "default-bold",
        "center")
    dxDrawText("Por favor, digite /afk para voltar a upar.", 2, screeny / 3.8 + 180, screenx, 100,
        tocolor(0, 0, 0, fade), 2, "default-bold", "center")
    dxDrawText("VOCÊ PAROU DE UPAR!", 0, screeny / 3.8 + 138, screenx, 100, tocolor(255, 255, 255, 255), 3,
        "default-bold", "center")
    dxDrawText("Por favor, digite /afk para voltar a upar.", 0, screeny / 3.8 + 178, screenx, 100,
        tocolor(255, 255, 255, 255), 2, "default-bold", "center")
end

-- draw level up status
function drawLevelUp()
    fadeTime = fadeTime + 1
    if (fadeTime < 250) then
        if (whiteFade < 251) then
            whiteFade = whiteFade + 4
        end
        if (blackFade < 245) then
            blackFade = blackFade + 10
        end
    else
        if (whiteFade > 10) then
            whiteFade = whiteFade - 10
        end
        if (blackFade > 4) then
            blackFade = blackFade - 4
        end
    end
    if (whiteFade == 2 and blackFade == 2) then
        removeEventHandler("onClientRender", root, drawLevelUp)
        whiteFade = 0
        blackFade = 0
        fadeTime = 0
    end
    dxDrawText("Level Up!", -1, screeny / 2 - 99, screenx, screeny, tocolor(0, 0, 0, blackFade), 2.5, "pricedown",
        "center")
    dxDrawText("Level Up!", 0, screeny / 2 - 100, screenx, screeny, tocolor(255, 255, 255, whiteFade), 2.5, "pricedown",
        "center")
    dxDrawText("Você agora é nível " .. myLevel .. "!", -1, screeny / 2 - 19, screenx, screeny,
        tocolor(0, 0, 0, blackFade), 1.2, "default-bold", "center")
    dxDrawText("Você agora é nível " .. myLevel .. "!", 0, screeny / 2 - 20, screenx, screeny,
        tocolor(255, 255, 255, whiteFade), 1.2, "default-bold", "center")
end

-- events & command
addEventHandler("onClientRender", root, drawLevelSystem)
addEvent("onConnectLevelSystemRequest", true)
addEventHandler("onConnectLevelSystemRequest", localPlayer, connectLevelSystem)
addEvent("onLevelSystemAfkStatus", true)
addEventHandler("onLevelSystemAfkStatus", localPlayer, addAfkStatus)
setTimer(countLevelExperience, 1000, 0)
setTimer(saveLevelExperience, 10000, 0)
addCommandHandler("afk", toggleAfkStatus)
