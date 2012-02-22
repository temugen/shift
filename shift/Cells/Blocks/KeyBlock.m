//
//  KeyBlock.m
//  shift
//
//  Created by Greg McLain on 2/21/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "KeyBlock.h"
#import "BoardLayer.h"

@implementation KeyBlock

+(id) blockWithName:(NSString *)name
{
    NSString *filename = [NSString stringWithFormat:@"block_green.png"];
    KeyBlock *block = [self cellWithFilename:filename];
    block.comparable = NO;
    block.movable = YES;
    block.name = name;
    return block;
}

-(BOOL) onCollideWithCell:(CellSprite *)cell force:(float)force
{
    if([cell.name isEqualToString:@"red_lock"])
    {
        [self removeKey];
    }
    return NO;
}

-(void) removeKey
{
    BoardLayer *board = (BoardLayer *)self.parent;
    board.isTouchEnabled = NO;
    //[board snapMovingBlocks];
    [board removeBlock: self];
    board.isTouchEnabled = YES;

}

@end
