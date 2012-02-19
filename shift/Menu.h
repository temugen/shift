//
//  Menu.h
//  shift
//
//  Created by Greg McLain on 2/15/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "cocos2d.h"

#define TRANS_TIME 0.3f

typedef enum {
    QUICKPLAY,
    RANDOMMULTI,
    FRIENDMULTI
} gamemode;

@interface Menu : CCLayer

+(id) scene:(CCLayer*) layer;

@end
