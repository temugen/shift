//
//  GameScene.m
//  shift
//
//  Created by Brad Misik on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "QuickplayGameMenu.h"

@implementation GameScene

@synthesize elapsedTime;
@synthesize board;

-(id) init
{
    if ((self = [super init])) {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        boardCenter = ccp(screenSize.width / 2, screenSize.height / 2);
        cellSize = platformCellSize;
        
        //[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@BGM_GAME];
        
        BackgroundLayer *background = [[BackgroundLayer alloc] init];
        [self addChild:background z:-1];
        
        ControlLayer *controls = [[ControlLayer alloc] init];
        controls.position = ccp(screenSize.width - controls.contentSize.width / 2 - platformPadding,
                                screenSize.height - controls.contentSize.height / 2 - platformPadding);
        [self addChild:controls z:1];
        
    }
  [self onGameStart];
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
  elapsedTime = -[startTime timeIntervalSinceNow];
  NSLog(@"Time taken: %f", elapsedTime);
  NSLog(@"Moves taken: %d", board.moveCount);
}

-(void) onPause
{
}

-(void) onEnter
{
    [super onEnter];
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

-(void) onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super onExit];
}

-(void) onBoardComplete:(NSNotification *)notification
{
  [self onGameEnd];
  [self onNextGame];
}

-(void) onResetButtonPressed:(NSNotification *)notification
{
    [board reset];
}

-(void) onPauseButtonPressed:(NSNotification *)notification menu:(InGameMenu*)menu
{
    CCLabelTTF *moveCount = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Count : %d", board.moveCount]
                                               fontName:@"Helvetica" fontSize:24];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    moveCount.position = ccp(moveCount.contentSize.width / 2, screenSize.height - moveCount.contentSize.height / 2);
    [menu addChild:moveCount];
    [self addChild:menu z:10];
    [self onPause];
}

@end
