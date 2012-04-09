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

+(MultiplayerGame*) gameWithNumberOfRows:(int)rows columns:(int)columns match:(GKTurnBasedMatch*)match;
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
                                              cellSize:cellSize];
    board.position = boardCenter;
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
  NSLog(@"Current match has ended!");
  NSString* stringdata = @"Testing send";
  NSData* data = [stringdata dataUsingEncoding:NSUTF8StringEncoding];
  [[GameCenterHub sharedInstance] sendTurn:self data:data];
}

@end
