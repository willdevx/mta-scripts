--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "KitSY"
local resourceDescription = "Sistema de Kits"

-- function that will give to player the weapon kit 1
function giveKit1(theClient, theCommand)
	if(theClient) then
	theClient:takeAllWeapons()
	theClient:giveWeapon(4, 1000, true)
	theClient:giveWeapon(16, 150, true)
	theClient:giveWeapon(22, 500, true)
	theClient:giveWeapon(25, 250, true)
	theClient:giveWeapon(29, 500, true)
	theClient:giveWeapon(30, 1000, true)
	takePlayerMoney(theClient, tonumber(15000))
	theClient:outputChat("Você comprou o Kit de Armas 1. (Custo: $15k)")
	theClient:outputChat("#FFFFFF* #FF9900Você pegou o Kit de Armas 1.",0,0,0,true)
	end
end

-- command that will make the giveKit1 command run
addCommandHandler("kit1", giveKit1)

-- function that will give to player the weapon kit 2
function giveKit2(theClient, theCommand)
	if(theClient) then
	theClient:takeAllWeapons()
	theClient:giveWeapon(8, 1000, true)
	theClient:giveWeapon(39, 150, true)
	theClient:giveWeapon(23, 500, true)
	theClient:giveWeapon(26, 250, true)
	theClient:giveWeapon(32, 500, true)
	theClient:giveWeapon(31, 1000, true)
	takePlayerMoney(theClient, tonumber(20000))
	theClient:outputChat("Você comprou o Kit de Armas 2. (Custo: $20k)")
	theClient:outputChat("#FFFFFF* #FF9900Você pegou o Kit de Armas 2.",0,0,0,true)
	end
end

-- command that will make the giveKit2 command run
addCommandHandler("kit2", giveKit2)

-- function that will set to player the full health level
function setHealth(theClient, theCommand)
	if(theClient) then
	takePlayerMoney(theClient, tonumber(10000))
	setTimer(function()
	setElementHealth(theClient, 100)
	theClient:outputChat("#FFFFFF* #FF9900Você pegou o Kit de Primeiros Socorros.",0,0,0,true)
	end, 5000,1)
	theClient:outputChat("Você comprou o Kit de Primeiros Socorros. Usando... (Custo: $10k)")
	end
end

-- command that will make the setHealth command run
addCommandHandler("vida", setHealth)

-- function that will set to player the full armour level
function setArmor(theClient, theCommand)
	if(theClient) then
	takePlayerMoney(theClient, tonumber(7500))
	setTimer(function()
	setPlayerArmor(theClient, 100)
	theClient:outputChat("#FFFFFF* #FF9900Você pegou o Colete de Segurança.",0,0,0,true)
	end, 5000,1)
	theClient:outputChat("Você comprou o Colete de Segurança. Vestindo... (Custo: $7.5k)")
	end
end

-- command that will make the setArmor command run
addCommandHandler("colete", setArmor)