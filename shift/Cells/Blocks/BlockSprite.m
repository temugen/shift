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

-(void) dealloc
{
    //[name release];
    
    [super dealloc];
}

+(id) blockWithName:(NSString *)name
{
    return [[[[self class] alloc] initWithName:name] autorelease];
}

@end
