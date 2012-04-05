//
//  MultiplayerGame.m
//  shift
//
//  Created by Alex Chesebro on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MultiplayerGame.h"
#import "GameCenterHub.h"

@implementation MultiplayerGame

@synthesize myMatch;

+(MultiplayerGame *) gameWithNumberOfRows:(int)rows columns:(int)columns match:(GKTurnBasedMatch*)match;
{
  return [[MultiplayerGame alloc] initWithNumberOfRows:rows columns:columns match:match];
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
                                                center:boardCenter
                                              cellSize:cellSize];
    myMatch = match;
    [self addChild:board];
  }
  return self;
}


-(void) onGameStart
{
  //Your stuff here
  [super onGameStart];
}

-(void) onGameEnd
{
  [super onGameEnd];
  NSLog(@"matchmaking match has ended!");
  [[GameCenterHub sharedInstance] takeTurn:myMatch];
}

@end
