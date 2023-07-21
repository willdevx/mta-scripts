--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "HouseSY"
local resourceDescription = "Sistema de Casas"
local houseRendered = "false"

-- connection with database
function connectDb()
    connection = dbConnect("sqlite", "houses.db")
    if(connection) then
        createTable = dbQuery(connection, "CREATE TABLE IF NOT EXISTS 'houses'('interior' TEXT, 'hx' TEXT, 'hy' TEXT, 'hz' TEXT, 'mx' TEXT, 'my' TEXT, 'mz' TEXT, 'price' INT, 'owner' TEXT, 'password' TEXT, 'id' INT)")
		dbPoll(createTable, -1)
        if(houseRendered=="false") then
            spawnHouseSql = dbQuery(connection, "SELECT * FROM houses ORDER BY id")
            spawnHouseLin = dbPoll(spawnHouseSql,-1)
            for _, rowSpawnHouse in ipairs(spawnHouseLin) do
                spawnHouseMarker = createMarker(rowSpawnHouse['mx'],rowSpawnHouse['my'],rowSpawnHouse['mz']-1,"cylinder",1.2,0,255,0,10)
                setElementID(spawnHouseMarker, rowSpawnHouse['id'])
				freeHouse = createObject(1273, rowSpawnHouse['mx'], rowSpawnHouse['my'], rowSpawnHouse['mz'], 0, 0, 0, true)
				setObjectScale(freeHouse, 2)
				setElementID(freeHouse, "icon_"..rowSpawnHouse['id'])
                if(rowSpawnHouse['owner']~="") then
                    setMarkerColor(spawnHouseMarker,0,0,255,10)
					destroyElement(freeHouse)
					buyHouse = createObject(1272, rowSpawnHouse['mx'], rowSpawnHouse['my'], rowSpawnHouse['mz'], 0, 0, 0, true)
					setObjectScale(buyHouse, 2)
					setElementID(buyHouse, "icon_"..rowSpawnHouse['id'])
                end
                if(isElement(spawnHouseMarker)) then
                    houseRendered = "true"
                end
            end
        end
    end
end

-- connectDb event
connectDb()

-- build a house
function buildHouse(theClient, theCommand, theHouse)
	if(hasObjectPermissionTo(theClient, "function.kickPlayer")) then
		if(theHouse=="1" or theHouse=="2" or theHouse=="3" or theHouse=="4" or theHouse=="5" or theHouse=="6" or theHouse=="7") then
			houseIDSql = dbQuery(connection, "SELECT * FROM houses ORDER BY id DESC LIMIT 1")
			houseIDLin = dbPoll(houseIDSql,-1)
			houseID = 0
			for _, rowHouseID in ipairs(houseIDLin) do
				houseID = rowHouseID['id']
			end
			houseID = houseID+1
			if(theHouse=="1") then
				hInterior = "6"
				hPrice = "200000"
				hx = "-69.049"
				hy = "1354.056"
				hz = "1080.211"
			end
			if(theHouse=="2") then
				hInterior = "11"
				hPrice = "250000"
				hx = "2282.888671875"
				hy = "-1139.572265625"
				hz = "1050.8984375"
			end
			if(theHouse=="3") then
				hInterior = "15"
				hPrice = "325000"
				hx = "-284.7763671875"
				hy = "1470.974609375"
				hz = "1084.375"
			end
			if(theHouse=="4") then
				hInterior = "8"
				hPrice = "575000"
				hx = "2365.232421875"
				hy = "-1132.3212890625"
				hz = "1050.875"
			end
			if(theHouse=="5") then
				hInterior = "10"
				hPrice = "725000"
				hx = "2268.888671875"
				hy = "-1210.42578125"
				hz = "1047.5625"
			end
			if(theHouse=="6") then
				hInterior = "1"
				hPrice = "1350000"
				hx = "2216.533203125"
				hy = "-1076.283203125"
				hz = "1050.484375"
			end
			if(theHouse=="7") then
				hInterior = "5"
				hPrice = "2000000"
				hx = "140.205078125"
				hy = "1367.8310546875"
				hz = "1083.8620605469"
			end
			mx,my,mz = getElementPosition(theClient)
			buildQuery = dbQuery(connection, "INSERT INTO houses VALUES(?,?,?,?,?,?,?,?,?,?,?)", hInterior, hx, hy, hz, mx, my, mz, hPrice, "", "", houseID)
			dbPoll(buildQuery, -1)
			houseMarker = createMarker(mx,my,mz-1,"cylinder",1.2,0,255,0,10)
			setElementID(houseMarker, houseID)
			createdHouse = createObject(1273, mx, my, mz, 0, 0, 0, true)
			setObjectScale(createdHouse, 2)
			setElementID(createdHouse, "icon_"..houseID)
		else
			theClient:outputChat("ID da Casa inválido. Por favor, crie uma casa que tenha o ID entre 1 e 7.",255,0,0)
		end
	else
		theClient:outputChat("Você não tem permissão para fazer isso!",255,0,0)
	end
