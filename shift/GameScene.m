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
        
        startTime = [NSDate date];
        elapsedTime = 0;
        inGame = YES;
    }
    
    return self;
}

-(NSTimeInterval) getElapsedTime
{
    if (inGame) {
        return elapsedTime + -[startTime timeIntervalSinceNow];
    }
    else {
        return elapsedTime;
    }
}

-(void) onNextGame
{
    elapsedTime = 0;
    startTime = [NSDate date];
    inGame = YES;
}

-(void) onGameEnd
{
    inGame = NO;
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPlayButtonPressed:)
                                                 name:@"PlayButtonPressed"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPlayButtonPressed:)
                                                 name:@"NextGameButtonPressed"
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
    elapsedTime = 0;
    startTime = [NSDate date];
    [board reset];
}

-(void) onPlayButtonPressed:(NSNotification *)notification
{
    startTime = [NSDate date];
    inGame = YES;
}

-(void) onNextGameButtonPressed:(NSNotification *)notification
{
    [self onNextGame];
}

-(void) onPauseButtonPressed:(NSNotification *)notification menu:(InGameMenu*)menu
{
    elapsedTime = self.elapsedTime;
    inGame = NO;
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    CCLabelTTF *moveCount = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d Moves", board.moveCount]
                                               fontName:@"Copperplate-Light" fontSize:platformFontSize];
    moveCount.color = ccBLACK;
    [moveCount addStrokeWithSize:1 color:ccWHITE];
    moveCount.position = ccp(moveCount.contentSize.width / 2 + platformPadding, screenSize.height - moveCount.contentSize.height / 2 - platformPadding);
    [menu addChild:moveCount];
    
    int minutes = self.elapsedTime / 60;
    int seconds = round(self.elapsedTime - minutes * 60);
    CCLabelTTF *time = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d:%02d", minutes, seconds]
                                          fontName:@"Copperplate-Light" fontSize:platformFontSize];
    time.color = ccBLACK;
    [time addStrokeWithSize:1 color:ccWHITE];
    time.position = ccp(screenSize.width - time.contentSize.width / 2 - platformPadding, screenSize.height - time.contentSize.height / 2 - platformPadding);
    [menu addChild:time];
    
    [self addChild:menu z:10];
    [self onPause];
}

@end
