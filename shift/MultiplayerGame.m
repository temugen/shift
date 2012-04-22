//
//  MultiplayerGame.m
//  shift
//
//  Created by Alex Chesebro on 4/2/12.
//  Copyright (c) 2012 __Oh_Shift__. All rights reserved.
//

#import "MultiplayerGameMenu.h"
#import "MultiplayerGame.h"
#import "GameCenterHub.h"
#import <GameKit/GameKit.h>

@implementation MultiplayerGame

@synthesize myMatch;

+(MultiplayerGame*) gameWithNumberOfRows:(int)rows columns:(int)columns match:(GKTurnBasedMatch*)match;
{
  MultiplayerGame* newGame = [[MultiplayerGame alloc] initWithNumberOfRows:rows columns:columns match:match];
  NSDictionary* boardLayout = [newGame.board serialize];
  [[GameCenterHub sharedHub]sendStartBoard:boardLayout andMatch:match];
  
  return newGame;
}


+(MultiplayerGame*) gameWithMatchData:(GKTurnBasedMatch*)match
{
  MultiplayerGame* newGame = [[MultiplayerGame alloc] initWithMatchData:match];
  return newGame;
}


-(id) initWithMatchData:(GKTurnBasedMatch*) match
{
  if ((self = [super init]))
  {
    NSDictionary* matchInfo = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
    NSString* playerid = [GKLocalPlayer localPlayer].playerID;
    NSDictionary* playerBoard;
    int currMoveCount;
    
    if ([[matchInfo objectForKey:@"player1"] objectForKey:@"id"] == playerid)
    {
      playerBoard = [[matchInfo objectForKey:@"player1"] objectForKey:@"board"];
      currMoveCount = [[[matchInfo objectForKey:@"player1"] objectForKey:@"moves"] intValue];
    }
    else
    {
      playerBoard = [[matchInfo objectForKey:@"player2"] objectForKey:@"board"];
      currMoveCount = [[[matchInfo objectForKey:@"player2"] objectForKey:@"moves"] intValue];
    }
    
    board = [[BoardLayer alloc] initWithDictionary:[playerBoard objectForKey:@"board"] cellSize:cellSize];
    board.position = boardCenter;
    
    if ([board isComplete])
    {
      board.isTouchEnabled = NO;
      board.moveCount = currMoveCount;
    }
    
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
    [self addChild:board];
  }
  return self;
}


-(void) onGameStart
{
  [super onGameStart];
}

-(void) onGameEnd
{
  [super onGameEnd];
  // TODO:   Only if it is your turn
  [self updateAndSendMatchData];
}


-(void) updateAndSendMatchData
{
  NSDictionary* matchInfo = [NSKeyedUnarchiver unarchiveObjectWithData:myMatch.matchData];
  NSString* player1 = [[matchInfo objectForKey:@"player1"] objectForKey:@"id"];
  
  NSDictionary* endMatchDict;
  // FIXME:  Get real playerid
  NSString* me = [GKLocalPlayer localPlayer].playerID;
  int state = [[matchInfo objectForKey:@"state"] intValue];
  
  if (player1 == me)
  {
    NSDictionary* newp1 = [NSDictionary dictionaryWithObjectsAndKeys:
                   me, @"id",
                   [NSNumber numberWithInt:board.moveCount], @"moves",
                   [board serialize], @"board",
                   [NSDate dateWithTimeInterval:elapsedTime sinceDate:startTime], @"time",
                   nil];
    endMatchDict = [NSDictionary dictionaryWithObjectsAndKeys:
                   [NSNumber numberWithInt:state + 1], @"state",
                   newp1, @"player1",
                   [matchInfo objectForKey:@"player2"], @"player2",
                   nil];
  }
  else
  {
    NSDictionary* newp2 = [NSDictionary dictionaryWithObjectsAndKeys:
                   me, @"id",
                   [NSNumber numberWithInt:board.moveCount], @"moves",
                   [board serialize], @"board",
                   [NSDate dateWithTimeInterval:elapsedTime sinceDate:startTime], @"time",
                   nil];
    endMatchDict = [NSDictionary dictionaryWithObjectsAndKeys:
                   [NSNumber numberWithInt:state + 1], @"state",
                   [matchInfo objectForKey:@"player1"], @"player1",
                   newp2, @"player2",
                   nil];
  }
  
  NSData* endData = [NSKeyedArchiver archivedDataWithRootObject:endMatchDict];
  
  [[GameCenterHub sharedHub] sendTurn:self data:endData]; 
  NSLog(@"Current match has ended!");

}


-(void) onPauseButtonPressed:(NSNotification *)notification
{
  MultiplayerGameMenu *menu = [[MultiplayerGameMenu alloc] init];
  [super onPauseButtonPressed:notification menu:menu];
}

@end
