local emitter
local zy1

local function ontouchEvent(eventType)
	if eventType == "pushDown" then
		if emitter ~= nil then 
			emitter:setLife(1)
			emitter = nil 
		end
		emitter = CCParticleSystemQuad:create("magicFire.plist")
   	 	emitter:setDuration(-1)
   	 	emitter:setPosition(ccp(zy1:getTouchStartPos().x,zy1:getTouchStartPos().y))
   	 	--zy1:addChild(emitter)
   	 	CCDirector:sharedDirector():getRunningScene():addChild(emitter)
	elseif eventType == "move" then 
		emitter:setPosition(ccp(zy1:getTouchMovePos().x,zy1:getTouchMovePos().y))
	elseif eventType == "releaseUp" then 
		emitter:setPosition(ccp(zy1:getTouchEndPos().x,zy1:getTouchEndPos().y))
		emitter:setDuration(1)
		emitter = nil
	end

end
	

function addPage3CallBack(uilayer)
	zy1 = uilayer:getWidgetByName("mf2zy1")
	zy1:registerEventScript(ontouchEvent)
end