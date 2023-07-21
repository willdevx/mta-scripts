--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local theMoney = 0

-- this will open the bank account to me
function playerBankAccountOpen(loadtheMoney, loadmyMoney)
	theMoney = loadtheMoney
	showBankWindow()
end

-- the bank window
thePanel = guiCreateWindow(0.1,0.3,0.4,0.5, "Banco BnF™", true)
tabPanel = guiCreateTabPanel(0, 0.1, 1, 0.76, true, thePanel)
tabHome = guiCreateTab("Início", tabPanel)
tabDep = guiCreateTab("Depositar", tabPanel)
tabSac = guiCreateTab("Sacar", tabPanel)
bankInfo_01 = guiCreateLabel(0.03,0.03,0.94,0.2, "Bem-vindo ao painel do Banco BnF™!", true, tabHome)
bankInfo_02 = guiCreateLabel(0.03,0.08,0.94,0.2, "Aqui você pode guardar o seu dinheiro de maneira segura", true, tabHome)
bankInfo_03 = guiCreateLabel(0.03,0.13,0.94,0.2, "para que jamais perca o que for conquistando pelo server!!!", true, tabHome)
bankInfo_04 = guiCreateLabel(0.03,0.23,0.94,0.2, "- Atenção com o seu dinheiro!", true, tabHome)
bankInfo_05 = guiCreateLabel(0.03,0.28,0.94,0.2, "Não ande nas ruas do server com grandes quantias de dinheiro", true, tabHome)
bankInfo_06 = guiCreateLabel(0.03,0.33,0.94,0.2, "pois você pode ser roubado! Sempre venha guardar seu dinheiro", true, tabHome)
bankInfo_07 = guiCreateLabel(0.03,0.38,0.94,0.2, "na sua conta para evitar esses tipos de situações.", true, tabHome)
bankInfo_08 = guiCreateLabel(0.03,0.58,0.94,0.2, "2017 (c) Banco BnF™ feito com <3 por Namykazesz", true, tabHome)
bankInfo_09 = guiCreateLabel(0.03,0.63,0.94,0.2, "Jamais desistam de seus sonhos! #familiaBnF! Diversão & Amizades.", true, tabHome)
bankDepInfo = guiCreateLabel(0.03,0.03,0.94,0.2, "Insira o valor que deseja depositar:", true, tabDep)
bankDepValue = guiCreateEdit(0.03,0.12,0.94,0.13, "", true, tabDep)
bankDepButton = guiCreateButton(0.77,0.28,0.2,0.13, "Depositar", true, tabDep)
bankDepMessage = guiCreateLabel(0.03,0.50,0.94,0.2, "", true, tabDep)
bankSacInfo = guiCreateLabel(0.03,0.03,0.94,0.2, "Insira o valor que deseja sacar:", true, tabSac)
bankSacValue = guiCreateEdit(0.03,0.12,0.94,0.13, "", true, tabSac)
bankSacButton = guiCreateButton(0.77,0.28,0.2,0.13, "Sacar", true, tabSac)
bankSacMessage = guiCreateLabel(0.03,0.50,0.94,0.2, "", true, tabSac)
theMoneyInfo = guiCreateLabel(0.03,0.88,0.94,0.2, "", true, thePanel)
exitButton = guiCreateButton(0.85, 0.88, 1, 1, "Sair", true, thePanel)
guiWindowSetSizable(thePanel, false)
guiSetVisible(thePanel, false)

-- this will show the bank window
function showBankWindow()
	guiSetText(theMoneyInfo, "Seu saldo: R$"..theMoney..",00")
	guiSetVisible(thePanel, true)
	guiSetText(bankSacMessage, "")
	guiSetText(bankDepMessage, "")
	guiSetSelectedTab(tabPanel,tabHome)
	showCursor(true)
end

-- this will hide the bank window
function hideBankWindow()
	guiSetVisible(thePanel, false)
	showCursor(false)
end

-- this will exit the bank panel
function panelExit()
	if(source==exitButton) then
		theMoney = 0
		hideBankWindow()
	end
end

-- this will give the bank money to me
function sacMoney()
	if(source==bankSacButton) then
		theSacMoney = guiGetText(bankSacValue)
		guiSetText(bankSacValue, "")
		triggerServerEvent("onPlayerSacMoney", resourceRoot, theSacMoney)
	end
end

-- bank sac success
function bankSacSuccess(sacMoney, actualMoney)
	theMoney = actualMoney
	guiSetText(bankSacMessage, "Você sacou R$"..sacMoney..",00.")
	guiSetText(theMoneyInfo, "Seu saldo: R$"..theMoney..",00")
end

-- bank sac ins money error
function sacInsMoneyError()
	guiSetText(bankSacMessage, "Você não tem dinheiro suficiente para sacar isso.")
end

-- impossible to sac
function impossibleToSac()
	guiSetText(bankSacMessage, "Por favor, informe valores maiores que 0.")
end

-- this will increase the bank money to me
function depMoney()
	if(source==bankDepButton) then
		theDepMoney = guiGetText(bankDepValue)
		guiSetText(bankDepValue, "")
		triggerServerEvent("onPlayerDepMoney", resourceRoot, theDepMoney)
	end
end

-- bank dep success
function bankDepSuccess(depMoney, actualMoney)
	theMoney = actualMoney
	guiSetText(bankDepMessage, "Você depositou R$"..depMoney..",00.")
	guiSetText(theMoneyInfo, "Seu saldo: R$"..theMoney..",00")
end

-- bank dep ins money error
function depInsMoneyError()
	guiSetText(bankDepMessage, "Você não tem dinheiro suficiente para depositar isso.")
end

-- impossible to dep
function impossibleToDep()
	guiSetText(bankDepMessage, "Por favor, informe valores maiores que 0.")
end

-- events
addEvent("onPlayerBankAccountOpen", true)
addEventHandler("onPlayerBankAccountOpen", localPlayer, playerBankAccountOpen)
addEventHandler("onClientGUIClick", exitButton, panelExit)
addEventHandler("onClientGUIClick", bankSacButton, sacMoney)
addEvent("onPlayerBankSacInsMoneyError", true)
addEventHandler("onPlayerBankSacInsMoneyError", localPlayer, sacInsMoneyError)
addEvent("onPlayerBankSac", true)
addEventHandler("onPlayerBankSac", localPlayer, bankSacSuccess)
addEvent("onPlayerBankSacImpossible", true)
addEventHandler("onPlayerBankSacImpossible", localPlayer, impossibleToSac)
addEventHandler("onClientGUIClick", bankDepButton, depMoney)
addEvent("onPlayerBankDep", true)
addEventHandler("onPlayerBankDep", localPlayer, bankDepSuccess)
addEvent("onPlayerBankDepImpossible", true)
addEventHandler("onPlayerBankDepImpossible", localPlayer, impossibleToDep)
addEvent("onPlayerBankDepInsMoneyError", true)
addEventHandler("onPlayerBankDepInsMoneyError", localPlayer, depInsMoneyError)