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

#define TEXT_BLOCK_SIZE 35
#define TITLE_BORDER_SIZE 50

@implementation MainMenu

//Initialize the Main Menu layer
-(id) init
{
    if( (self=[super init] )) {
        //Play background music
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@BGM_MENU];
        
        //Set up menu items
        CCMenuItemImage *quickplay = [CCMenuItemImage itemFromNormalImage:@"quickplay.png"
                                                           selectedImage:@"quickplay.png" target:self selector: @selector(onQuickplay:)];
        quickplay.color = [[ColorPalette sharedPalette] colorWithName:@"green" fromPalette:@"_app"];
        CCMenuItemImage *single = [CCMenuItemImage itemFromNormalImage:@"singleplayer.png"
                                                        selectedImage:@"singleplayer.png" target:self selector: @selector(onSinglePlayer:)];
        single.color = [[ColorPalette sharedPalette] colorWithName:@"orange" fromPalette:@"_app"];
        CCMenuItemImage *multi = [CCMenuItemImage itemFromNormalImage:@"multiplayer.png"
                                                       selectedImage:@"multiplayer.png" target:self selector: @selector(onMultiplayer:)];
        multi.color = [[ColorPalette sharedPalette] colorWithName:@"purple" fromPalette:@"_app"];
        CCMenuItemImage *achievements = [CCMenuItemImage itemFromNormalImage:@"achievements.png"
                                                              selectedImage:@"achievements.png" target:self selector: @selector(onAchievements:)];
        achievements.color = [[ColorPalette sharedPalette] colorWithName:@"gold"fromPalette:@"_app"];
        CCMenuItemImage *options = [CCMenuItemImage itemFromNormalImage:@"options.png"
                                                         selectedImage:@"options.png" target:self selector: @selector(onOptions:)];
        options.color = [[ColorPalette sharedPalette] colorWithName:@"silver" fromPalette:@"_app"];
        
        menu = [CCMenu menuWithItems: quickplay, single, multi, achievements, options, nil];
        [menu alignItemsHorizontallyWithPadding:platformPadding];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        TitleLayer *title = [[TitleLayer alloc] init];
        title.position = ccp(menu.position.x, screenSize.height - title.contentSize.height / 2 - platformPadding);
        [self addChild:title];
        
        float barWidth = (options.position.x + options.contentSize.width / 2) - (quickplay.position.x - quickplay.contentSize.width / 2);
        float barHeight = options.contentSize.height;
        barWidth += platformPadding * 2;
        RoundedRectangle *bar = [[RoundedRectangle alloc] initWithWidth:barWidth height:barHeight pressed:NO];
        bar.position = ccp(menu.position.x, bar.contentSize.height / 2 + platformPadding);
        bar.skewX = 20;
        [self addChild:bar z:-1];
        
        menu.position = ccp(menu.position.x, bar.position.y + bar.contentSize.height / 2);
        [self addChild: menu];
    }
    return self;
}

/* Callback functions for main menu items */

- (void) onQuickplay: (id) sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[DifficultyMenu sceneWithMode:QUICKPLAY]]];
}

- (void) onSinglePlayer: (id) sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[SinglePlayerMenu scene]]];
}

- (void) onMultiplayer: (id) sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    if ([GameCenterHub sharedInstance].gameCenterAvailable) 
    { 
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[MultiplayerMenu scene]]];
    }
    else
    {
      [[GameCenterHub sharedInstance] noGameCenterNotification:@"GameCenter is required to use any of the multiplayer features"];
    }
}

- (void) onOptions: (id) sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[OptionsMenu scene]]];
}

- (void) onAchievements: (id) sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];

  if ([GameCenterHub sharedInstance].gameCenterAvailable)
  { 
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[AchievementsMenu scene]]];
  }
  else
  {
    [[GameCenterHub sharedInstance] noGameCenterNotification:@"Game Center is required to view your achievements"];
  }
}

@end

