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
#import "GameCenterHub.h"
#import "MainMenu.h"

@implementation MultiplayerGame

@synthesize myMatch;
@synthesize myTurn;

+(MultiplayerGame*) gameWithNumberOfRows:(int)rows columns:(int)columns match:(GKTurnBasedMatch*)match;
{
  MultiplayerGame* newGame = [[MultiplayerGame alloc] initWithNumberOfRows:rows columns:columns match:match];
  NSDictionary* boardLayout = [newGame.board serialize];
  [[GameCenterHub sharedHub]sendStartBoard:boardLayout andMatch:match];
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


-(void) onGameStart
{
  [super onGameStart];
}

-(void) onGameEnd
{
  [super onGameEnd];
  
  if (myTurn)
  {
    NSLog(@"Sending results becuz it's my turn");
    [self updateAndSendMatchData];
    board.isTouchEnabled = NO;
  }
  else
  {
    NSLog(@"Nacho turn so writing crap");
    [self saveResults];
    board.isTouchEnabled = NO;
  }
  // REMOVE WHEN WE HAVE A RESULTS SCREEEN!
  [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[MainMenu scene]]];
}


-(void) updateAndSendMatchData
{
  NSDictionary* matchInfo = [NSKeyedUnarchiver unarchiveObjectWithData:myMatch.matchData];
  NSString* player1 = [[matchInfo objectForKey:@"player1"] objectForKey:@"id"];
  NSString* me = [GKLocalPlayer localPlayer].playerID;
  NSDictionary* endMatchDict;
  
  if (player1 == me)
  {
    NSDictionary* p1 = [[GameCenterHub sharedHub] formatMatchDataWithBoard:[board serialize] 
                                                                    moves:board.moveCount 
                                                                     time:elapsedTime 
                                                                    andID:me];
    endMatchDict = [NSDictionary dictionaryWithObjectsAndKeys:
                   p1, @"player1",
                   [matchInfo objectForKey:@"player2"], @"player2",
                   nil];
  }
  else
  {
    NSDictionary* p2 = [[GameCenterHub sharedHub] formatMatchDataWithBoard:[board serialize] 
                                                                    moves:board.moveCount 
                                                                     time:elapsedTime 
                                                                    andID:me];
    endMatchDict = [NSDictionary dictionaryWithObjectsAndKeys:
                   [matchInfo objectForKey:@"player1"], @"player1",
                   p2, @"player2",
                   nil];
  }
  
  NSData* endData = [NSKeyedArchiver archivedDataWithRootObject:endMatchDict];
  [[GameCenterHub sharedHub] sendTurn:self data:endData];
}


-(void) saveResults
{
  NSDictionary* matchResults = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:board.moveCount], @"moves",
                                [NSNumber numberWithDouble:elapsedTime], @"time",
                                nil];
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* documentsDirectory = [paths objectAtIndex:0];
  NSString* scorePath = [documentsDirectory stringByAppendingPathComponent:myMatch.matchID];
  [NSKeyedArchiver archiveRootObject:matchResults toFile:scorePath];
}


-(void) onPauseButtonPressed:(NSNotification *)notification
{
  MultiplayerGameMenu *menu = [[MultiplayerGameMenu alloc] init];
  [super onPauseButtonPressed:notification menu:menu];
}

@end
