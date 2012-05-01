//
//  RamBlock.m
//  shift
//
//  Created by Donghun Lee on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RamBlock.h"
#import "BoardLayer.h"
#import "DestructiveBlock.h"

@implementation RamBlock

-(id) initWithName:(NSString *)blockName
{
    NSString *filename = [NSString stringWithFormat:@"block_ram.png"];
    if ((self = [super initWithFilename:filename])) {
        comparable = NO;
        movable = YES;
        name = blockName;
    }
    return self;
}

-(BOOL) onCollideWithCell:(CellSprite *)cell force:(float)force
{
    if (force < platformMinCollisionForce) {
        return NO;
    }
    
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_RAM];
    
    if ([cell isKindOfClass:[DestructiveBlock class]]) {
        [self completeTutorial];
    }
    
    return YES;
}

@end
