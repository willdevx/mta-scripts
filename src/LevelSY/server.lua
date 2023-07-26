--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017-2018 BnF Server. All rights reserved.
--]] -----------------------------------------

-- initial properties
local resourceCreationDate = "2017-2018"
local resourceOfficialName = "LevelSY"
local resourceDescription = "Sistema de Níveis"

-- scoreboard
exports["scoreboard"]:scoreboardAddColumn("getLevel", getRootElement(), 50, "Nível")

-- this will connect the player
function connectPlayer()
    if not (isGuestAccount(getPlayerAccount(source))) then
        theLevel = getAccountData(getPlayerAccount(source), "playerlevel")
        theExperience = getAccountData(getPlayerAccount(source), "playerexperience")
        if (theLevel == false) then
            theLevel = "0"
        end
        if (theExperience == false) then
            theExperience = "0"
        end
        triggerClientEvent(source, "onConnectLevelSystemRequest", source, theLevel, theExperience)
        setElementData(source, "getLevel", theLevel)
    end
end

-- this will connect all the players when the resource start
function connectAllPlayers()
    for _, player in ipairs(getElementsByType("player")) do
        if not (isGuestAccount(getPlayerAccount(player))) then
            theLevel = getAccountData(getPlayerAccount(player), "playerlevel")
            theExperience = getAccountData(getPlayerAccount(player), "playerexperience")
            if (theLevel == false) then
                theLevel = "0"
            end
            if (theExperience == false) then
                theExperience = "0"
            end
            triggerClientEvent(player, "onConnectLevelSystemRequest", player, theLevel, theExperience)
            setElementData(player, "getLevel", theLevel)
        end
    end
end

-- this will save the level experience
function saveLevelExperience(theLevel, theExperience)
    setAccountData(getPlayerAccount(client), "playerlevel", theLevel)
    setAccountData(getPlayerAccount(client), "playerexperience", theExperience)
    setElementData(client, "getLevel", theLevel)
end

-- this will verify the afk players
function verifyAfkPlayers()
    for _, player in ipairs(getElementsByType("player")) do
        if not (isGuestAccount(getPlayerAccount(player))) then
            if (getPlayerIdleTime(player) > 120000) then
                triggerClientEvent(player, "onLevelSystemAfkStatus", player)
            end
        end
    end
end

-- events
addEventHandler("onPlayerLogin", root, connectPlayer)
addEvent("onSaveLevelExperienceRequest", true)
addEventHandler("onSaveLevelExperienceRequest", resourceRoot, saveLevelExperience)
setTimer(connectAllPlayers, 1000, 1)
setTimer(verifyAfkPlayers, 10000, 0)
