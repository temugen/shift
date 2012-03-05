//
//  GameConfig.h
//  shift
//
//  Created by Brad Misik on 8/17/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//

// 3rd generation and newer devices: Rotate using UIViewController. Rotation should be supported on iPad apps.
// TIP:
// To improve the performance, you should set this value to "kGameAutorotationNone" or "kGameAutorotationCCDirector"
#if defined(__ARM_NEON__) || TARGET_IPHONE_SIMULATOR
#define GAME_AUTOROTATION kGameAutorotationUIViewController

// ARMv6 (1st and 2nd generation devices): Don't rotate. It is very expensive
#elif __arm__
#define GAME_AUTOROTATION kGameAutorotationNone


// Ignore this value on Mac
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

#else
#error(unknown architecture)
#endif

//Describes the current movement occurring on a block train
typedef enum {
    kColumn,
    kRow,
    kNone,
    kStarted
} Movement;

typedef enum{
    EASY,
    MEDIUM,
    HARD
} difficulty;

typedef enum {
    QUICKPLAY,
    SINGLE,
    RANDOMMULTI,
    FRIENDMULTI,
    LEADERBOARD,
    HARDTIMELB,
    HARDMOVELB
} gamemode;

//NOTE: if you change this value, you must change the way the levels are displayed in SinglePlayerMenu.m to correspond with
//the number of levels. Look for the line [menu alignItemsInColumns ....
#define NUM_LEVELS 20

#define len(array) (sizeof((array))/sizeof(typeof((array[0]))))

//Scene transition time
#define TRANS_TIME 0.3f

static NSString * const colors[] = {
    @"blue",
    @"red",
    @"green",
    @"purple",
    @"yellow",
    @"orange"
};

#endif // __GAME_CONFIG_H

