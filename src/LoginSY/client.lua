--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]] -----------------------------------------

-- initial properties
local playerMe = getLocalPlayer()
local playingGuest = false
local cameraPosition = 0
local px, py = guiGetScreenSize()
local recOpacityDir = true
local recOpacity = 0
local panelMessage = ""
local camMaActived = true

-- this will make start the system
function startMe()
    if (playingGuest == false) then
        triggerServerEvent("onLoginSysStart", resourceRoot)
    end
end

-- this will make start the login system to me
function startLoginSystem()
    showChat(false)
    setPlayerHudComponentVisible("radar", false)
    showCursor(true)
    addEventHandler("onClientPreRender", root, positCamera)
    x, y, z = getCameraMatrix(playerMe)
    cameraTimer = setTimer(function()
        if (camMaActived == true) then
            setCameraMatrix(413.2951965332 - cameraPosition, -1705.04296875, 100.24449920654, 414.2575378418,
                -1755.1619873047, 100.0001220703)
        end
    end, 50, 0)
    addEventHandler("onClientRender", root, drawPanelRec)
    showLoginForm()
end

-- this will make the camera will to the marked positions
function positCamera()
    cameraPosition = cameraPosition + 0.10
    if (recOpacity == 0) then
        recOpacityDir = true
    end
    if (recOpacity == 255) then
        recOpacityDir = false
    end
    if (recOpacityDir == true) then
        recOpacity = recOpacity + 1
    else
        recOpacity = recOpacity - 1
    end
end

-- this will draw the login panel rectangle
function drawPanelRec()
    dxDrawRectangle(0, py / 3.8, px, py / 1.9, tocolor(0, 0, 0, recOpacity))
    dxDrawText("Bem-vindo(a) ao Brasileiros na Fixa", 2, py - py / 1.2 + 2, px, 0, tocolor(0, 0, 0, recOpacity), 2,
        "diploma", "center")
    dxDrawText("Bem-vindo(a) ao Brasileiros na Fixa", 0, py - py / 1.2, px, 0, tocolor(255, 153, 0, 255), 2, "diploma",
        "center")
    dxDrawText("2018 (c) Brasileiros na Fixa v2.0 por #Namy, Thuu[G], & +Duffzin. Todos os direitos reservados.", 0,
        py - py / 3.8 + 10, px, 0, tocolor(255, 255, 255, 155), 1, "default", "center")
    dxDrawText(panelMessage, 4, py - py / 3.8 + 62, px, 0, tocolor(0, 0, 0, recOpacity), 1, "pricedown", "center")
    dxDrawText(panelMessage, 0, py - py / 3.8 + 60, px, 0, tocolor(255, 255, 255, 255), 1, "pricedown", "center")
end

-- this will make stop the system
function stopMe(res)
    local st = true
    if (res) then
        if (getThisResource() ~= res) then
            st = false
        end
    end
    if (st == true) then
        showChat(true)
        setPlayerHudComponentVisible("radar", true)
        showCursor(false)
        camMaActived = false
        if (cameraTimer ~= nil and cameraTimer ~= false) then
            killTimer(cameraTimer)
        end
        setCameraTarget(playerMe)
        removeEventHandler("onClientPreRender", root, positCamera)
        removeEventHandler("onClientRender", root, drawPanelRec)
        hideLoginForm()
    end
end

-- Login Form
loadUsername = fileOpen("remember/username.txt", true)
loadPassword = fileOpen("remember/password.txt", true)
if (loadUsername and loadPassword) then
    usernameRemembered = fileRead(loadUsername, 256)
    passwordRemembered = fileRead(loadPassword, 256)
    fileClose(loadUsername)
    fileClose(loadPassword)
    keepRemembered = true
else
    usernameRemembered = ""
    passwordRemembered = ""
    keepRemembered = false
