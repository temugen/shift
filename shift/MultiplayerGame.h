//
//  MultiplayerGame.h
//  shift
//
//  Created by Alex Chesebro on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameScene.h"
#import <GameKit/GameKit.h>

@interface MultiplayerGame : GameScene
{
  int rowCount, columnCount;
  GKTurnBasedMatch* myMatch;
}

+(MultiplayerGame*) gameWithNumberOfRows:(int)rows columns:(int)columns match:(GKTurnBasedMatch*) match;
-(id) initWithNumberOfRows:(int)rows columns:(int)columns match:(GKTurnBasedMatch*) match;

@property (strong, atomic) GKTurnBasedMatch* myMatch;

@end
