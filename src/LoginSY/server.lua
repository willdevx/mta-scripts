--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]] -----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "LoginSY"
local resourceDescription = "Sistema de Login"

-- this will make start the system
function startMe()
    if (isGuestAccount(getPlayerAccount(client))) then
        triggerClientEvent(client, "onLoginGuestPlayerRequest", client)
    end
end

-- this will register the account to the player
function registerAccount(theUsername, thePassword)
    if (theUsername ~= "" and theUsername ~= nil and thePassword ~= "" and thePassword ~= nil) then
        registerAccount = addAccount(theUsername, thePassword)
        if (registerAccount) then
            triggerClientEvent(client, "onRegisterSuccessfully", client)
        else
            triggerClientEvent(client, "onRegisterError", client)
        end
    else
        triggerClientEvent(client, "onRegisterEmptyError", client)
    end
end

-- this will login the account to the player
function loginAccount(theUsername, thePassword)
    if (theUsername ~= "" and theUsername ~= nil and thePassword ~= "" and thePassword ~= nil) then
        loginAccount = getAccount(theUsername, thePassword)
        if (loginAccount ~= false) then
            logIn(client, loginAccount, thePassword)
            triggerClientEvent(client, "onLoginSuccessfully", client, theUsername, thePassword)
        else
            triggerClientEvent(client, "onLoginError", client)
        end
    else
        triggerClientEvent(client, "onLoginEmptyError", client)
    end
end

-- events
addEvent("onLoginSysStart", true)
addEventHandler("onLoginSysStart", resourceRoot, startMe)
addEvent("onPlayerRegisterRequest", true)
addEventHandler("onPlayerRegisterRequest", resourceRoot, registerAccount)
addEvent("onPlayerLoginRequest", true)
addEventHandler("onPlayerLoginRequest", resourceRoot, loginAccount)
