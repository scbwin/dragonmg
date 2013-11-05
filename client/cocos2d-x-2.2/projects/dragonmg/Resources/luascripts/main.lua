require "luascripts/UI/LayerLogin/LayerLogin"
require "luascripts/UI/buzhen/buzhen.lua"
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
	scene:addChild(buzhen())
	CCDirector:sharedDirector():replaceScene(scene)
end

xpcall(main, __G__TRACKBACK__)