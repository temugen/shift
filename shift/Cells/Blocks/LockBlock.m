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

-(id) initWithName:(NSString *)blockName
{
    NSString *filename = [NSString stringWithFormat:@"%@_lock.png",name];
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
    NSString *filename = [NSString stringWithFormat:@"%@_key.png",name];
    [self setTexture:[[CCTextureCache sharedTextureCache] addImage:filename]];
    self.movable = YES;
}

-(BOOL) onDoubleTap
{
    //If the block is unlocked, lock it and create a key
    if(self.movable)
    {
        BoardLayer *board = (BoardLayer *)self.parent;
        
        //If a key is able to be added, lock the block
        if([board addKey:self])
        {
            NSString *filename = [NSString stringWithFormat:@"%@_lock.png",name];
            [self setTexture:[[CCTextureCache sharedTextureCache] addImage:filename]];
            self.movable = NO;
        }
    }
    return NO;
}


@end
