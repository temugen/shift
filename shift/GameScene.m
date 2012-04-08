//
//  GameScene.m
//  shift
//
//  Created by Brad Misik on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "InGameMenu.h"

@implementation GameScene

@synthesize elapsedTime;

-(id) init
{
    if ((self = [super init])) {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        boardCenter = ccp(screenSize.width / 2, screenSize.height / 2);
        cellSize = platformCellSize;
        
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@BGM_GAME];
        
        BackgroundLayer *background = [[BackgroundLayer alloc] init];
        [self addChild:background z:-1];
        
        ControlLayer *controls = [[ControlLayer alloc] init];
        controls.position = ccp(screenSize.width - controls.contentSize.width / 2 - platformBorderSpace,
                                screenSize.height - controls.contentSize.height / 2 - platformBorderSpace);
        [self addChild:controls z:1];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onBoardComplete:)
                                                     name:@"BoardComplete"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onResetButtonPressed:)
                                                     name:@"ResetButtonPressed"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onPauseButtonPressed:)
                                                     name:@"PauseButtonPressed"
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

-(void) onPause
{
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
    [board reset];
}

-(void) onPauseButtonPressed:(NSNotification *)notification
{
    InGameMenu *menu = [[InGameMenu alloc] init];
    [self addChild:menu z:10];
    [self onPause];
}

@end
