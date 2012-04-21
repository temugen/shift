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
#import "buttonList.h"

@implementation LeaderboardMenu


- (id) init
{
    if ((self=[super init])) {
      
      CGSize screenSize = [[CCDirector sharedDirector] winSize];
      ButtonList* buttons = [ButtonList buttonList];
      
      [buttons addButtonWithDescription:@"Hard Times" target:self selector:@selector(onHardTimeSelection:)];
      [buttons addButtonWithDescription:@"Hard Moves" target:self selector:@selector(onHardMoves:)];
      
      buttons.position = ccp(screenSize.width / 2, screenSize.height / 2);
      [self addChild:buttons];
      [self addBackButton];
      
    }
    return self;
}

- (void) onHardTimeSelection: (id) sender
{
  [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
  
  [[GameCenterHub sharedHub] showLeaderboard:@"hard_time"];
}

- (void) onHardMoves: (id) sender
{
  [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
  
  [[GameCenterHub sharedHub] showLeaderboard:@"hard_moves"];
}

- (void) goBack: (id) sender
{
  [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    
  [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:kSceneTransitionTime scene:[MultiplayerMenu scene]]];
}



@end
