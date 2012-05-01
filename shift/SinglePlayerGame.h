//
//  SinglePlayerGame.h
//  shift
//
//  Created by Brad Misik on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "TutorialLayer.h"

@interface SinglePlayerGame : GameScene
{
    int currentLevel;
    TutorialLayer *tutorials;
}

+(SinglePlayerGame *) gameWithLevel:(int)level;
+(SinglePlayerGame *) lastGame;

-(id) initWithLevel:(int)level;

@end
