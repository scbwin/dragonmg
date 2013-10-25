require "luascripts/UI/LayerLogin/LayerLogin"
-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end
function SceneUpdate()
end
local function main()
	collectgarbage("setpause", 100) 
	collectgarbage("setstepmul", 5000)
	local scene = CCScene:create()
	--scene:addChild(LayerLogin())
	local ul = UILayer:create()
	ul:scheduleUpdateWithPriorityLua(SceneUpdate,-1)
	ul:addWidget(UIHelper:instance():createWidgetFromJsonFile("game_buzheng/game_buzheng.json"))
	scene:addChild(ul)
	CCDirector:sharedDirector():runWithScene(scene)
end

xpcall(main, __G__TRACKBACK__)