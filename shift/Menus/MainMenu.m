//
//  MainMenu.m
//  shift
//
//  Created by Greg McLain on 2/14/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "MainMenu.h"
#import "TitleLayer.h"
#import "SinglePlayerMenu.h"
#import "MultiplayerMenu.h"
#import "DifficultyMenu.h"
#import "OptionsMenu.h"
#import "AchievementsMenu.h"
#import "GameCenterHub.h"
#import "GoalSprite.h"
#import "BlockSprite.h"
#import "ColorPalette.h"
#import "RoundedRectangle.h"
#import "ButtonList.h"

#define TEXT_BLOCK_SIZE 35
#define TITLE_BORDER_SIZE 50

@implementation MainMenu

//Initialize the Main Menu layer
-(id) init
{
    if( (self=[super init] )) {
        //Play background music
        //[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@BGM_MENU];
        
        ButtonList *buttons = [ButtonList buttonList];
        [buttons addButtonWithDescription:@"Quickplay" target:self selector:@selector(onQuickplay:)
                             iconFilename:@"quickplay.png" colorString:@"green"];
        [buttons addButtonWithDescription:@"Single Player" target:self selector:@selector(onSinglePlayer:)
                             iconFilename:@"singleplayer.png" colorString:@"orange"];
        [buttons addButtonWithDescription:@"Multiplayer" target:self selector:@selector(onMultiplayer:)
                             iconFilename:@"multiplayer.png" colorString:@"purple"];
        [buttons addButtonWithDescription:@"Achievements" target:self selector:@selector(onAchievements:)
                             iconFilename:@"achievements.png" colorString:@"gold"];
        [buttons addButtonWithDescription:@"Options" target:self selector:@selector(onOptions:)
                             iconFilename:@"options.png" colorString:@"silver"];
        [self addChild:buttons];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        TitleLayer *title = [[TitleLayer alloc] init];
        title.position = ccp(screenSize.width / 2, screenSize.height - title.contentSize.height / 2 - platformPadding);
        [self addChild:title];
        
        buttons.position = ccp(title.position.x, CGRectGetMinY(title.boundingBox) / 2);
    }
    return self;
}

/* Callback functions for main menu items */

- (void) onQuickplay: (id) sender
{
  [[CCDirector sharedDirector] replaceSceneAndCleanup:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[DifficultyMenu scene]]];
}

- (void) onSinglePlayer: (id) sender
{
  [[CCDirector sharedDirector] replaceSceneAndCleanup:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[SinglePlayerMenu scene]]];
}

- (void) onMultiplayer: (id) sender
{
  if (![GameCenterHub sharedHub].gameCenterAvailable || ![GameCenterHub sharedHub].userAuthenticated)
  {
    [[GameCenterHub sharedHub] displayGameCenterNotification:@"Must be logged into GameCenter to use this"];
    return;
  }
  
  [[CCDirector sharedDirector] replaceSceneAndCleanup:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[MultiplayerMenu scene]]];
}

- (void) onOptions: (id) sender
{
  [[CCDirector sharedDirector] replaceSceneAndCleanup:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[OptionsMenu scene]]];
}

- (void) onAchievements: (id) sender
{
  if (![GameCenterHub sharedHub].gameCenterAvailable || ![GameCenterHub sharedHub].userAuthenticated)
  {
    [[GameCenterHub sharedHub] displayGameCenterNotification:@"Must be logged into GameCenter to use this"];
    return;
  }
  
  [[CCDirector sharedDirector] replaceSceneAndCleanup:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[AchievementsMenu scene]]];
}

@end

