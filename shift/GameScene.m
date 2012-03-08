//
//  GameScene.m
//  shift
//
//  Created by Brad Misik on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(id) init
{
    if ((self = [super init])) {
        //Add Control Layer (Reset, Menu)
        cLayer = [[ControlLayer alloc] init];
        [self addChild:cLayer];
        
        //Set cell size for platform
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        GoalSprite *sampleGoal = [GoalSprite goalWithName:@"red"];
        float sampleSize = CGRectGetWidth([sampleGoal boundingBox]);
        float requestedCellSize = MIN(sampleSize, screenSize.height / kDifficultyHard);
        cellSize = CGSizeMake(requestedCellSize, requestedCellSize);
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onBoardComplete:)
                                                     name:@"BoardComplete"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onResetButtonPressed:)
                                                     name:@"ResetButtonPressed"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onMenuButtonPressed:)
                                                     name:@"MenuButtonPressed"
                                                   object:nil];
    }
    
    return self;
}

-(void) onBoardComplete:(NSNotification *)notification
{
}

-(void) onResetButtonPressed:(NSNotification *)notification
{
    NSLog(@"Reset Button Pressed");
    [board resetBoard];
}

-(void) onMenuButtonPressed:(NSNotification *)notification
{
    // TODO: Display menu
    NSLog(@"Menu Button Pressed");
}

@end
