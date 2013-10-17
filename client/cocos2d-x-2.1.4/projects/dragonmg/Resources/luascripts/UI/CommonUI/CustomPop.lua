require "luascripts/langchs"
require "luascripts/extern"
pop = nil
CustomPop = class("CustomPop", function()
	return CCLayerColor:create(ccc4(0,0,0,180))
end)

CustomPop.__index = CustomPop
CustomPop.btnsMenu = nil
CustomPop.desc = nil

function CustomPop:init()
	self:setTouchEnabled(true)
	self:registerScriptTouchHandler(CustomPop.onTouch)
	local size = CCDirector:sharedDirector():getWinSize()
	self:setContentSize(size)

	local bkg = CCSprite:create("common_pop_bkg.png")
	bkg:setPosition(ccp(size.width/2, size.height/2))
	self:addChild(bkg)
	local sz = bkg:getContentSize()
	local title = CCLabelTTF:create(str_CustomPop0, str_font0, 28)
	local black1 = ccc3(236,190,108)
	local black = ccc3(27,18,6)
	title:setColor(black)
	title:setAnchorPoint(ccp(0.5,1))
	title:setPosition(ccp(sz.width/2+1, sz.height-23))
	bkg:addChild(title)
	local title1 = CCLabelTTF:create(str_CustomPop0, str_font0, 28)
	title1:setColor(black1)
	title1:setAnchorPoint(ccp(0.5, 1))
	title1:setPosition(ccp(sz.width/2, sz.height-22))
	bkg:addChild(title1)

	self.desc = CCLabelTTF:create("", str_font0, 25, CCSizeMake(400, 0), kCCTextAlignmentCenter)
	self.desc:setColor(black)
	self.desc:setPosition(ccp(sz.width/2, sz.height/2 + 10))
	bkg:addChild(self.desc)

	local bz = CCMenuItemImage:create("common_btn_ok_1.png", "common_btn_ok_2.png")
	bz:registerScriptTapHandler(CustomPop.close)
	bz:setScale(1.3)

	self.btnsMenu = CCMenu:create()
	self.btnsMenu:addChild(bz)
	self.btnsMenu:setPosition(ccp(sz.width/2, 80))

	bkg:addChild(self.btnsMenu)
end

function CustomPop:onTouch(event, x, y)
	local istouch
	print "SDFSDFDSFDSFDSFSFD"
	if event == "began" then 
		istouch = self.btnsMenu:onTouchBegan(event,x,y)
		return true
	elseif event == "moved" then 
		if istouch then 
			self.btnsMenu:onTouchMoved(event,x,y)
		end
		return true 
	elseif event == "ended" then 
		if istouch then 
			self.btnsMenu:onTouchEnded(event,x,y) 
		end
		return true 
	end
end

function CustomPop:show(str)
	if pop == nil then 
		pop = CustomPop.new()
		pop:init()
	end 
	CCDirector:sharedDirector():getRunningScene():addChild(pop)
	pop.desc:setString(str)
end

function CustomPop:close(sender)
	pop:removeFromParentAndCleanup(true)
	pop = nil
end
