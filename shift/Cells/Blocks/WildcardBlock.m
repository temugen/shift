//
//  WildcardBlock.m
//  shift
//
//  Created by Jicong Wang on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WildcardBlock.h"

@implementation WildcardBlock

+(id) blockWithName:(NSString *)name
{
    NSString *filename = [NSString stringWithFormat:@"block_rotate.png"];
    WildcardBlock *block = [self cellWithFilename:filename];
    block.comparable = YES;
    block.movable = NO;
    block.name = name;
    return block;
}

-(BOOL) onTouch
{
    return NO;
}

@end
