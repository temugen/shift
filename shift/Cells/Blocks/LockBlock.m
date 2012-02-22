//
//  LockBlock.m
//  shift
//
//  Created by Greg McLain on 2/21/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "LockBlock.h"

@implementation LockBlock

+(id) blockWithName:(NSString *)name
{
    NSString *filename = [NSString stringWithFormat:@"block_red.png"];
    LockBlock *block = [self cellWithFilename:filename];
    block.comparable = YES;
    block.movable = NO;
    block.name = name;
    return block;
}

-(BOOL) onCollideWithCell:(CellSprite *)cell force:(float)force
{
    if([cell.name isEqualToString:@"key"])
    {
        [self unlock];
    }
    return NO;
}

-(void) unlock
{
    [self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"block_blue.png"]];
    self.movable = YES;
}

-(BOOL) onDoubleTap
{
    //If the block is unlocked, lock it and create a key
    if(self.movable)
    {
        [self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"block_red.png"]];
        self.movable = NO;
    }
    return NO;
}


@end
