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
        overlay = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"block_lock.png"]];
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
    if([cell.name isEqualToString:@"key"])
    {
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
    if(![board isOutOfBoundsAtX:x y:y] && [board blockAtX:x y:y] == nil)
    {
        BlockSprite *block = [KeyBlock blockWithName:@"key"];
        block.scaleX = self.scaleX;
        block.scaleY = self.scaleY;
        [board addBlock:block x:x y:y];
        return YES;
    }
    return NO;
}

@end
