--[[-----------------------------------------
-- This resource was created by Namykazesz.
-- (c) 2017 BnF Server. All rights reserved.
--]]-----------------------------------------

-- this will show the jobs list to the player
function showSy()
	guiSetVisible(theWindow, true)
	showCursor(true)
	triggerServerEvent("onPlayerJobListRequest", resourceRoot)
end

-- job list window
theWindow = guiCreateWindow(0.5-0.15,0.5-0.25,0.3,0.5,"Lista de Trabalhos",true)
theList = guiCreateGridList(0,0.07,1,0.8,true,theWindow)
columnJobName = guiGridListAddColumn(theList, "Cargo", 0.45)
columnJobMoney = guiGridListAddColumn(theList, "Recompensa", 0.45)
if(columnJobName and columnJobMoney) then
	for c,mp in pairs(jobsList) do
		theRow = guiGridListAddRow(theList)
		guiGridListSetItemText(theList, theRow, columnJobName, c, false, false)
		guiGridListSetItemText(theList, theRow, columnJobMoney, mp[1], false, false)
	end
end
exitButton = guiCreateButton(0,0.885,1,0.1,"Fechar",true,theWindow)
guiWindowSetSizable(theWindow,false)
guiSetVisible(theWindow, false)

-- this will close the job list window by button request
function closeBWindow()
	if(source==exitButton) then
		closeWindow()
	end
end

-- this will close the job list window
function closeWindow()
	guiSetVisible(theWindow, false)
	showCursor(false)
end

-- this will make the player go to the selected job
function goJob()
	if(guiGridListGetSelectedItem(theList)~=-1) then
		selectedJob, selectedCol = guiGridListGetSelectedItem(theList)
		theJobName = guiGridListGetItemText(theList,selectedJob,selectedCol)
		closeWindow()
		for c,mp in pairs(jobsList) do
			if(theJobName==c) then
				job = c
				x = mp[2]
				y = mp[3]
				z = mp[4]
			end
		end
		if(x and y and z) then
			fadeCamera(false,1,0,0,0)
			setTimer(function()
				setElementPosition(getLocalPlayer(),x,y,z)
			end,1000,1)
			triggerServerEvent("onPlayerJobListSelected", resourceRoot, job)
			setTimer(function()
				fadeCamera(true,1.0,0,0,0)
			end,2000,1)
		else
			outputChatBox("* Desculpe, mas não foi possível ir até o trabalho. Tente ir em outro.",255,0,0)
		end
	else
		outputChatBox("* Por favor, selecione um trabalho para ir.",255,0,0)
	end
end

-- command & events
addCommandHandler("trabalhos", showSy)
addEventHandler("onClientGUIClick", exitButton, closeBWindow)
addEventHandler("onClientGUIDoubleClick", theList, goJob)