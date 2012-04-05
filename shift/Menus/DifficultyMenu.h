//
//  DifficultyMenu.h
//  shift
//
//  Created by Greg McLain on 2/16/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "cocos2d.h"
#import "Menu.h"
#import "GameKit/GameKit.h"

@interface DifficultyMenu : Menu
{
  gamemode mode;
  GKTurnBasedMatch* match;
}

-(id) initWithMode:(gamemode) gameSelection;
+(id) sceneWithMode:(gamemode) gameSelection;

-(id) initWithMatch:(GKTurnBasedMatch*) match;
+(id) sceneWithMatch:(GKTurnBasedMatch*) match;

@end
