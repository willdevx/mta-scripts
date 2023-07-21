--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "EventSY"
local resourceDescription = "Sistema de Eventos"
local active = "false"
local theMarker = nil
local eventPlayers = {}
local eventVehicles = {}

-- function that will make the event be created
function namyEvent(theClient, theCommand)
	if(theClient) then
		if(hasObjectPermissionTo(theClient, "function.kickPlayer")) then
			if(active=="false") then
				local x,y,z = getElementPosition(theClient)
				theMarker = createMarker(x,y,z-1,"cylinder",1.5,100,0,50)
				clientDimension = theClient:getDimension()
				clientInterior = theClient:getInterior()
				if(clientDimension) then
				theMarker:setDimension(clientDimension)
				end
				if(clientInterior) then
				theMarker:setInterior(clientInterior)
				end
				active = "true"
				outputChatBox("#FF0040【 ✡  EVENTO ✡ 】: #FFFFFFO staff "..getPlayerName(theClient).." criou um evento! #FFFFFFDigite #FF0040[/irevento] #FFFFFFpara participar.", getRootElement(), 0,0,0,true)
				outputChatBox("Você criou o evento com sucesso. Para removê-lo, digite [/revento].", theClient)
			else
				outputChatBox("Já existe um evento ativo.", theClient)
			end
		else
			outputChatBox("Você não tem permissões para fazer isso!", theClient)
		end
	end
end

-- command that will make the namyEvent function run
addCommandHandler("cevento", namyEvent)

-- function that will make the event be closed
function destroyVagas(theClient)
	if(theClient) then
		if(hasObjectPermissionTo(theClient, "function.kickPlayer")) then
			if(isElement(theMarker)) then
				theMarker:destroy()
				outputChatBox("#FF0040【 ✡  EVENTO ✡ 】: #FFFFFFO staff "..getPlayerName(theClient).." fechou as vagas para o evento!", getRootElement(), 0,0,0,true)
			else
				outputChatBox("Não há um evento ativo para ser fechado.", theClient)
			end
		else
			outputChatBox("Você não tem permissões para fazer isso!", theClient)
		end
	end
end

-- command that will make the destroyVagas function run
addCommandHandler("rvagas", destroyVagas)

-- function that will make the event be destroyed
function destroyEvent(theClient)
	if(theClient) then
		if(hasObjectPermissionTo(theClient, "function.kickPlayer")) then
			if(active=="true") then
				theMarker:destroy()
				active = "false"
				for _, player in ipairs(getElementsByType("player")) do
					if(eventPlayers[player]) then
						eventPlayers[player] = nil
					end
				end
				outputChatBox("#FF0040【 ✡  EVENTO ✡ 】: #FFFFFFO staff "..getPlayerName(theClient).." removeu o evento!", getRootElement(), 0,0,0,true)
			else
				outputChatBox("Não há um evento ativo para ser removido.", theClient)
			end
		else
			outputChatBox("Você não tem permissões para fazer isso!", theClient)
		end
	end
end

-- command that will make the destroyEvent function run
addCommandHandler("revento", destroyEvent)

-- function that will take the player to event
function goEvent(theClient)
	if(theClient) then
		if(isElement(theMarker)) then
			if(eventPlayers[theClient]) then
				outputChatBox("Você já está no evento.", theClient)
			else
				if(theClient:getOccupiedVehicle()) then
					outputChatBox("Saia do veículo para poder ir ao evento.", theClient)
				else
					local x,y,z = getElementPosition(theMarker)
					theClient:setPosition(x,y,z+1)
					theClient:setDimension(clientDimension)
					theClient:setInterior(clientInterior)
					eventPlayers[theClient] = true
					outputChatBox("#FF0040【 ✡  EVENTO ✡ 】: #FFFFFFO jogador "..getPlayerName(theClient).." foi para o evento utilizando #FFFFFF[/irevento]!", getRootElement(), 0,0,0,true)
					outputChatBox("#FFFF00Você está no evento! Atenção para o que se pede, ou será desclassificado.", theClient, 0,0,0, true)
				end
			end
		else
			outputChatBox("Desculpe, mas não há um ativo ou vagas de um evento para ir.", theClient)
		end
	end
end

-- command that will make the goEvent function run
addCommandHandler("irevento", goEvent)

