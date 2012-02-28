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

-(id) initWithName:(NSString *)blockName
{
    NSString *filename = [NSString stringWithFormat:@"block_wild.png"];
    if ((self = [super initWithFilename:filename])) {
        comparable = YES;
        movable = YES;
        name = name;
    }
    return self;
}

-(BOOL) onDoubleTap
{
    int rand = arc4random_uniform(6);
    NSString* const rand_color = colors[rand];
    NSString *filename = [NSString stringWithFormat:@"block_%@.png",rand_color];
    [self setTexture:[[CCTextureCache sharedTextureCache] addImage:filename]];
    [self setName:rand_color];
    return NO;
}

@end
