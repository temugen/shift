//
//  RotationBlock.m
//  shift
//
//  Created by Brad Misik on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RotationBlock.h"
#import "BoardLayer.h"

@implementation RotationBlock

+(id) block
{
    NSString *filename = [NSString stringWithFormat:@"block_rotate.png"];
    RotationBlock *block = [self cellWithFilename:filename];
    block.comparable = NO;
    block.movable = NO;
    block.name = @"rotate";
    return block;
}

-(BOOL) onTouch
{
    //Make room for all of the blocks surrounding the rotation block
    NSMutableArray *blocks = [NSMutableArray arrayWithCapacity:8];
    
    //Store the x positions in order clockwise
    NSMutableArray *xs = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:column - 1],
                          [NSNumber numberWithInt:column],
                          [NSNumber numberWithInt:column + 1],
                          [NSNumber numberWithInt:column + 1],
                          [NSNumber numberWithInt:column + 1],
                          [NSNumber numberWithInt:column],
                          [NSNumber numberWithInt:column - 1],
                          [NSNumber numberWithInt:column - 1], nil];
    
    //Store the y positions in order clockwise
    NSMutableArray *ys = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:row + 1],
                          [NSNumber numberWithInt:row + 1],
                          [NSNumber numberWithInt:row + 1],
                          [NSNumber numberWithInt:row],
                          [NSNumber numberWithInt:row - 1],
                          [NSNumber numberWithInt:row - 1],
                          [NSNumber numberWithInt:row - 1],
                          [NSNumber numberWithInt:row], nil];
    
    //Store the indices of all positions off the board
    NSMutableIndexSet *bad_indexes = [NSMutableIndexSet indexSet];
                
    for (int i = 0; i < [xs count]; i++) {
        NSNumber *xn = [xs objectAtIndex:i], *yn = [ys objectAtIndex:i];
        int x = [xn intValue], y = [yn intValue];
        if (x < 0 || y < 0 || x >= board.columnCount || y >= board.rowCount) {
            [bad_indexes addIndex:i];
            continue;
        }
        
        //We can't add nil to NSMutableArray
        BlockSprite *block = [board blockAtX:x y:y];
        if (block == nil) {
            [blocks addObject:[NSNull null]];
        }
        else {
            [blocks addObject:block];
        }
    }
    
    //Remove the positions off the board
    [xs removeObjectsAtIndexes:bad_indexes];
    [ys removeObjectsAtIndexes:bad_indexes];
    
    for (int i = 0; i < [xs count]; i++) {
        BlockSprite *block = [blocks objectAtIndex:i];
        if ([block isEqual:[NSNull null]]) {
            block = nil;
        }
        
        NSNumber *xn, *yn;
        int x, y;
        if (i == [blocks count] - 1) {
            xn = [xs objectAtIndex:0];
            yn = [ys objectAtIndex:0];
        }
        else
        {
            xn = [xs objectAtIndex:i + 1];
            yn = [ys objectAtIndex:i + 1];
        }
        x = [xn intValue];
        y = [yn intValue];
        
        block.column = x;
        block.row = y;
        [board setBlock:block x:x y:y];
    }
    
    return NO;
}

@end
