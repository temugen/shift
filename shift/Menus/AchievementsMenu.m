//
//  AchievementsMenu.m
//  shift
//
//  Created by Greg McLain on 2/19/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "AchievementsMenu.h"
#import "GameCenterHub.h"

@implementation AchievementsMenu

-(id) init
{
    if( (self=[super init] )) {

      CCMenuItemFont* earned = [CCMenuItemFont itemFromString:@"Earned Achievements" target:self selector: @selector(onEarned:)];
      CCMenuItemFont* available = [CCMenuItemFont itemFromString:@"Available Achievements" target:self selector: @selector(onAvailable:)];
      CCMenuItemFont* reset = [CCMenuItemFont itemFromString:@"Reset Achievements" target:self selector: @selector(onReset:)];
      CCMenuItemFont* back = [CCMenuItemFont itemFromString:@"Back" target:self selector: @selector(goBack:)]; 
      
        
      //Add items to menu
      CCMenu *menu = [CCMenu menuWithItems: earned, available, reset, back, nil];
      
      [menu alignItemsVertically];
      [self addChild: menu];        
    }
    return self;
}


// Callback functions for achievements menu

- (void) onEarned: (id) sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
  if (![GameCenterHub sharedInstance].gameCenterAvailable)
  {
    [[GameCenterHub sharedInstance] noGameCenterNotification:@"Game Center is required to view your achievements"]; 
    return;
  }
  [[GameCenterHub sharedInstance] showAchievements];
}

- (void) onAvailable: (id) sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
  if (![GameCenterHub sharedInstance].gameCenterAvailable) return;
}

- (void) onReset: (id) sender
{
  //Play menu selection sound
  [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
  
  if (![GameCenterHub sharedInstance].gameCenterAvailable)
  {
    [[GameCenterHub sharedInstance] noGameCenterNotification:@"Game Center is required to use any of the achievement features"]; 
    return;
  }   
  [[GameCenterHub sharedInstance] resetAchievements];
  [[GameCenterHub sharedInstance] saveAchievements];
}

@end