end
inputUsernameLabel = guiCreateLabel(px / 1.9 - 100, py / 3.8 + 25, px / 1.9, 50, "Nome de Usuário (login):", false)
inputUsername = guiCreateEdit(px / 3.8 - 20, py / 3.8 + 50, px / 1.9, 50, usernameRemembered, false)
inputPasswordLabel = guiCreateLabel(px / 1.9 - 58, py / 3.8 + 112, px / 1.9, 50, "Senha:", false)
inputPassword = guiCreateEdit(px / 3.8 - 20, py / 3.8 + 138, px / 1.9, 50, passwordRemembered, false)
inputRemember = guiCreateCheckBox(px / 3.8 - 10, py / 3.8 + 188, px / 1.9, 50, "Lembrar Nome de Usuário e Senha",
    keepRemembered, false)
inputLogin = guiCreateButton(px / 3.8 - 20, py / 3.8 + 250, px / 1.9, 50, "Entrar", false)
inputCreateAccount = guiCreateButton(px / 3.8 - 20, py / 3.8 + 305, px / 3.8, 50, "Criar minha conta", false)
inputPlayAsGuest = guiCreateButton(px / 1.9 - 20, py / 3.8 + 305, px / 3.8, 50, "Jogar como visitante", false)
guiEditSetMasked(inputPassword, true)
guiSetVisible(inputUsernameLabel, false)
guiSetVisible(inputUsername, false)
guiSetVisible(inputPasswordLabel, false)
guiSetVisible(inputPassword, false)
guiSetVisible(inputRemember, false)
guiSetVisible(inputLogin, false)
guiSetVisible(inputCreateAccount, false)
guiSetVisible(inputPlayAsGuest, false)

-- this will show the login form
function showLoginForm()
    guiSetVisible(inputUsernameLabel, true)
    guiSetVisible(inputUsername, true)
    guiSetVisible(inputPasswordLabel, true)
    guiSetVisible(inputPassword, true)
    guiSetVisible(inputRemember, true)
    guiSetVisible(inputLogin, true)
    guiSetVisible(inputCreateAccount, true)
    guiSetVisible(inputPlayAsGuest, true)
end

-- this will hide the login form
function hideLoginForm()
    guiSetVisible(inputUsernameLabel, false)
    guiSetVisible(inputUsername, false)
    guiSetVisible(inputPasswordLabel, false)
    guiSetVisible(inputPassword, false)
    guiSetVisible(inputRemember, false)
    guiSetVisible(inputLogin, false)
    guiSetVisible(inputCreateAccount, false)
    guiSetVisible(inputPlayAsGuest, false)
end

-- Register Form
inputNewUsernameLabel = guiCreateLabel(px / 1.9 - 110, py / 3.8 + 25, px / 1.9, 50, "Crie um Nome de Usuário (login):",
    false)
inputNewUsername = guiCreateEdit(px / 3.8 - 20, py / 3.8 + 50, px / 1.9, 50, "", false)
inputNewPasswordLabel = guiCreateLabel(px / 1.9 - 68, py / 3.8 + 112, px / 1.9, 50, "Crie uma Senha:", false)
inputNewPassword = guiCreateEdit(px / 3.8 - 20, py / 3.8 + 138, px / 1.9, 50, "", false)
inputRegister = guiCreateButton(px / 3.8 - 20, py / 3.8 + 250, px / 1.9, 50, "Registrar", false)
inputBack = guiCreateButton(px / 3.8 - 20, py / 3.8 + 305, px / 1.9, 50, "Voltar", false)
guiEditSetMasked(inputNewPassword, true)
guiSetVisible(inputNewUsernameLabel, false)
guiSetVisible(inputNewUsername, false)
guiSetVisible(inputNewPasswordLabel, false)
guiSetVisible(inputNewPassword, false)
guiSetVisible(inputRegister, false)
guiSetVisible(inputBack, false)

-- this will show the register form
function showRegisterForm()
    guiSetVisible(inputNewUsernameLabel, true)
    guiSetVisible(inputNewUsername, true)
    guiSetVisible(inputNewPasswordLabel, true)
    guiSetVisible(inputNewPassword, true)
    guiSetVisible(inputRegister, true)
    guiSetVisible(inputBack, true)
end

-- this will hide the register form
function hideRegisterForm()
    guiSetVisible(inputNewUsernameLabel, false)
    guiSetVisible(inputNewUsername, false)
    guiSetVisible(inputNewPasswordLabel, false)
    guiSetVisible(inputNewPassword, false)
    guiSetVisible(inputRegister, false)
    guiSetVisible(inputBack, false)
