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

@implementation LockBlock

-(id) initWithName:(NSString *)blockName
{
    if ((self = [super initWithName:blockName])) {
        overlay = [CCSprite spriteWithFile:@"block_lock.png"];
        overlay.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:overlay];
        
        comparable = YES;
        movable = NO;
        name = blockName;
    }
    return self;
}

-(BOOL) onCollideWithCell:(CellSprite *)cell force:(float)force
{
    if([cell isKindOfClass:[KeyBlock class]])
    {
        [self.board removeBlock:(BlockSprite *)cell];
        [self unlock];
    }
    return NO;
}

-(void) unlock
{    
    //Play unlock sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_UNLOCK];
    
    overlay.texture = [[CCTextureCache sharedTextureCache] addImage:@"block_unlock.png"];
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
            [self completeTutorial];
            
            //Play lock sound
            [[SimpleAudioEngine sharedEngine] playEffect:@SFX_LOCK];
            
            overlay.texture = [[CCTextureCache sharedTextureCache] addImage:@"block_lock.png"];
            self.movable = NO;
        }
    }
    return NO;
}

-(BOOL) dropKey
{
    //Attempt to set key at one of the adjacent 4 cells
    if ([self setKeyAtX:column-1 y:row] ||
        [self setKeyAtX:column y:row+1] ||
        [self setKeyAtX:column+1 y:row] ||
        [self setKeyAtX:column y:row-1]) {
        
        //We created a key
        return YES;
    }
    else
    { 
        //We couldn't create a key
        return NO;
    }
}

-(BOOL) setKeyAtX:(int)x y:(int)y
{
    //Make sure new position is not out of bounds, and there is not already a block there.
    if(![self.board isOutOfBoundsAtX:x y:y] && [self.board blockAtX:x y:y] == nil)
    {
        BlockSprite *block = [KeyBlock blockWithName:@"key"];
        [self.board addBlock:block x:x y:y];
        return YES;
    }
    return NO;
}

@end
