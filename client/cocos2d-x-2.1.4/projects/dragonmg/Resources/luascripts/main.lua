require "luascripts/UI/LayerLogin/LayerLogin"
-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end
local function main()
	collectgarbage("setpause", 100) 
	collectgarbage("setstepmul", 5000)
	local scene = CCScene:create()
	scene:addChild(LayerLogin())
	CCDirector:sharedDirector():runWithScene(scene)
end

xpcall(main, __G__TRACKBACK__)