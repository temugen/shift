//
//  BlockSprite.m
//  shift
//
//  Created by Brad Misik on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BlockSprite.h"

@implementation BlockSprite

+(id) blockWithName:(NSString *)name
{
    NSString *filename = [NSString stringWithFormat:@"block_%@.png", name];
    BlockSprite *block = [self cellWithFilename:filename];
    block.name = name;
    return block;
}

@end
