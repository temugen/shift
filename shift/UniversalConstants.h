//
//  UniversalConstants.h
//  shift
//
//  Created by Greg McLain on 2/20/12.
//  Copyright (c) 2012. All rights reserved.
//

/* This file contains constants that could potentially be used throughout the application.
 * Feel free to add additional constants, or move current constants to be defined here.
 */

@protocol UniversalConstants <NSObject>

typedef enum{
    EASY,
    MEDIUM,
    HARD
} difficulty;

typedef enum {
    QUICKPLAY,
    SINGLE,
    RANDOMMULTI,
    FRIENDMULTI
} gamemode;

//NOTE: if you change this value, you must change the way the levels are displayed in SinglePlayerMenu.m to correspond with
//the number of levels. Look for the line [menu alignItemsInColumns ....
#define NUM_LEVELS 20

#define len(array) (sizeof((array))/sizeof(typeof((array[0]))))

//Scene transition time
#define TRANS_TIME 0.3f


@end