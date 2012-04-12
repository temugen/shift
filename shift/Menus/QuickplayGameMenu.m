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
        
        CCMenuItemFont *newPuzzle = [CCMenuItemFont itemFromString:@"New puzzle" target:self selector: @selector(onNewPuzzle:)];
        
        [menu addChild:newPuzzle];
        
        [menu alignItemsVertically];
    }
    
    return self;
}

-(void) onNewPuzzle:(id)sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewPuzzle" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onPlay" object:self];
}

@end
