//
//  GoalSprite.m
//  shift
//
//  Created by Brad Misik on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GoalSprite.h"

@implementation GoalSprite

+(id) goalWithName:(NSString *)name
{
    NSString *filename = [NSString stringWithFormat:@"goal_%@.png", name];
    GoalSprite *goal = [self cellWithFilename:filename];
    goal.name = name;
    goal.movable = NO;
    return goal;
}

@end
