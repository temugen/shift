//
//  TutorialLayer.m
//  shift
//
//  Created by Brad Misik on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tutorial.h"
#import "CellSprite.h"

@implementation Tutorial

-(id) init
{
    if ((self = [super init])) {
        tutorialsLookup = [NSMutableDictionary dictionary];
        tutorials = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onNewTutorial:)
                                                     name:@"NewTutorial"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onTutorialComplete:)
                                                     name:@"TutorialComplete"
                                                   object:nil];
    }
    return self;
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) onNewTutorial:(NSNotification *)notification
{
    CellSprite *cell = [[notification userInfo] valueForKey:@"cell"];
    [tutorials addObject:[notification userInfo]];
    [tutorialsLookup setObject:[NSNumber numberWithInt:[tutorials count] - 1] forKey:cell];
}

-(void) onTutorialComplete:(NSNotification *)notification
{
    CellSprite *cell = [notification object];
    NSNumber *index = [tutorialsLookup objectForKey:cell];
    [tutorials removeObjectAtIndex:[index intValue]];
    [tutorialsLookup removeObjectForKey:cell];
}

@end