end

-- buildHouse command
addCommandHandler("criarcasa", buildHouse)

-- detect a house
function detectHouse(theClient)
	if(getElementType(theClient)=="player") then
		houseDetectedID = getElementID(source)
		detectHouseSql = dbQuery(connection, "SELECT * FROM houses WHERE id='"..houseDetectedID.."' LIMIT 1")
		detectHouseLin = dbPoll(detectHouseSql,-1)
		for _, rowDetectHouse in ipairs(detectHouseLin) do
			if(rowDetectHouse['id']~=0) then
				if(rowDetectHouse['owner']=="") then
				detectHouseStatus = "À venda"
				detectHouseOwner = "Ninguém"
				detectHouseMessage = "* Para comprar esta casa, digite /comprar + senha_da_casa (ex: /comprar 1234)."
				else
				detectHouseStatus = "Comprada"
				detectHouseOwner = rowDetectHouse['owner']
				detectHouseMessage = "* Para entrar nesta casa, digite /entrar + senha_da_casa (ex: /entrar 1234)."
				end
				theClient:outputChat("================= Casa BnF™ =================",255,255,0)
				theClient:outputChat("Status: "..detectHouseStatus,255,255,0)
				theClient:outputChat("Preço: R$"..rowDetectHouse['price'],255,255,0)
				theClient:outputChat("ID: "..rowDetectHouse['id'],255,255,0)
				theClient:outputChat("Dono(a): "..detectHouseOwner,255,255,0)
				theClient:outputChat(detectHouseMessage,255,255,0)
				theClient:outputChat("============================================",255,255,0)
				triggerClientEvent("detectHouse", theClient, rowDetectHouse['id'])
			end
		end
	end
end

-- detectHouse event
addEventHandler("onMarkerHit", getRootElement(), detectHouse)

-- leave a detected house
function leaveDetectedHouse(theClient)
	triggerClientEvent("leaveDetectHouse", theClient, "0")
end

-- leaveDetectedHouse event
addEventHandler("onMarkerLeave", getRootElement(), leaveDetectedHouse)

-- buy a house
function buyHouse(theHouse, thePassword)
	clientAccount = getPlayerAccount(client)
	clientName = getAccountName(clientAccount)
	if(isGuestAccount(clientAccount)) then
		client:outputChat("Por favor, entre em uma conta para poder comprar esta casa.",255,0,0)
	else
		buyVerifySql = dbQuery(connection, "SELECT * FROM houses WHERE owner='"..clientName.."'")
		buyVerifyLin = dbPoll(buyVerifySql,-1)
		buyStatus = "1"
		for _, rowBuyVerify in ipairs(buyVerifyLin) do
			if(rowBuyVerify['id']~=0) then
				buyStatus = "0"
			end
		end
		if(buyStatus=="1") then
			buyHouseSql = dbQuery(connection, "SELECT * FROM houses WHERE id='"..theHouse.."' AND owner=''")
			buyHouseLin = dbPoll(buyHouseSql,-1)
			for _, rowBuyHouse in ipairs(buyHouseLin) do
				buyHouseEx = dbExec(connection, "UPDATE houses SET owner=?, password=? WHERE id=?", clientName, thePassword, rowBuyHouse['id'])
				takePlayerMoney(client, rowBuyHouse['price'])
				purchaseHouseMarker = getElementByID(rowBuyHouse['id'])
				setMarkerColor(purchaseHouseMarker,0,0,255,10)
				purchaseHouseIcon = getElementByID("icon_"..rowBuyHouse['id'])
				destroyElement(purchaseHouseIcon)
				purchaseHouseIcon = createObject(1272, rowBuyHouse['mx'], rowBuyHouse['my'], rowBuyHouse['mz'], 0, 0, 0, true)
				setObjectScale(purchaseHouseIcon, 2)
				setElementID(purchaseHouseIcon, "icon_"..rowBuyHouse['id'])
				client:outputChat("Você comprou a casa ID "..rowBuyHouse['id'].." por $"..rowBuyHouse['price'].."!",0,255,0)
				client:outputChat("Para entrar na casa, digite [/entrar "..thePassword.."]. Obs: NUNCA esqueça a sua senha.")
			end
		else
			client:outputChat("Você já tem uma casa. Para poder comprar esta, é necessário reembolsar a sua casa atual. Digite /minhacasa para mais informações.",255,0,0)
		end
	end
