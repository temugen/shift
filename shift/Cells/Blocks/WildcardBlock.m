//
//  WildcardBlock.m
//  shift
//
//  Created by Jicong Wang on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WildcardBlock.h"
#import "BoardLayer.h"
#import "UniversalConstants.h"

@implementation WildcardBlock

+(id) blockWithName:(NSString *)name
{
    NSString *filename = [NSString stringWithFormat:@"block_wild.png"];
    WildcardBlock *block = [self cellWithFilename:filename];
    block.comparable = YES;
    block.movable = YES;
    block.name = name;
    return block;
}

-(BOOL) onDoubleTap
{
    int rand = arc4random_uniform(6);
    NSString* const rand_color = [colors objectAtIndex:rand];
    NSString *filename = [NSString stringWithFormat:@"block_%@.png",rand_color];
    [self setTexture:[[CCTextureCache sharedTextureCache] addImage:filename]];
    
    return NO;
}

@end
