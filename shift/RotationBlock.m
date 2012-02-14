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
    block.moveable = NO;
    return block;
}

-(BOOL) onClick
{
    /*BlockSprite *top, *bottom;
    top = [self.board blockAtX:self.column y:self.row + 1];
    bottom = [board blockAtX:self.column y:self.row - 1];
    [board setBlock:bottom x:self.column y:self.row + 1];
    [board setBlock:top x:self.column y:self.row - 1];*/
    return NO;
}

@end