end

-- this will make the player play as guest
function playAsGuest()
    if (source == inputPlayAsGuest) then
        playingGuest = true
        stopMe()
        outputChatBox("* Você está jogando como visitante.", 125, 125, 125)
        outputChatBox(
            "Não será possível comprar/salvar atributos adquiridos no server. Digite /reconnect caso deseje logar em uma conta para isso.",
            175, 175, 175)
    end
end

-- this will open the register panel
function openRegisterPanel()
    if (source == inputCreateAccount) then
        hideLoginForm()
        showRegisterForm()
        panelMessage = ""
    end
end

-- this will back the login panel
function backLoginPanel()
    if (source == inputBack) then
        hideRegisterForm()
        showLoginForm()
        panelMessage = ""
    end
end

-- this will register the account
function registerAccount()
    if (source == inputRegister) then
        registerUsername = guiGetText(inputNewUsername)
        registerPassword = guiGetText(inputNewPassword)
        triggerServerEvent("onPlayerRegisterRequest", resourceRoot, registerUsername, registerPassword)
    end
end

-- this will alert register empty error
function registerEmptyError()
    panelMessage = "por favor, preencha todos os campos para registrar sua conta."
end

-- this will alert register error
function registerError()
    panelMessage = "não foi possível registrar. tente registrar com outras informações."
end

-- this will alert register successfully
function registerSuccessfully()
    panelMessage = "conta criada com sucesso! volte para logar."
    guiSetText(inputNewUsername, "")
    guiSetText(inputNewPassword, "")
end

-- this will login the account
function loginAccount()
    if (source == inputLogin) then
        loginUsername = guiGetText(inputUsername)
        loginPassword = guiGetText(inputPassword)
        triggerServerEvent("onPlayerLoginRequest", resourceRoot, loginUsername, loginPassword)
    end
end

-- this will alert login empty error
function loginEmptyError()
    panelMessage = "por favor, preencha todos os campos para entrar na sua conta."
end

-- this will alert login error
function loginError()
    panelMessage = "o nome de usuário ou senha está(ão) incorreto(s)."
end

-- this will make the player play as logged
function loginSuccessfully(theUsername, thePassword)
    if (guiCheckBoxGetSelected(inputRemember) == true) then
        remember_username = fileCreate("remember/username.txt")
        remember_password = fileCreate("remember/password.txt")
        if (remember_username and remember_password) then
            fileWrite(remember_username, theUsername)
            fileWrite(remember_password, thePassword)
            fileClose(remember_username)
            fileClose(remember_password)
        end
    else
        fileDelete("remember/username.txt")
        fileDelete("remember/password.txt")
    end
    stopMe()
    outputChatBox("Bem-vindo de volta ao Brasileiros na Fixa! <3", 0, 255, 0)
end

-- events
addEventHandler("onClientResourceStart", getRootElement(), startMe)
addEventHandler("onClientResourceStop", getRootElement(), stopMe)
addEvent("onLoginGuestPlayerRequest", true)
addEventHandler("onLoginGuestPlayerRequest", localPlayer, startLoginSystem)
addEventHandler("onClientGUIClick", inputPlayAsGuest, playAsGuest)
addEventHandler("onClientGUIClick", inputCreateAccount, openRegisterPanel)
addEventHandler("onClientGUIClick", inputBack, backLoginPanel)
addEventHandler("onClientGUIClick", inputRegister, registerAccount)
addEvent("onRegisterEmptyError", true)
addEventHandler("onRegisterEmptyError", localPlayer, registerEmptyError)
addEvent("onRegisterError", true)
addEventHandler("onRegisterError", localPlayer, registerError)
addEvent("onRegisterSuccessfully", true)
addEventHandler("onRegisterSuccessfully", localPlayer, registerSuccessfully)
addEventHandler("onClientGUIClick", inputLogin, loginAccount)
addEvent("onLoginEmptyError", true)
addEventHandler("onLoginEmptyError", localPlayer, loginEmptyError)
addEvent("onLoginError", true)
addEventHandler("onLoginError", localPlayer, loginError)
addEvent("onLoginSuccessfully", true)
addEventHandler("onLoginSuccessfully", localPlayer, loginSuccessfully)
