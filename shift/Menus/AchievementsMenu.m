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

      CCMenuItemFont *earned = [CCMenuItemFont itemFromString:@"Earned Achievements" target:self selector: @selector(onEarned:)];
      CCMenuItemFont *available = [CCMenuItemFont itemFromString:@"Available Achievements" target:self selector: @selector(onAvailable:)];
      CCMenuItemFont *reset = [CCMenuItemFont itemFromString:@"Reset Achievements" target:self selector: @selector(onReset:)];
      CCMenuItemFont *back = [CCMenuItemFont itemFromString:@"Back" target:self selector: @selector(goBack:)]; 
      
        
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
  if ([GameCenterHub sharedInstance].gameCenterAvailable) 
  {
    [[GameCenterHub sharedInstance] showAchievements];
  }
  else
  {
     // Load local cache
  }
}

- (void) onAvailable: (id) sender
{
  if ([GameCenterHub sharedInstance].gameCenterAvailable) 
  {
    // TODO implement achievements and cache
  }
  else
  {
      // Show local cache
  }
}

- (void) onReset: (id) sender
{
  if ([GameCenterHub sharedInstance].gameCenterAvailable) 
  {
    [[GameCenterHub sharedInstance] resetAchievements];
    
    // TODO:  Clear local cache too!
  }
}

@end
