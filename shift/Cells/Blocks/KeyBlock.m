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
#import "BlockTrain.h"

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
    [self completeTutorial];
    return YES;
}

@end
