--require "luascripts/extern"
require "luascripts/langchs"
require "luascripts/UI/CommonUI/CustomPop"
local winSize = CCDirector:sharedDirector():getWinSize()
local function zhenpin(layer)
    local editBoxUsername
    local editBoxPassword
    local function menuItemCallbackLogin(sender)
        if editBoxUsername:getText() == "" or editBoxPassword:getText() == "" then 
            CustomPop:show(str_LayerLogin0)
        else
            local userName = editBoxUsername:getText()
            local password = editBoxPassword:getText()
            local pattern = "%W"
            if string.find(userName, pattern) ~= nil or string.find(password, pattern) ~= nil then
                CustomPop:show(str_LayerLogin1)
            else 

            end 
        end
    end
	local pSpriteDialogLogin = CCSprite:createWithSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("login_input.png"))--CCSprite::create("login_bg_en.png");
    pSpriteDialogLogin:setPosition(ccp(winSize.width*0.5,winSize.height *0.5-100))
    layer:addChild(pSpriteDialogLogin)
 
    local btn_login = CCMenuItemImage:create()
    btn_login:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("login_login_1.png"))
    btn_login:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("login_login_2.png"))
    --btn_login:setTarget(layer, SEL_MenuHandler(menuItemCallbackLogin))
    btn_login:registerScriptTapHandler(menuItemCallbackLogin)
    local version=CCLabelTTF:create(str_LayerLogin2, str_font0, 18)
    version:setColor(ccc3(28,42,52))
    version:setPosition(ccp(winSize.width*0.5,winSize.height *0.5-290))
    layer:addChild(version)
    local pMenu = CCMenu:create()
    pMenu:alignItemsHorizontally()
    pMenu:addChild(btn_login)
    --pMenu->setPosition(pSpriteDialogLogin->getContentSize().width-75,pSpriteDialogLogin->getContentSize().height/2-10);
    pMenu:setPosition(ccp(winSize.width/2-30, winSize.height/2-460))
    pMenu:setTouchPriority(1)
    pSpriteDialogLogin:addChild(pMenu)
    
    
    local editbkg = CCScale9Sprite:create()
    
    editBoxUsername = CCEditBox:create(CCSizeMake(210,50),editbkg)
    editBoxUsername:setReturnType(kKeyboardReturnTypeDone)
    editBoxUsername:setFontSize(12)
    editBoxUsername:setText("")
    editBoxUsername:setFontColor(ccc3(158, 122, 83))
    editBoxUsername:setMaxLength(8)
    editBoxUsername:setPosition(ccp(winSize.width/2-10,96))--160,100
    pSpriteDialogLogin:addChild(editBoxUsername,2)
    
    local editbkg1 = CCScale9Sprite:create()
    editBoxPassword = CCEditBox:create(CCSizeMake(190, 50),editbkg1)
    editBoxPassword:setReturnType(kKeyboardReturnTypeDone)
    editBoxPassword:setInputFlag(kEditBoxInputFlagPassword)
    editBoxPassword:setFontColor(ccc3(158, 122, 83))
    editBoxPassword:setMaxLength(8)
    editBoxPassword:setFontSize(8)
    editBoxPassword:setText("")
    editBoxPassword:setPosition(ccp(winSize.width/2-22,45))--160,60
    
    pSpriteDialogLogin:addChild(editBoxPassword,2);
end
function LayerLogin()
	--CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ui_login.plist")
    local bg = CCSprite:create("login_back1.jpg")
	local loginlayer = CCLayer:create()
	--local winSize = CCDirector:sharedDirector():getWinSize()
	--local bg = CCSprite:createWithSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("login_bkg.png"))
	bg:setPosition(ccp(winSize.width * 0.5, winSize.height * 0.5))
    bg:setScale(2.0)
	loginlayer:addChild(bg)
    --zhenpin(loginlayer)
	return loginlayer
end




