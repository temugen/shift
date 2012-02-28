//
//  MainMenu.m
//  shift
//
//  Created by Greg McLain on 2/14/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "MainMenu.h"
#import "SinglePlayerMenu.h"
#import "MultiplayerMenu.h"
#import "DifficultyMenu.h"
#import "OptionsMenu.h"
#import "AchievementsMenu.h"
#import "GameCenterHub.h"

@implementation MainMenu

//Initialize the Main Menu layer
-(id) init
{
    if( (self=[super init] )) {

        //Set up menu items
        CCMenuItemFont *quickplay = [CCMenuItemFont itemFromString:@"Quickplay" target:self selector: @selector(onQuickplay:)];
        CCMenuItemFont *single = [CCMenuItemFont itemFromString:@"Single Player" target:self selector: @selector(onSinglePlayer:)];
        CCMenuItemFont *multi = [CCMenuItemFont itemFromString:@"Multiplayer" target:self selector: @selector(onMultiplayer:)];
        CCMenuItemFont *options = [CCMenuItemFont itemFromString:@"Options" target:self selector: @selector(onOptions:)];
        CCMenuItemFont *achievements= [CCMenuItemFont itemFromString:@"Achievements" target:self selector: @selector(onAchievements:)];

        //Add items to menu
        CCMenu *menu = [CCMenu menuWithItems: quickplay, single, multi, options, achievements, nil];
        
        [menu alignItemsVertically];

        //Add menu to main menu layer
        [self addChild: menu];
        
    }
    return self;
}

//Create scene with main menu
+(id) scene
{
    MainMenu *layer = [MainMenu node];
    return [super scene:layer];
}

/* Callback functions for main menu items */

- (void) onQuickplay: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:TRANS_TIME scene:[DifficultyMenu scene:QUICKPLAY]]];
}

- (void) onSinglePlayer: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:TRANS_TIME scene:[SinglePlayerMenu scene]]];
}

- (void) onMultiplayer: (id) sender
{
  if ([GameCenterHub sharedInstance].gameCenterAvailable) 
  { 
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:TRANS_TIME scene:[MultiplayerMenu scene]]];
  }
  else
  {
    [[[UIAlertView alloc] initWithTitle:@"GameCenter Error" message:@"GameCenter is required to use any of the multiplayer features" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
  }
}

- (void) onOptions: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:TRANS_TIME scene:[OptionsMenu scene]]];
}

- (void) onAchievements: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:TRANS_TIME scene:[AchievementsMenu scene]]];
}


-(void) dealloc
{
	[super dealloc];
}

@end
