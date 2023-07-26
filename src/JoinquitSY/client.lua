--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- this will show when the player enter to the server
function joinquitJoin(thePlayer, theCountry, id)
	if(thePlayer and theCountry and id) then
		outputChatBox("#FF9900BnF™ #FFFFFF⎯  #77CCFF"..thePlayer.." #EFFFF7[ID "..id.."] #FFFFFFentrou no servidor! (#FF9900"..theCountry.."#FFFFFF)", 255, 255, 255, true)
		sound = playSound("sounds/join.wav")
	end
end

-- this will show when the player exit from the server
function joinquitQuit(thePlayer, theReason, id)
	if(thePlayer and theReason and id) then
		outputChatBox("#FF9900BnF™ #FFFFFF⎯  #77CCFF"..thePlayer.." #EFFFF7[ID "..id.."] #FFFFFFsaiu do servidor! (#FF9900"..theReason.."#FFFFFF)", 255, 255, 255, true)
		sound = playSound("sounds/quit.wav")
	end
end

-- this will show when the player log in the server
function joinquitLogin(thePlayer, id)
	if(thePlayer and id) then
		outputChatBox("#FF9900BnF™ #FFFFFF⎯  #77CCFF"..thePlayer.." #EFFFF7[ID "..id.."] #FFFFFFlogou no servidor!", 255, 255, 255, true)
	end
end

-- this will show when the player change your nick in the server
function joinquitChange(old, new, id)
	if(old and new and id) then
		outputChatBox("#FF9900BnF™ #FFFFFF⎯  #77CCFF"..old.." #EFFFF7[ID "..id.."] #FFFFFFalterou seu nick para #77CCFF"..new.."#FFFFFF!", 255, 255, 255, true)
	end
end

-- events
addEvent("onJoinQuitJoin", true)
addEventHandler("onJoinQuitJoin", localPlayer, joinquitJoin)
addEvent("onJoinQuitQuit", true)
addEventHandler("onJoinQuitQuit", localPlayer, joinquitQuit)
addEvent("onJoinQuitLogin", true)
addEventHandler("onJoinQuitLogin", localPlayer, joinquitLogin)
addEvent("onJoinQuitChange", true)
addEventHandler("onJoinQuitChange", localPlayer, joinquitChange)