//
//  BlockSprite.m
//  shift
//
//  Created by Brad Misik on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BlockSprite.h"

@implementation BlockSprite

-(id) initWithName:(NSString *)color
{
    NSString *filename = [NSString stringWithFormat:@"block_%@.png", color];
    if ((self = [super initWithFilename:filename])) {
        name = color;
    }
    return self;
}

+(id) blockWithName:(NSString *)name
{
    return [[[self alloc] initWithName:name] autorelease];
}

@end
