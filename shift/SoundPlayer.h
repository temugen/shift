//
//  SoundPlayer.h
//  shift
//
//  Created by Alex Chesebro on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"

// The block sound effect files
#define SFX_GRAB "shift_grab.mp3"
#define SFX_DROP "shift_drop.mp3"
#define SFX_ROTATE "shift_rotator.mp3"
#define SFX_RAM "shift_ram.mp3"
#define SFX_DESTRUCT "shift_destruct.mp3"
#define SFX_LOCK "shift_lock.mp3"
#define SFX_UNLOCK "shift_unlock.mp3"

// background music
#define BGM_MENU "shift_bg_menu.mp3"
#define SFX_MENU "shift_menu.mp3"
#define BGM_GAME "shift_bg_game.mp3"

@interface SoundPlayer : NSObject
{
    @public
    bool enable;
}


+(SoundPlayer*) sharedInstance;
-(id) init;
-(void) playSound:(NSString *)str;
-(void)playBackground:(NSString*) str;
@end
