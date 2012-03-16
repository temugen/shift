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
    if ((self = [super initWithFilename:[NSString stringWithFormat:@"goal.png", color]])) {
        name = color;
        const ccColor3B *ccColor = [[colors objectForKey:color] bytes];
        [self setColor:*ccColor];
    }
    return self;
}

+(id) goalWithName:(NSString *)name
{
    return [[self alloc] initWithName:name];
}

@end