end

-- buyHouse event
addEvent("buyHouse", true)
addEventHandler("buyHouse", resourceRoot, buyHouse)

-- enter a house
function enterHouse(theHouse, thePassword)
	enterHouseSql = dbQuery(connection, "SELECT * FROM houses WHERE id='"..theHouse.."' AND owner!='' AND password='"..thePassword.."'")
	enterHouseLin = dbPoll(enterHouseSql,-1)
	for _, rowEnterHouse in ipairs(enterHouseLin) do
		if(rowEnterHouse['id']~=0) then
			triggerClientEvent("enteredHouse",client,rowEnterHouse['id'])
			enter_x = rowEnterHouse['hx']
			enter_y = rowEnterHouse['hy']
			enter_z = rowEnterHouse['hz']
			client:setPosition(enter_x,enter_y,enter_z+1)
			client:setDimension(rowEnterHouse['id'])
			client:setInterior(rowEnterHouse['interior'])
			client:outputChat("Bem-vindo(a) à casa de "..rowEnterHouse['owner']..". Para sair, digite /sair.",0,255,0)
			client:outputChat("Casa BnF™ - Digite /minhacasa para informações.")
		end
	end
end

-- enterHouse event
addEvent("enterHouse", true)
addEventHandler("enterHouse", resourceRoot, enterHouse)

-- exit a house
function exitHouse(theHouse)
	exitHouseSql = dbQuery(connection, "SELECT * FROM houses WHERE id='"..theHouse.."'")
	exitHouseLin = dbPoll(exitHouseSql,-1)
	for _, rowExitHouse in ipairs(exitHouseLin) do
		if(rowExitHouse['id']~=0) then
			exit_x = rowExitHouse['mx']
			exit_y = rowExitHouse['my']
			exit_z = rowExitHouse['mz']
			client:setPosition(exit_x,exit_y,exit_z+1)
			client:setDimension("0")
			client:setInterior("0")
			client:outputChat("Você saiu da casa.",0,255,0)
		end
	end
end

-- exitHouse event
addEvent("exitHouse", true)
addEventHandler("exitHouse", resourceRoot, exitHouse)

-- change a house password
function chpassHouse(theClient, theCommand, thePassword)
	if(thePassword) then
		changeAccount = getPlayerAccount(theClient)
		changeName = getAccountName(changeAccount)
		changeHouseSql = dbQuery(connection, "SELECT * FROM houses WHERE owner='"..changeName.."'")
		changeHouseLin = dbPoll(changeHouseSql,-1)
		for _, rowchPassHouse in ipairs(changeHouseLin) do
			if(rowchPassHouse['id']~=0) then
				changeHouseEx = dbExec(connection, "UPDATE houses SET password=? WHERE id=?", thePassword, rowchPassHouse['id'])
				theClient:outputChat("Você alterou a senha de sua casa para '"..thePassword.."'.",0,255,0)
			end
		end
	else
		theClient:outputChat("Por favor, informe a nova senha para a sua casa.",255,0,0)
	end
end

-- chpassHouse command
addCommandHandler("mudarsenha", chpassHouse)

