local uiwidget1 = nil
local uiwidget2 = nil
local uiwidget3 = nil
local curindex = 0
local pagedeltatime = 0.5
local changeToPage
require "luascripts/UI/buzhen/buzhenpage1"
require "luascripts/UI/buzhen/buzhenpage2"
require "luascripts/UI/buzhen/buzhenpage3"

local function closebuttonEvent(eventType)
    if eventType == "pushDown" then
        print ("close button down")
    elseif eventType == "move" then
    elseif eventType == "releaseUp" then
    end
end

local function tab1buttonEvent(eventType)
    if eventType == "pushDown" and curindex ~= 1 then
        print("changeTopage1")
        changeToPage(1)
    end
end

local function tab2buttonEvent(eventType)
    if eventType == "pushDown" and curindex ~= 2 then
        print("changeTopage2")
        changeToPage(2)
    end
end

local function tab3buttonEvent(eventType)
    if eventType == "pushDown" and curindex ~= 3 then
        print("changeTopage3")
        changeToPage(3)
    end
end

function changeToPage(index)
    local scene = CCScene:create()
    local ul = UILayer:create()
    if index == 1 then
        --uiwidget1 = UIHelper:instance():createWidgetFromJsonFile("buzhen/buzhenpage1.ExportJson")
        curindex = 1
        ul:addWidget(uiwidget1)
    elseif index == 2 then
        curindex = 2
        ul:addWidget(uiwidget2)
    elseif index == 3 then 
        curindex = 3
        ul:addWidget(uiwidget3)
        addPage3CallBack(ul)
    end
    local closebutton = ul:getWidgetByName("close_btn")
       
    closebutton:registerEventScript(closebuttonEvent) 

    local tab01 = ul:getWidgetByName("tab01")
    tab01:registerEventScript(tab1buttonEvent)
    local tab02 = ul:getWidgetByName("tab02")
    tab02:registerEventScript(tab2buttonEvent)
    local tab03 = ul:getWidgetByName("tab03")
    tab03:registerEventScript(tab3buttonEvent)
    if curindex == 1 then
        tab01:setBrightStyle(BRIGHT_NORMAL)
    else 
        tab01:setBrightStyle(BRIGHT_HIGHLIGHT)
    end
    if curindex == 2 then
        tab02:setBrightStyle(BRIGHT_NORMAL)
    else 
        tab02:setBrightStyle(BRIGHT_HIGHLIGHT)
    end
    if curindex == 3 then
        tab03:setBrightStyle(BRIGHT_NORMAL)
    else 
        tab03:setBrightStyle(BRIGHT_HIGHLIGHT)
    end

    scene:addChild(ul)
    --scene = CCTransitionCrossFade:create(pagedeltatime, scene)
    CCDirector:sharedDirector():setDepthTest(true)
    scene = CCTransitionPageTurn:create(pagedeltatime, scene, false)
    CCDirector:sharedDirector():replaceScene(scene)
end


local function init()
    uiwidget1 = UIHelper:instance():createWidgetFromJsonFile("buzhen/buzhenpage1.ExportJson")
    uiwidget2 = UIHelper:instance():createWidgetFromJsonFile("buzhen/buzhenpage2.ExportJson")
    uiwidget3 = UIHelper:instance():createWidgetFromJsonFile("buzhen/buzhenpage3.ExportJson")
    uiwidget1:retain()
    uiwidget2:retain()
    uiwidget3:retain()
end

function buzhen()
    CCDirector:sharedDirector():setDepthTest(true)
    init()
	local ul = UILayer:create()
	ul:scheduleUpdateWithPriorityLua(SceneUpdate,-1)
	ul:addWidget(uiwidget2)

	local closebutton = ul:getWidgetByName("close_btn")
       
    closebutton:registerEventScript(closebuttonEvent) 
    local tab01 = ul:getWidgetByName("tab01")
    tab01:registerEventScript(tab1buttonEvent)
    tab01:setBrightStyle(BRIGHT_HIGHLIGHT)
    local tab03 = ul:getWidgetByName("tab03")
    tab03:registerEventScript(tab3buttonEvent)
    tab03:setBrightStyle(BRIGHT_HIGHLIGHT)

	return ul
end
