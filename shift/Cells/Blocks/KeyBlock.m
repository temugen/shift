//
//  KeyBlock.m
//  shift
//
//  Created by Greg McLain on 2/21/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "KeyBlock.h"
#import "LockBlock.h"
#import "BoardLayer.h"

@implementation KeyBlock

-(id) initWithName:(NSString *)blockName
{
    if ((self = [super initWithFilename:@"block_key.png"])) {
        comparable = NO;
        movable = YES;
        name = blockName;
    }
    return self;
}

-(BOOL) onCollideWithCell:(CellSprite *)cell force:(float)force
{
    //Only remove the key if it collided with a LockBlock
    if([cell isKindOfClass:[LockBlock class]])
    {
        [self removeKey];
    }
    return NO;
}

-(void) removeKey
{
    BoardLayer *board = (BoardLayer *)self.parent;
    [board removeBlock: self];
}

@end