-- sell a house
function sellHouse(theClient)
	sellAccount = getPlayerAccount(theClient)
	sellName = getAccountName(sellAccount)
	sellHouseSql = dbQuery(connection, "SELECT * FROM houses WHERE owner='"..sellName.."'")
	sellHouseLin = dbPoll(sellHouseSql,-1)
	for _, rowSellHouse in ipairs(sellHouseLin) do
		if(rowSellHouse['id']~=0) then
			givePlayerMoney(theClient, 100000)
			refundedHouseMarker = getElementByID(rowSellHouse['id'])
			setMarkerColor(refundedHouseMarker,0,255,0,10)
			sellHouseIcon = getElementByID("icon_"..rowSellHouse['id'])
			destroyElement(sellHouseIcon)
			sellHouseIcon = createObject(1273, rowSellHouse['mx'], rowSellHouse['my'], rowSellHouse['mz'], 0, 0, 0, true)
			setObjectScale(sellHouseIcon, 2)
			setElementID(sellHouseIcon, "icon_"..rowSellHouse['id'])
			sellHouseEx = dbExec(connection, "UPDATE houses SET owner='', password='' WHERE id=?", rowSellHouse['id'])
			theClient:outputChat("Você reembolsou a casa ID "..rowSellHouse['id'].." por $100000.",0,255,0)
		end
	end
end

-- sellHouse command
addCommandHandler("reembolsarcasa", sellHouse)

-- go a house
function goHouse(theClient)
	goAccount = getPlayerAccount(theClient)
	goName = getAccountName(goAccount)
	goHouseSql = dbQuery(connection, "SELECT * FROM houses WHERE owner='"..goName.."'")
	goHouseLin = dbPoll(goHouseSql,-1)
	for _, rowGoHouse in ipairs(goHouseLin) do
		if(rowGoHouse['id']~=0) then
			go_x = rowGoHouse['mx']
			go_y = rowGoHouse['my']
			go_z = rowGoHouse['mz']
			theClient:setPosition(go_x,go_y,go_z+1)
			theClient:setDimension("0")
			theClient:setInterior("0")
			outputChatBox("#FFFF00Casa BnF™ - #FFFFFF O jogador "..getPlayerName(theClient).." #FFFFFFfoi para a sua casa.",getRootElement(),255,255,255,true)
		end
	end
end

-- goHouse command
addCommandHandler("casa", goHouse)

-- system informations
function infoHouse(theClient)
	theClient:outputChat("========= Minha Casa BnF™ Informaçõees =========",255,255,0)
	theClient:outputChat("- Comandos",255,255,0)
	theClient:outputChat("/casa - te teletransporta até a sua casa.",255,255,0)
	theClient:outputChat("/reembolsarcasa - reembolsa a sua casa por $100.000.",255,255,0)
	theClient:outputChat("/mudarsenha [senha] (ex: /mudarsenha 5678) - altera a senha de sua casa.",255,255,0)
	theClient:outputChat("[Q] - exibe/oculta as casas à venda no mapa.",255,255,0)
	theClient:outputChat(" ",255,255,0)
	theClient:outputChat("2017 (c) Casas BnF™ feita com <3 por Namykazesz",255,255,0)
	theClient:outputChat("============================================",255,255,0)
end

-- command infoHouse
addCommandHandler("minhacasa", infoHouse)

-- destroy a house
function destroyHouse(theClient, theCommand, theHouse)
	if(hasObjectPermissionTo(theClient, "function.kickPlayer")) then
		destroyHouseSql = dbQuery(connection, "SELECT * FROM houses WHERE id='"..theHouse.."'")
		destroyHouseLin = dbPoll(destroyHouseSql,-1)
		for _, rowDestroyHouse in ipairs(destroyHouseLin) do
			if(rowDestroyHouse['id']~=0) then
				destroyHouseEx = dbExec(connection, "DELETE FROM houses WHERE id=?", rowDestroyHouse['id'])
				destroyHouseMarker = getElementByID(rowDestroyHouse['id'])
				destroyElement(destroyHouseMarker)
				destroyHouseIcon = getElementByID("icon_"..rowDestroyHouse['id'])
				destroyElement(destroyHouseIcon)
				theClient:outputChat("Você destruiu a casa ID "..rowDestroyHouse['id']..".")
			end
		end
	else
		theClient:outputChat("Você não tem permissão para fazer isso!",255,0,0)
	end
end

-- command destroyHouse
addCommandHandler("dcasa", destroyHouse)