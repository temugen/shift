//
//  LockBlock.m
//  shift
//
//  Created by Greg McLain on 2/21/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "LockBlock.h"
#import "BoardLayer.h"
#import "KeyBlock.h"
#import "SoundPlayer.h"
@implementation LockBlock

-(id) initWithName:(NSString *)blockName
{
    NSString *filename = [NSString stringWithFormat:@"%@_lock.png", blockName];
    if ((self = [super initWithFilename:filename])) {
        comparable = YES;
        movable = NO;
        name = blockName;
    }
    return self;
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
    //Play unlock sound
    //[[SimpleAudioEngine sharedEngine] playEffect:@SFX_UNLOCK];
    [[SoundPlayer sharedInstance]playSound:@SFX_UNLOCK];
    NSString *filename = [NSString stringWithFormat:@"%@_key.png",name];
    [self setTexture:[[CCTextureCache sharedTextureCache] addImage:filename]];
    self.movable = YES;
}

-(BOOL) onDoubleTap
{
    //If the block is unlocked, lock it and create a key
    if(self.movable)
    {
        //If a key is able to be added, lock the block
        if([self dropKey])
        {
            //Play lock sound
            //[[SimpleAudioEngine sharedEngine] playEffect:@SFX_LOCK];
            [[SoundPlayer sharedInstance]playSound:@SFX_LOCK];
            NSString *filename = [NSString stringWithFormat:@"%@_lock.png",name];
            [self setTexture:[[CCTextureCache sharedTextureCache] addImage:filename]];
            self.movable = NO;
        }
    }
    return NO;
}

-(BOOL) dropKey
{
    //Attempt to set key at one of the adjacent 8 cells
    if ([self setKeyAtX:row y:column-1] ||
        [self setKeyAtX:row+1 y:column] ||
        [self setKeyAtX:row y:column+1] ||
        [self setKeyAtX:row-1 y:column] ||
        [self setKeyAtX:row+1 y:column-1] ||
        [self setKeyAtX:row+1 y:column+1] ||
        [self setKeyAtX:row-1 y:column-1] ||
        [self setKeyAtX:row-1 y:column+1]) {
        
        //We created a key
        return true;
    }
    else
    { 
        //We couldn't create a key
        return false;
    }
}

-(BOOL) setKeyAtX:(int)x y:(int)y
{
    BoardLayer *board = (BoardLayer *)self.parent;
    //Make sure new position is not out of bounds, and there is not already a block there.
    if(![board isOutOfBoundsAtX:x y:y] && [board blockAtX:x y:y] == nil)
    {
        GoalSprite *sampleGoal = [GoalSprite goalWithName:@"red"];
        CGPoint scalingFactors = [sampleGoal resize:board.cellSize];
        BlockSprite *block = [KeyBlock blockWithName:@"key"];
        [block scaleWithFactors:scalingFactors];
        [board addBlock:block x:x y:y];
        return true;
    }
    return false;
}

@end
