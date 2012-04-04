//
//  QuickPlayGame.m
//  shift
//
//  Created by Brad Misik on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickPlayGame.h"
#import "GameCenterHub.h"

@implementation QuickPlayGame

static QuickPlayGame *lastGame = nil;

+(QuickPlayGame *) gameWithNumberOfRows:(int)rows columns:(int)columns;
{
    return [[QuickPlayGame alloc] initWithNumberOfRows:rows columns:columns];
}

+(QuickPlayGame *) lastGame
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

-(void) onGameEnd
{
  [super onGameEnd];
  
  // Need to implement move counter so each file
  
  //Send score for leaderboard
  switch (rowCount)
  {
    case kDifficultyEasy:
//      [[GameCenterHub sharedInstance] submitScore:elapsedTime category:@"easy_time"];
      break;
    case kDifficultyMedium:
//      [[GameCenterHub sharedInstance] submitScore:elapsedTime category:@"medium_time"];
      break;
    case kDifficultyHard:
      [[GameCenterHub sharedInstance] submitScore:elapsedTime category:@"hard_time"];
      break;
  }
}

-(void) onNextGame
{
    [self removeChild:board cleanup:YES];
    
    board = [BoardLayer randomBoardWithNumberOfColumns:columnCount
                                                  rows:rowCount
                                                center:boardCenter
                                              cellSize:cellSize];
    [self addChild:board];
}

@end
