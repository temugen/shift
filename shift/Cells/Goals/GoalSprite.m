//
//  GoalSprite.m
//  shift
//
//  Created by Brad Misik on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GoalSprite.h"
#import "ColorPalette.h"

@implementation GoalSprite

-(id) initWithName:(NSString *)color
{
    if ((self = [super initWithFilename:[NSString stringWithFormat:@"goal.png", color]])) {
        name = color;
        [self setColor:[[ColorPalette sharedPalette] colorWithName:color]];
    }
    return self;
}

+(id) goalWithName:(NSString *)name
{
    return [[self alloc] initWithName:name];
}

@end
