//
//  MultiplayerTypeMenu.h
//  shift
//
//  Created by Brad Misik on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Menu.h"
#import "GameKit/GameKit.h"

@interface MultiplayerTypeMenu : Menu
{
    GKTurnBasedMatch* match;
}

-(id) initWithMatch:(GKTurnBasedMatch*) match;

+(id) sceneWithMatch:(GKTurnBasedMatch*) match;

@end
