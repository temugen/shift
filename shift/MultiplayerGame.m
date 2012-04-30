//
//  MultiplayerGame.m
//  shift
//
//  Created by Alex Chesebro on 4/2/12.
//  Copyright (c) 2012 __Oh_Shift__. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "MultiplayerGameMenu.h"
#import "MultiplayerGame.h"
#import "OhShiftMatchData.h"
#import "GameCenterHub.h"
#import "MainMenu.h"
#import "NextGameMenu.h"


@implementation MultiplayerGame

@synthesize myMatch;
@synthesize myTurn;

+(MultiplayerGame*) gameWithDifficulty:(NSString*)difficulty match:(GKTurnBasedMatch*)match;
{
  int boardSize;
  if ([difficulty isEqualToString:@"Easy"])
  {
    boardSize = kDifficultyEasy;
  }
  else if ([difficulty isEqualToString:@"Medium"])
  {
    boardSize = kDifficultyMedium;  
  }
  else
  {
    boardSize = kDifficultyHard;
  }
  
  MultiplayerGame* newGame = [[MultiplayerGame alloc] initWithNumberOfRows:boardSize columns:boardSize match:match];
  NSDictionary* boardLayout = [newGame.board serialize];
  [[GameCenterHub sharedHub] sendStartBoard:boardLayout match:match withDifficulty:difficulty];
  return newGame;
}


+(MultiplayerGame*) gameWithMatchData:(GKTurnBasedMatch*)match andIsMyTurn:(BOOL)mine
{
  MultiplayerGame* newGame = [[MultiplayerGame alloc] initWithMatchData:match andIsMyTurn:mine];
  return newGame;
}


-(id) initWithMatchData:(GKTurnBasedMatch*)match andIsMyTurn:(BOOL)mine
{
  if ((self = [super init]))
  {
    OhShiftMatchData* matchInfo = [[OhShiftMatchData alloc] initWithData:match.matchData];
    NSString* me = [GKLocalPlayer localPlayer].playerID;
    NSString* player1 = matchInfo.p1id;
    NSDictionary* playerBoard;
    int currMoveCount;
    
    if ([me isEqualToString:player1])
    {
      playerBoard = matchInfo.p1board;
      currMoveCount = matchInfo.p1moves;
    }
    else
    {
      playerBoard = matchInfo.p2board;
      currMoveCount = matchInfo.p2moves;
    }
    
    board = [[BoardLayer alloc] initWithDictionary:[playerBoard objectForKey:@"board"] cellSize:cellSize];
    board.position = boardCenter;
    
    if ([board isComplete])
    {
      board.isTouchEnabled = NO;
      board.moveCount = currMoveCount;
    }
    
    myTurn = mine;
    myMatch = match;
    [self addChild:board];
  }
  return self;
}


-(id) initWithNumberOfRows:(int)rows columns:(int)columns match:(GKTurnBasedMatch*) match
{
  if ((self = [super init])) 
  {
    rowCount = rows;
    columnCount = columns;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    boardCenter = CGPointMake((screenSize.width / 2), (screenSize.height / 2));
    board = [BoardLayer randomBoardWithNumberOfColumns:columnCount
                                                  rows:rowCount
                                              cellSize:cellSize];
    
    board.position = boardCenter;
    myMatch = match;
    myTurn = YES;
    [self addChild:board];
  }
  return self;
}


-(void) onGameEnd
{
  [super onGameEnd];
  
  if (myTurn)
  {
    [self updateAndSendMatchData];
    board.isTouchEnabled = NO;
  }
  else
  {
    [self saveResults];
    board.isTouchEnabled = NO;
  }
    
    NextGameMenu *nextMenu = [[NextGameMenu alloc] initWithMessage:@"Waiting for Opponent..." time:self.elapsedTime moves:board.moveCount];
    [self addChild:nextMenu z:10];
}

-(void) onNextGame
{
    [[CCDirector sharedDirector] replaceSceneAndCleanup:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[MainMenu scene]]];
    [super onNextGame];
}


-(void) updateAndSendMatchData
{
  OhShiftMatchData* matchInfo = [[OhShiftMatchData alloc] initWithData:myMatch.matchData];
  NSString* player1 = matchInfo.p1id;
  NSString* me = [GKLocalPlayer localPlayer].playerID;
  
  if ([me isEqualToString:player1])
  {
    [matchInfo updatePlayerOneWithBoard:[board serialize] 
                                    pid:me 
                                  moves:board.moveCount 
                           andTimeTaken:self.elapsedTime];
    [[GameCenterHub sharedHub] sendTurn:self data:[matchInfo getDataForGameCenter]];
  }
  else
  {
    [matchInfo updatePlayerTwoWithBoard:[board serialize] 
                                    pid:me 
                                  moves:board.moveCount 
                           andTimeTaken:self.elapsedTime];
    [[GameCenterHub sharedHub] sendResultsForMatch:myMatch withData:[matchInfo getDataForGameCenter]];
  } 
}


-(void) saveResults
{
  NSDictionary* matchResults = [NSDictionary dictionaryWithObjectsAndKeys:
                               [board serialize], @"board",
                               [GKLocalPlayer localPlayer].playerID, @"id",
                               [NSNumber numberWithInt:board.moveCount], @"moves",
                               [NSNumber numberWithDouble:self.elapsedTime], @"time",
                               nil];
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* documentsDirectory = [paths objectAtIndex:0];
  NSString* scorePath = [documentsDirectory stringByAppendingPathComponent:myMatch.matchID];
  [NSKeyedArchiver archiveRootObject:matchResults toFile:scorePath];
}


-(void) onPause
{
    MultiplayerGameMenu *menu = [[MultiplayerGameMenu alloc] init];
    [self displayPauseMenu:menu];
    [super onPause];
}

@end
