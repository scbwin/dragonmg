local index0 = ccp(0,0)
local index1 = ccp(-290,0)
local index2 = ccp(-480,0)


function buzhen()
	local ul = UILayer:create()
	ul:scheduleUpdateWithPriorityLua(SceneUpdate,-1)
	ul:addWidget(UIHelper:instance():createWidgetFromJsonFile("game_buzheng/game_buzheng.ExportJson"))

	local closebutton = ul:getWidgetByName("close_btn")
	local function buttonEvent(eventType)
            if eventType == "pushDown" then
            	print ("close button down")
            elseif eventType == "move" then
            elseif eventType == "releaseUp" then
            end
        end
       
    closebutton:registerEventScript(buttonEvent) 
    
	return ul
end