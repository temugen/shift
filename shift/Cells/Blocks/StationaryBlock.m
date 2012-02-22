//
//  StationaryBlock.m
//  shift
//
//  Created by Donghun Lee on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StationaryBlock.h"

@implementation StationaryBlock

+(id) blockWithName:(NSString *)name
{
    NSString *filename = [NSString stringWithFormat:@"block_stationary.png"];
    StationaryBlock *block = [self cellWithFilename:filename];
    block.comparable = NO;
    block.movable = NO;
    block.name = name;
    return block;
}

@end
