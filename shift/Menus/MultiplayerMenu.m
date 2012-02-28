//
//  MultiplayerMenu.m
//  shift
//
//  Created by Greg McLain on 2/16/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "MultiplayerMenu.h"
#import "MainMenu.h"
#import "DifficultyMenu.h"
#import "GameCenterHub.h"
#import "LeaderboardMenu.h"

@implementation MultiplayerMenu

//Initialize the Multiplayer Menu layer
-(id) init
{
    if ((self=[super init])) {
        
        //Set up menu items
        CCMenuItemFont *play = [CCMenuItemFont itemFromString:@"Find Opponent" target:self selector: @selector(onOppSelection:)];
        CCMenuItemFont *leaderboard= [CCMenuItemFont itemFromString:@"Leaderboard" target:self selector: @selector(onLeaderboard:)];  
        CCMenuItemFont *back = [CCMenuItemFont itemFromString:@"Back" target:self selector: @selector(goBack:)]; 

        [play setTag:FRIENDMULTI];
        [leaderboard setTag:LEADERBOARD];
      
        //Add items to menu
        CCMenu *menu = [CCMenu menuWithItems: play, leaderboard, back, nil];
        
        [menu alignItemsVertically];
        
        [self addChild: menu];        
    }
    return self;
}

//Create scene with multiplayer menu
+ (id) scene
{
    MultiplayerMenu *layer = [MultiplayerMenu node];
    return [super scene:layer];
}

/* Callback functions for menu items */

- (void) onOppSelection: (id) sender
{
  [[GameCenterHub sharedInstance] findRandomMatch];
}

- (void) onLeaderboard: (id) sender
{
  gamemode selection = [sender tag];
  [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:TRANS_TIME scene:[LeaderboardMenu scene:selection]]];
}


- (void) dealloc
{
	[super dealloc];
}

@end
