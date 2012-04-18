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
    //Play ram collide sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_RAM];
    
    //Only remove the key if it collided with a DestructiveBlock
    if([cell isKindOfClass:[DestructiveBlock class]])
    {
        [self removeKey];
    }
    return NO;
}

-(void) removeKey
{
    BoardLayer *board = (BoardLayer *)self.parent;
    [board removeBlock: self];
}

@end
