//
//  MultiplayerGame.h
//  shift
//
//  Created by Alex Chesebro on 4/2/12.
//  Copyright (c) 2012 __Oh_Shift__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "GameScene.h"
#import "BoardLayer.h"

@interface MultiplayerGame : GameScene
{
  int rowCount, columnCount;
  NSString* myID;
  GKTurnBasedMatch* myMatch;
}

+(MultiplayerGame*) gameWithNumberOfRows:(int)rows columns:(int)columns match:(GKTurnBasedMatch*) match;
+(MultiplayerGame*) gameWithMatchData:(GKTurnBasedMatch*) match;
-(id) initWithNumberOfRows:(int)rows columns:(int)columns match:(GKTurnBasedMatch*) match;
-(id) initWithMatchData:(GKTurnBasedMatch*) match;
-(void) onPauseButtonPressed:(NSNotification *)notification;

@property (strong, atomic) GKTurnBasedMatch* myMatch;

@end
