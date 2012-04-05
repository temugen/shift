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

static MultiplayerGame *lastGame = nil;


+(MultiplayerGame *) gameWithNumberOfRows:(int)rows columns:(int)columns;
{
  return [[MultiplayerGame alloc] initWithNumberOfRows:rows columns:columns];
}

+(MultiplayerGame *) lastGame
{
  return lastGame;
}

-(id) initWithNumberOfRows:(int)rows columns:(int)columns
{
  if ((self = [super init])) {
    rowCount = rows;
    columnCount = columns;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    boardCenter = CGPointMake((screenSize.width / 2), (screenSize.height / 2));
    board = [BoardLayer randomBoardWithNumberOfColumns:columnCount
                                                  rows:rowCount
                                                center:boardCenter
                                              cellSize:cellSize];
    [self addChild:board];
    
    lastGame = self;
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
}

@end
