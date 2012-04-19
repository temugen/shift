//
//  LeaderboardMenu.m
//  shift
//
//  Created by Alex Chesebro on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeaderboardMenu.h"
#import "GameCenterHub.h"
#import "MultiplayerMenu.h"
#import "MainMenu.h"

@implementation LeaderboardMenu


- (id) init
{
    if ((self=[super init])) {
        // Menu Items
        CCMenuItemFont* hardTime = [CCMenuItemFont itemFromString:@"Hard Times" target:self selector: @selector(onHardTimeSelection:)];
        CCMenuItemFont* hardMoves = [CCMenuItemFont itemFromString:@"Hard Moves" target:self selector: @selector(onHardMoves:)];
        
        // Set items
        CCMenu *menu = [CCMenu menuWithItems: hardTime, hardMoves, nil];
        
        [menu alignItemsVertically];
        
        [self addChild: menu]; 
        [self addBackButton];
    }
    return self;
}

- (void) onHardTimeSelection: (id) sender
{
  //Play menu selection sound
  [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
  
  if (![GameCenterHub sharedInstance].gameCenterAvailable) 
  {
    [[GameCenterHub sharedInstance] noGameCenterNotification:@"Game Center is required to view the leaderboard"]; 
    return;
  }
  
  [[GameCenterHub sharedInstance] showLeaderboard:@"hard_time"];
}

- (void) onHardMoves: (id) sender
{
  //Play menu selection sound
  [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
  
  if (![GameCenterHub sharedInstance].gameCenterAvailable)
  {
    [[GameCenterHub sharedInstance] noGameCenterNotification:@"Game Center is required to view any leaderboard"]; 
    return;
  }
  [[GameCenterHub sharedInstance] showLeaderboard:@"hard_moves"];
}

- (void) goBack: (id) sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:kSceneTransitionTime scene:[MultiplayerMenu scene]]];
}



@end
