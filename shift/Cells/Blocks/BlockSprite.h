//
//  BlockSprite.h
//  shift
//
//  Created by Brad Misik on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// The block sound effect files
#define SFX_GRAB "shift_grab.mp3"
#define SFX_DROP "shift_drop.mp3"
#define SFX_ROTATE "shift_rotator.mp3"
#define SFX_RAM "shift_ram.mp3"
#define SFX_DESTRUCT "shift_destruct.mp3"
#define SFX_LOCK "shift_lock.mp3"
#define SFX_UNLOCK "shift_unlock.mp3"

#import "CellSprite.h"
#import "SimpleAudioEngine.h"
#import "SoundPlayer.h"

@interface BlockSprite : CellSprite
{

}

-(id) initWithName:(NSString *)name;
+(id) blockWithName:(NSString *)name;

@end
