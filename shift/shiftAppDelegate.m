//
//  shiftAppDelegate.m
//  shift
//
//  Created by Brad Misik on 8/17/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "shiftAppDelegate.h"
#import "BoardLayer.h"
#import "MainMenu.h"
#import "RootViewController.h"
#import "GameCenterHub.h"

@implementation shiftAppDelegate

@synthesize window;
@synthesize viewController;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}

- (void) initColors
{
}

- (RootViewController*) sharedViewController
{
  return viewController;
}

-(void) initPlatformVariables
{
    platformPadding = 10;
    
    //Set cell size
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    GoalSprite *sampleGoal = [GoalSprite goalWithName:@"red"];
    float sampleSize = CGRectGetWidth([sampleGoal boundingBox]);
    float requestedCellSize = MIN(sampleSize, (screenSize.height - platformPadding * 2) / kDifficultyHard);
    platformCellSize = CGSizeMake(requestedCellSize, requestedCellSize);

    platformFontSize = 3 * platformPadding;
    platformMinCollisionForce = platformCellSize.width;
    platformDirectionThreshold = 4;
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
    //[glView setMultipleTouchEnabled:YES];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
    
    // Preload the background music (reduces startup time for background music)
    SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
    if (sae != nil) 
    {
        [sae preloadBackgroundMusic:@BGM_MENU];
        if (sae.willPlayBackgroundMusic)
        {
            sae.backgroundMusicVolume = 0.5f;
        }
    }
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:YES];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// Removes the startup flicker
	[self removeStartupFlicker];
    
    [CCFileUtils setiPadSuffix:@"~ipad"];
    [CCFileUtils setiPhoneRetinaDisplaySuffix:@"@2x"];
    [CCFileUtils setiPadRetinaDisplaySuffix:@"@2x~ipad"];
    
    [self initPlatformVariables];
    
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [MainMenu scene]];
  
    [[GameCenterHub sharedInstance] authenticateLocalPlayer];
    [GameCenterHub sharedInstance].rootViewController = viewController;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] resume];
    [[SimpleAudioEngine sharedEngine]resumeBackgroundMusic];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	[[CCDirector sharedDirector] startAnimation];
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];

	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc
{
	[CCDirector sharedDirector];
}

@end
