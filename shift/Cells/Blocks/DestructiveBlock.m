//
//  DestructiveBlock.m
//  shift
//
//  Created by Donghun Lee on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DestructiveBlock.h"
#import "BoardLayer.h"

@implementation DestructiveBlock

+(id) blockWithName:(NSString *)name
{
    NSString *filename = [NSString stringWithFormat:@"block_destructive.png"];
    StationaryBlock *block = [self cellWithFilename:filename];
    block.health = 4;
    return block;
}

-(void) decreaseHealth
{
    int decreasedHealth = self.health;
    if(health > 0) decreasedHealth--;
    self.health = decreasedHealth;
}

-(BOOL) onCollideWithCell:(CellSprite *)cell force:(float)force
{
    if(self.health >0)
    {
        [self decreaseHealth];
    }
    else if(self.health == 0)
    {
        [self destroyBlock];
    }
    return NO;
}

-(void) destroyBlock
{
    BoardLayer *board = (BoardLayer *)self.parent;
    board.isTouchEnabled = NO;
    //[board snapMovingBlocks];
    [board removeBlock: self];
    board.isTouchEnabled = YES;
    
}


@end
