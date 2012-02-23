//
//  LockBlock.m
//  shift
//
//  Created by Greg McLain on 2/21/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "LockBlock.h"
#import "BoardLayer.h"

@implementation LockBlock

+(id) blockWithName:(NSString *)name
{
    NSString *filename = [NSString stringWithFormat:@"%@_lock.png",name];
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
    NSString *filename = [NSString stringWithFormat:@"%@_key.png",name];
    [self setTexture:[[CCTextureCache sharedTextureCache] addImage:filename]];
    self.movable = YES;
}

-(BOOL) onDoubleTap
{
    //If the block is unlocked, lock it and create a key
    if(self.movable)
    {
        NSString *filename = [NSString stringWithFormat:@"%@_lock.png",name];
        [self setTexture:[[CCTextureCache sharedTextureCache] addImage:filename]];
        self.movable = NO;
    }
    return NO;
}


@end
