//
//  LockBlock.m
//  shift
//
//  Created by Greg McLain on 2/21/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "LockBlock.h"

@implementation LockBlock

@synthesize locked;

+(id) blockWithName:(NSString *)name
{
    NSString *filename = [NSString stringWithFormat:@"block_red.png"];
    LockBlock *block = [self cellWithFilename:filename];
    block.comparable = YES;
    block.locked = YES;
    block.movable = NO;
    block.name = name;
    return block;
}

@end
