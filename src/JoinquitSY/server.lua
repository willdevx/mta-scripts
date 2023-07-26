--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- initial properties
local resourceCreationDate = "2017"
local resourceOfficialName = "JobWeed"
local resourceDescription = "Sistema de Joinquit"
countries =
{
	["CN"] = "China",
	["US"] = "Estados Unidos da América",
	["JP"] = "Japão",
	["BR"] = "Brasil",
	["DE"] = "Alemanha",
	["IN"] = "Índia",
	["GB"] = "Reino Unido",
	["FR"] = "França",
	["NG"] = "Nigéria",
	["RU"] = "Rússia",
	["KR"] = "Coréia do Sul",
	["MX"] = "México",
	["IT"] = "Itália",
	["ES"] = "Espanha",
	["TR"] = "Turquia",
	["CA"] = "Canadá",
	["VN"] = "Vietnã",
	["CO"] = "Colômbia",
	["PL"] = "Polônia",
	["PK"] = "Paquistão",
	["EG"] = "Egito",
	["ID"] = "Indonésia",
	["TH"] = "Tailândia",
	["TW"] = "Taiwan",
	["AU"] = "Austrália",
	["MY"] = "Malásia",
	["NL"] = "Holanda",
	["AR"] = "Argentina",
	["MA"] = "Marrocos",
	["SA"] = "Arábia Saudita",
	["PE"] = "Peru",
	["VE"] = "Venezuela",
	["SE"] = "Suécia",
	["PH"] = "Filipinas",
	["IR"] = "Irã",
	["BE"] = "Bélgica",
	["RO"] = "Roménia",
	["UA"] = "Ucrânia",
	["CL"] = "Chile",
	["CZ"] = "República Checa",
	["HU"] = "Hungria",
	["CH"] = "Suíça",
	["AT"] = "Áustria",
	["KZ"] = "Cazaquistão",
	["PT"] = "Portugal",
	["GR"] = "Grécia",
	["HK"] = "Hong Kong",
	["DK"] = "Dinamarca",
	["DZ"] = "Argélia",
	["UZ"] = "Uzbequistão",
}
reasons =
{
	["Unknown"] = "Motivo desconhecido",
	["Quit"] = "Saiu",
	["Kicked"] = "Expulso",
	["Banned"] = "Banido",
	["Bad Connection"] = "Conexão ruim",
	["Timed out"] = "Conexão perdida",
}

-- this will show the resource info to the player
outputChatBox("#F2F2F2(c) "..resourceCreationDate.." - #FFFFFF"..resourceOfficialName.." #F2F2F2(licenciado para BnF™) pelo criador #FF0000Namykaze#F2F2F2.", getRootElement(), 255, 255, 255, true)
outputChatBox(resourceOfficialName..": "..resourceDescription.." iniciado.")

-- this will show when the player enter to the server
function joinPlayer()
	thePlayer = getPlayerName(source)
	country = exports.admin:getPlayerCountry(source)
	id = getElementData(source, "ID")
	if(countries[country]) then
		theCountry = countries[country]
	else
		theCountry = "Desconhecido"
	end
	for _, player in ipairs(getElementsByType("player")) do
		triggerClientEvent(player, "onJoinQuitJoin", player, thePlayer, theCountry, id)
	end
end

-- this will show when the player exit from the server
function quitPlayer(reason)
	thePlayer = getPlayerName(source)
	id = getElementData(source, "ID")
	if(reasons[reason]) then
		theReason = reasons[reason]
	else
		theReason = "Erro"
	end
	for _, player in ipairs(getElementsByType("player")) do
		triggerClientEvent(player, "onJoinQuitQuit", player, thePlayer, theReason, id)
	end
end

-- this will show when the player log in the server
function loginPlayer()
	thePlayer = getPlayerName(source)
	id = getElementData(source, "ID")
	for _, player in ipairs(getElementsByType("player")) do
		triggerClientEvent(player, "onJoinQuitLogin", player, thePlayer, id)
	end
end

-- this will show when the player change your nick in the server
function changePlayer(old, new)
	id = getElementData(source, "ID")
	for _, player in ipairs(getElementsByType("player")) do
		triggerClientEvent(player, "onJoinQuitChange", player, old, new, id)
	end
end

-- events
addEventHandler("onPlayerJoin", getRootElement(), joinPlayer)
addEventHandler("onPlayerQuit", getRootElement(), quitPlayer)
addEventHandler("onPlayerLogin", getRootElement(), loginPlayer)
addEventHandler("onPlayerChangeNick", getRootElement(), changePlayer)