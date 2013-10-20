#include "cocos2d.h"
#include "CCEGLView.h"
#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "Lua_extensions_CCB.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#include "Lua_web_socket.h"
#endif

using namespace CocosDenshion;

USING_NS_CC;

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();
}

bool AppDelegate::applicationDidFinishLaunching()
{
    // initialize director
    CCDirector *pDirector = CCDirector::sharedDirector();
    pDirector->setOpenGLView(CCEGLView::sharedOpenGLView());

    // turn on display FPS
    pDirector->setDisplayStats(true);

    // set FPS. the default value is 1.0/60 if you don't call this
    pDirector->setAnimationInterval(1.0 / 60);

    // register lua engine
    CCLuaEngine* pEngine = CCLuaEngine::defaultEngine();
    CCScriptEngineManager::sharedManager()->setScriptEngine(pEngine);

    CCLuaStack *pStack = pEngine->getLuaStack();
    lua_State *tolua_s = pStack->getLuaState();
    tolua_extensions_ccb_open(tolua_s);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
    pStack = pEngine->getLuaStack();
    tolua_s = pStack->getLuaState();
    tolua_web_socket_open(tolua_s);
#endif
    std::string dirPath = "luascripts";
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    CCString* pstrFileContent = CCString::createWithContentsOfFile((dirPath + "/main.lua").c_str());
    if(pstrFileContent)
    {
        pEngine.executeString(pstrFileContent->getCString());
    }
#else
    std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename((dirPath +"/main.lua").c_str());
    //std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("hello.lua");
    pEngine->addSearchPath(path.substr(0, path.find_last_of("/") - dirPath.length()).c_str());
    pEngine->executeScriptFile(path.c_str());
#endif
    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    CCDirector::sharedDirector()->stopAnimation();

    SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    CCDirector::sharedDirector()->startAnimation();

    SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
}
