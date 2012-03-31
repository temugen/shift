//
//  GameScene.m
//  shift
//
//  Created by Brad Misik on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

#define kBufferSpace 20

@implementation GameScene

@synthesize elapsedTime;

-(id) init
{
    if ((self = [super init])) {
        //Add Background Layer
        GameBackgroundLayer *background = [[GameBackgroundLayer alloc] init];
        [self addChild:background z:-1];
        
        //Add Control Layer (Reset, Menu)
        ControlLayer *controls = [[ControlLayer alloc] init];
        [self addChild:controls z:1];
        
        //Set cell size for platform
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        GoalSprite *sampleGoal = [GoalSprite goalWithName:@"red"];
        float sampleSize = CGRectGetWidth([sampleGoal boundingBox]);
        float requestedCellSize = MIN(sampleSize, (screenSize.height - kBufferSpace) / kDifficultyHard);
        cellSize = CGSizeMake(requestedCellSize, requestedCellSize);
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onBoardComplete:)
                                                     name:@"BoardComplete"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onResetButtonPressed:)
                                                     name:@"ResetButtonPressed"
                                                   object:nil];
    }
    
    return self;
}

-(NSTimeInterval) getElapsedTime
{
    if (inGame)
        return [startTime timeIntervalSinceNow];
    else
        return elapsedTime;
}

-(void) onNextGame
{

}

-(void) onGameStart
{
    startTime = [NSDate date];
    inGame = YES;
}

-(void) onGameEnd
{
    inGame = NO;
    elapsedTime = [startTime timeIntervalSinceNow];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) onBoardComplete:(NSNotification *)notification
{
    [self onGameEnd];
    [self onNextGame];
    [self onGameStart];
}

-(void) onResetButtonPressed:(NSNotification *)notification
{
    NSLog(@"Reset Button Pressed");
    [board reset];
}

@end

@implementation GameBackgroundLayer

@synthesize texture;

-(id) init
{
    if ((self = [super init])) {
        ccTexParams params = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
        texture = [[CCTextureCache sharedTextureCache] addImage:@"background.png"];
        [texture setTexParameters:&params];
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithTexture:texture
                                                      rect:CGRectMake(0, 0, screenSize.width, screenSize.height)];
        background.position = ccp(screenSize.width / 2, screenSize.height / 2);
        [self addChild:background];
    }
    
    return self;
}
@end