-- function that will give to all players an weapon
function giveWeapon(theClient, theCommand, weaponID)
	if(theClient) then
		if(hasObjectPermissionTo(theClient, "function.kickPlayer")) then
			if(active=="true") then
				local iList = 0
				for _, player in ipairs(getElementsByType("player")) do
					if(eventPlayers[player]) then
					takeAllWeapons(player)
					player:giveWeapon(weaponID, 1000, true)
					player:outputChat("#FF0040【 ✡  EVENTO ✡ 】: #FFFFFFO staff "..getPlayerName(theClient).." deu a arma '"..getWeaponNameFromID(weaponID).."' para todos os participantes!", 0,0,0,true)
					iList = iList+1
					end
				end
				theClient:outputChat("Você deu a arma ID "..weaponID.." para o(s) "..iList.." participante(s).")
			else
				outputChatBox("Não há um evento ativo.", theClient)
			end
		else
			outputChatBox("Você não tem permissões para fazer isso!", theClient)
		end
	end
end

-- command that will make the giveWeapon function run
addCommandHandler("darma", giveWeapon)

-- function that will remove all weapons from the players
function removeWeapons(theClient)
	if(theClient) then
		if(hasObjectPermissionTo(theClient, "function.kickPlayer")) then
			if(active=="true") then
				local iList = 0
				for _, player in ipairs(getElementsByType("player")) do
					if(eventPlayers[player]) then
					takeAllWeapons(player)
					player:outputChat("#FF0040【 ✡  EVENTO ✡ 】: #FFFFFFO staff "..getPlayerName(theClient).." removeu as armas de todos os participantes!", 0,0,0,true)
					iList = iList+1
					end
				end
				theClient:outputChat("Você removeu as armas do(s) "..iList.." participante(s).")
			else
				outputChatBox("Não há um evento ativo.", theClient)
			end
		else
			outputChatBox("Você não tem permissões para fazer isso!", theClient)
		end
	end
end

-- command that will make the removeWeapons function run
addCommandHandler("rarmas", removeWeapons)

-- function that will freeze all players
function freezePlayers(theClient)
	if(theClient) then
		if(hasObjectPermissionTo(theClient, "function.kickPlayer")) then
			if(active=="true") then
				local iList = 0
				for _, player in ipairs(getElementsByType("player")) do
					if(eventPlayers[player]) then
					player:toggleControl("fire",false)
					player:toggleControl("next_weapon",false)
					player:toggleControl("left",false)
					player:toggleControl("right",false)
					player:toggleControl("jump",false)
					player:toggleControl("sprint",false)
					player:toggleControl("forwards",false)
					player:toggleControl("backwards",false)
					player:toggleControl("walk",false)
					player:toggleControl("previous_weapon",false)
					player:toggleControl("aim_weapon",false)
					player:toggleControl("crouch",false)
					player:toggleControl("enter_exit",false)
					player:toggleControl("vehicle_fire",false)
					player:toggleControl("vehicle_secondary_fire",false)
					player:toggleControl("vehicle_left",false)
					player:toggleControl("vehicle_right",false)
					player:toggleControl("vehicle_forward",false)
					player:toggleControl("streer_back",false)
					player:toggleControl("accelerate",false)
					player:toggleControl("brake_reverse",false)
					player:toggleControl("handbrake",false)
					player:outputChat("#FF0040【 ✡  EVENTO ✡ 】: #FFFFFFO staff "..getPlayerName(theClient).." congelou todos os participantes!", 0,0,0,true)
					iList = iList+1
					end
				end
				theClient:outputChat("Você congelou o(s) "..iList.." participante(s).")
			else
				outputChatBox("Não há um evento ativo.", theClient)
			end
		else
			outputChatBox("Você não tem permissões para fazer isso!", theClient)
		end
	end
end

-- command that will make the freezePlayers function run
addCommandHandler("congelar", freezePlayers)

-- function that will unfreeze all players
function unfreezePlayers(theClient)
	if(theClient) then
		if(hasObjectPermissionTo(theClient, "function.kickPlayer")) then
			if(active=="true") then
				local iList = 0
				for _, player in ipairs(getElementsByType("player")) do
					if(eventPlayers[player]) then
					player:toggleControl("fire",true)
					player:toggleControl("next_weapon",true)
					player:toggleControl("left",true)
					player:toggleControl("right",true)
					player:toggleControl("jump",true)
					player:toggleControl("sprint",true)
					player:toggleControl("forwards",true)
					player:toggleControl("backwards",true)
					player:toggleControl("walk",true)
					player:toggleControl("previous_weapon",true)
					player:toggleControl("aim_weapon",true)
					player:toggleControl("crouch",true)
					player:toggleControl("enter_exit",true)
					player:toggleControl("vehicle_fire",true)
					player:toggleControl("vehicle_secondary_fire",true)
					player:toggleControl("vehicle_left",true)
					player:toggleControl("vehicle_right",true)
					player:toggleControl("vehicle_forward",true)
					player:toggleControl("streer_back",true)
					player:toggleControl("accelerate",true)
					player:toggleControl("brake_reverse",true)
					player:toggleControl("handbrake",true)
					player:outputChat("#FF0040【 ✡  EVENTO ✡ 】: #FFFFFFO staff "..getPlayerName(theClient).." descongelou todos os participantes!", 0,0,0,true)
					iList = iList+1
					end
				end
				theClient:outputChat("Você descongelou o(s) "..iList.." participante(s).")
			else
				outputChatBox("Não há um evento ativo.", theClient)
			end
		else
			outputChatBox("Você não tem permissões para fazer isso!", theClient)
		end
	end
