//
//  Achievement.m
//  shift
//
//  Created by Jicong Wang on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Achievement.h"

@implementation Achievement

- (id) init
{
    if (self = [super init])
    {
        //keys will be the achievements list
        NSArray * keys      = [NSArray arrayWithObjects: @"achieve1", @"achieve2", @"achieve3", @"achieve4", nil];
        NSArray * values    = [NSArray arrayWithObjects: [NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], nil];
        achievements = [[NSMutableDictionary alloc] initWithObjects: values forKeys: keys];
    }
    return self;
}

-(void)dealloc{
    // [achievements release];
    // [super dealloc];
}

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
        [self setAchievements: (NSMutableDictionary *)[coder decodeObjectForKey:@"achievements"]];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject: achievements forKey:@"achievements"];
}

-(NSMutableDictionary*) getAchievements{
    return achievements;
}

-(void)setAchievements:(NSMutableDictionary*) other{
    if (achievements!=other){
        achievements = [[NSMutableDictionary alloc]initWithDictionary:other];
    }
}

@end
