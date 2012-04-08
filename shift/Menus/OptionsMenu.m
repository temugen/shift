//
//  OptionsMenu.m
//  shift
//
//  Created by Greg McLain on 2/19/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "OptionsMenu.h"
#import "SinglePlayerGame.h"

@implementation OptionsMenu

-(id) init
{
    if( (self=[super init] )) {
        [self addBackButton];
    }
    return self;
}

@end
