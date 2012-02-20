//
//  UniversalConstants.h
//  shift
//
//  Created by Greg McLain on 2/20/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

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

#define NUM_LEVELS 20

#define len(array) (sizeof((array))/sizeof(typeof((array[0]))))

@end
