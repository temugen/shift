//
//  SinglePlayerGameMenu.m
//  shift
//
//  Created by Greg McLain on 4/11/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SinglePlayerGameMenu.h"
#import "SinglePlayerMenu.h"
#import "SoundPlayer.h"
@implementation SinglePlayerGameMenu

-(id) init
{
    if ((self = [super init])) {        
        
        CCMenuItemFont *levelSelect = [CCMenuItemFont itemFromString:@"Level Select" target:self selector: @selector(onLevelSelect:)];
        
        [menu addChild:levelSelect];
        
        [menu alignItemsVertically];
    }
    
    return self;
}

-(void) onLevelSelect:(id)sender
{
    //Play menu selection sound
    //[[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    [[SoundPlayer sharedInstance]playSound:@SFX_MENU];

    [[CCDirector sharedDirector] runWithScene:[CCTransitionSlideInL transitionWithDuration:kSceneTransitionTime scene:[SinglePlayerMenu scene]]];
}

@end
