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
        [self addSoundButton];
    }
    
    return self;
}

-(void)soundSwitch:(id)sender
{
    if ([[SimpleAudioEngine sharedEngine] mute]) {
        // This will unmute the sound
        [[SimpleAudioEngine sharedEngine] setMute:0];
    }
    else {
        //This will mute the sound
        [[SimpleAudioEngine sharedEngine] setMute:1];
    }
}
-(void)addSoundButton{

    _plusItem = [CCMenuItemImage itemFromNormalImage:@"Icon.png" 
                                    selectedImage:@"Icon.png" target:nil selector:nil];
    _minusItem = [CCMenuItemImage itemFromNormalImage:@"Icon.png" 
                                     selectedImage:@"Icon.png" target:nil selector:nil];
    CCMenuItemToggle *toggleItem = [CCMenuItemToggle itemWithTarget:self 
                                                           selector:@selector(soundSwitch:) items:_plusItem, _minusItem, nil];
    CCMenu *toggleMenu = [CCMenu menuWithItems:toggleItem, nil];
    toggleMenu.position = ccp(60, 120);
    [self addChild:toggleMenu];
}
@end
