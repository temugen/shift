//
//  QuickplayGameMenu.m
//  shift
//
//  Created by Greg McLain on 4/11/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "QuickplayGameMenu.h"

@implementation QuickplayGameMenu

-(id) init
{
    if ((self = [super init])) {
        [buttons addButtonWithDescription:@"New puzzle" target:self selector: @selector(onNewPuzzle:)];
    }
    
    return self;
}

-(void) onNewPuzzle:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewPuzzle" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onPlay" object:self];
}

@end
