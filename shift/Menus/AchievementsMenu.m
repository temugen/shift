//
//  AchievementsMenu.m
//  shift
//
//  Created by Greg McLain on 2/19/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "AchievementsMenu.h"
#import "GameCenterHub.h"
#import "ButtonList.h"

@implementation AchievementsMenu

-(id) init
{
    if ((self = [super init])) {
      
      CGSize screenSize = [[CCDirector sharedDirector] winSize];
      ButtonList* buttons = [ButtonList buttonList];
      
      [buttons addButtonWithDescription:@"View Achievements" target:self selector: @selector(onView:)];
      [buttons addButtonWithDescription:@"Reset Achievements" target:self selector: @selector(onReset:)];
      
      buttons.position = ccp(screenSize.width / 2, screenSize.height / 2);
      [self addChild:buttons];
      [self addBackButton];
      
    }
    return self;
}


// Callback functions for achievements menu

- (void) onView: (id) sender
{
  [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
  
  if (![GameCenterHub sharedHub].gameCenterAvailable || ![GameCenterHub sharedHub].userAuthenticated)
  {
    [[GameCenterHub sharedHub] displayGameCenterNotification:@"Must be logged into GameCenter to use this"];
    return;
  }
  
  [[GameCenterHub sharedHub] showAchievements];
}

- (void) onReset: (id) sender
{
  [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
  
  if (![GameCenterHub sharedHub].gameCenterAvailable || ![GameCenterHub sharedHub].userAuthenticated)
  {
    [[GameCenterHub sharedHub] displayGameCenterNotification:@"Must be logged into GameCenter to use this"];
    return;
  }
  
  [[GameCenterHub sharedHub] resetAchievements];
  [[GameCenterHub sharedHub] saveAchievements];
}

@end
