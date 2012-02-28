//
//  GoalSprite.m
//  shift
//
//  Created by Brad Misik on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GoalSprite.h"

@implementation GoalSprite

-(id) initWithName:(NSString *)color
{
    if ((self = [super initWithFilename:[NSString stringWithFormat:@"goal_%@.png", color]])) {
        name = color;
    }
    return self;
}

+(id) goalWithName:(NSString *)name
{
    return [[[self alloc] initWithName:name] autorelease];
}

@end
