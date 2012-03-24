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
    if ((self = [super initWithFilename:[NSString stringWithFormat:@"block.png", color]])) {
        name = color;
        const ccColor3B *ccColor = [[colors objectForKey:color] bytes];
        [self setColor:*ccColor];
    }
    return self;
}

+(id) blockWithName:(NSString *)name
{
    return [[[self class] alloc] initWithName:name];
}

@end
