#include "cocos2d.h"
#include "CCEGLView.h"
#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "Lua_extensions_CCB.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#include "Lua_web_socket.h"
#endif

#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
#include <dirent.h>
#include <sys/stat.h>
#endif

using namespace CocosDenshion;

USING_NS_CC;
USING_NS_CC_EXT;

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

	//pDirector->getOpenGLView()->setFrameSize(960,480);
	//pDirector->getOpenGLView()->setFrameZoomFactor(2.0);

	//pDirector->getOpenGLView()->setEditorFrameSize(480,320);
	//pDirector->setContentScaleFactor(0.5);
	pDirector->getOpenGLView()->setDesignResolutionSize(480,320, kResolutionExactFit);
	CCScene* scene = CCScene::create();
	UpdateLayer *updateLayer = new UpdateLayer();
	scene->addChild(updateLayer);
	updateLayer->release();
	//updateLayer->scheduleOnce(SEL_SCHEDULE(&UpdateLayer::update),0);
	updateLayer->scheduleOnce(SEL_SCHEDULE(&UpdateLayer::EnterGame),0);
	pDirector->runWithScene(scene);
   
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

UpdateLayer::UpdateLayer()
	:pProgressLabel(NULL)
{
	init();
}

UpdateLayer::~UpdateLayer()
{
	AssetsManager *pAssetsManager = getAssetsManager();
	CC_SAFE_DELETE(pAssetsManager);
}

bool UpdateLayer::init()
{
	CCLayer::init();

	createDownLoadedDir();

	CCSize size = CCDirector::sharedDirector()->getWinSize();

	pProgressLabel = CCLabelTTF::create("", "hycc.ttf",20);
	pProgressLabel->setPosition(ccp(100,50));
	addChild(pProgressLabel);

	return true;
}

AssetsManager* UpdateLayer::getAssetsManager()
{
	static AssetsManager *pAssetsManager = NULL;
	if (!pAssetsManager)
	{
		pAssetsManager = new AssetsManager("https://raw.github.com/scbwin/dragonmg/master/client/cocos2d-x-2.2/projects/dragonmg/Resources/Resources.zip",
"https://raw.github.com/scbwin/dragonmg/master/client/cocos2d-x-2.2/projects/dragonmg/Resources/version.txt",
		pathToSave.c_str());
		pAssetsManager->setDelegate(this);
		pAssetsManager->setConnectionTimeout(3);
	}
	return pAssetsManager;
}

void UpdateLayer::update(float dt)
{
	pProgressLabel->setString("");

	getAssetsManager()->update();
}

void UpdateLayer::createDownLoadedDir()
{
	pathToSave =CCFileUtils::sharedFileUtils()->getWritablePath();
	pathToSave += "tempdir";
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
	DIR *pDir = NULL;

	pDir = opendir(pathToSave.c_str());
	if(!pDir)
	{
		mkdir(pathToSave.c_str(), S_IRWXU|S_IRWXG|S_IRWXO);
	}
#else
	if ((GetFileAttributesA(pathToSave.c_str()))== INVALID_FILE_ATTRIBUTES)
	{
		CreateDirectoryA(pathToSave.c_str(), 0);
	}
#endif
}

void UpdateLayer::onError(AssetsManager::ErrorCode errorCode)
{
	if (errorCode == AssetsManager::kNoNewVersion)
	{
		pProgressLabel->setString("no new version");
		std::vector<std::string> searchPaths = CCFileUtils::sharedFileUtils()->getSearchPaths();
		searchPaths.insert(searchPaths.begin(), pathToSave);
		CCFileUtils::sharedFileUtils()->setSearchPaths(searchPaths);
		EnterGame();
	}

	if (errorCode == AssetsManager::kNetwork)
	{
		pProgressLabel->setString("network error");
	}
}

void UpdateLayer::onProgress(int persent)
{
	char progress[20];
	snprintf(progress, 20, "downloading %d%%", persent);
	pProgressLabel->setString(progress);
}

void UpdateLayer::EnterGame(float dt)
{
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

#if (CC_TARGET_PLATFORM == CC_PLATFORM_BLACKBERRY)
	CCFileUtils::sharedFileUtils()->addSearchPath("script");
#endif


	std::string scriptsPath = "luascripts";
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	CCString* pstrFileContent = CCString::createWithContentsOfFile((scriptsPath + "/main.lua").c_str());
	if (pstrFileContent)
	{
		pEngine->executeString(pstrFileContent->getCString());
	}
#else
	std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename((scriptsPath + "/main.lua").c_str());
	pEngine->addSearchPath(path.substr(0, path.find_last_of("/") - scriptsPath.length()).c_str());
	pEngine->executeScriptFile(path.c_str());
#endif
}

void UpdateLayer::onSuccess()
{
	pProgressLabel->setString("download ok");
	EnterGame();
}
