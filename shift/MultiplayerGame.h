//
//  MultiplayerGame.h
//  shift
//
//  Created by Alex Chesebro on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameScene.h"

@interface MultiplayerGame : GameScene
{
  int rowCount, columnCount;
}

+(MultiplayerGame*) lastGame;
+(MultiplayerGame*) gameWithNumberOfRows:(int)rows columns:(int)columns;

-(id) initWithNumberOfRows:(int)rows columns:(int)columns;

@end