end

-- command that will make the unfreezePlayers function run
addCommandHandler("descongelar", unfreezePlayers)

-- function that will kill all players
function killPlayers(theClient)
	if(theClient) then
		if(hasObjectPermissionTo(theClient, "function.kickPlayer")) then
			if(active=="true") then
				local iList = 0
				for _, player in ipairs(getElementsByType("player")) do
					if(eventPlayers[player]) then
					player:kill()
					player:outputChat("#FF0040【 ✡  EVENTO ✡ 】: #FFFFFFO staff "..getPlayerName(theClient).." eliminou todos os participantes!", 0,0,0,true)
					iList = iList+1
					end
				end
				theClient:outputChat("Você eliminou o(s) "..iList.." participante(s).")
			else
				outputChatBox("Não há um evento ativo.", theClient)
			end
		else
			outputChatBox("Você não tem permissões para fazer isso!", theClient)
		end
	end
end

-- command that will make the killPlayers function run
addCommandHandler("eliminar", killPlayers)

-- function that will give an vehicle to all players
function giveVehicle(theClient, theCommand, vehicleID)
	if(theClient) then
		if(hasObjectPermissionTo(theClient, "function.kickPlayer")) then
			if(active=="true") then
				local iList = 0
				for _, player in ipairs(getElementsByType("player")) do
					if(eventPlayers[player]) then
						if(eventVehicles[player]) then
							destroyElement(eventVehicles[player])
						end
						local x, y, z = getElementPosition(player)
						local playerRotation = getElementRotation(player)
						x = x + ((math.cos(math.rad(playerRotation))))
						y = y + ((math.sin(math.rad(playerRotation))))
						local newVehicle = createVehicle(vehicleID, x, y, z, 0, 0, playerRotation)
						playerDimension = getElementDimension(player)
						playerInterior = getElementInterior(player)
						setElementDimension(newVehicle, playerDimension)
						setElementInterior(newVehicle, playerInterior)
						eventVehicles[player] = newVehicle
						if(isElement(newVehicle)) then
							warpPedIntoVehicle(player, newVehicle)
						end
					player:outputChat("#FF0040【 ✡  EVENTO ✡ 】: #FFFFFFO staff "..getPlayerName(theClient).." deu o veículo '"..getVehicleNameFromModel(vehicleID).."' para todos os participantes!", 0,0,0,true)
					iList = iList+1
					end
				end
				theClient:outputChat("Você deu o veículo ID "..vehicleID.." para o(s) "..iList.." participante(s).")
			else
				outputChatBox("Não há um evento ativo.", theClient)
			end
		else
			outputChatBox("Você não tem permissões para fazer isso!", theClient)
		end
	end
end

-- command that will make the giveVehicle function run
addCommandHandler("dveiculo", giveVehicle)

-- function that will remove the vehicle from all players
function removeVehicles(theClient)
	if(theClient) then
		if(hasObjectPermissionTo(theClient, "function.kickPlayer")) then
			if(active=="true") then
				local iList = 0
				for _, player in ipairs(getElementsByType("player")) do
					if(eventPlayers[player]) then
					destroyElement(eventVehicles[player])
					player:outputChat("#FF0040【 ✡  EVENTO ✡ 】: #FFFFFFO staff "..getPlayerName(theClient).." removeu os veículos de todos os participantes!", 0,0,0,true)
					iList = iList+1
					end
				end
				theClient:outputChat("Você removeu o(s) veículo(s) do(s) "..iList.." participante(s).")
			else
				outputChatBox("Não há um evento ativo.", theClient)
			end
		else
			outputChatBox("Você não tem permissões para fazer isso!", theClient)
		end
	end
end

-- command that will make the removeVehicles function run
addCommandHandler("rveiculos", removeVehicles)

-- function that will remove the wasted players from the eventPlayers table
addEventHandler("onPlayerWasted", root,
function()
	if(eventPlayers[source]) then
		eventPlayers[source] = nil
	end
end)