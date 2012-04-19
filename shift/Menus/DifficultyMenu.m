//
//  DifficultyMenu.m
//  shift
//
//  Created by Greg McLain on 2/16/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "DifficultyMenu.h"
#import "QuickPlayGame.h"
#import "MainMenu.h"
#import "MultiplayerMenu.h"
#import "MultiplayerGame.h"
#import "GameCenterHub.h"

#define kDifficultyLast 3842384 //random

@implementation DifficultyMenu

//Initialize the Quickplay layer
-(id) initWithMode:(gamemode)gameSelection
{
    if( (self=[super init] )) 
    {
        mode = gameSelection;      
      
        //Set up menu items
        CCMenuItemFont *easy = [CCMenuItemFont itemFromString:@"Easy" target:self selector: @selector(onSelection:)];
        [easy setTag:kDifficultyEasy];
        CCMenuItemFont *medium = [CCMenuItemFont itemFromString:@"Medium" target:self selector: @selector(onSelection:)];
        [medium setTag:kDifficultyMedium];
        CCMenuItemFont *hard= [CCMenuItemFont itemFromString:@"Hard" target:self selector: @selector(onSelection:)];
        [hard setTag:kDifficultyHard];        
        CCMenu* menu = [CCMenu menuWithItems: easy,medium,hard, nil];
        
        QuickPlayGame *lastGame = [QuickPlayGame lastGame];
        if (lastGame != nil && gameSelection != MULTIPLAYER) 
        {
          CCMenuItemFont *continu = [CCMenuItemFont itemFromString:@"Continue" target:self selector:@selector(onSelection:)];
          [continu setTag:kDifficultyLast];
          
          [menu addChild:continu];
        }
        
        [menu alignItemsVertically];
        [self addChild: menu];  
        [self addBackButton];
    }
    return self;
}


-(id) initWithMatch:(GKTurnBasedMatch*) myMatch
{
  if( (self=[super init] )) 
  {
    mode = MULTIPLAYER;      
    match = myMatch;
    
    //Set up menu items
    CCMenuItemFont* easy = [CCMenuItemFont itemFromString:@"Easy" target:self selector: @selector(onSelection:)];
    [easy setTag:kDifficultyEasy];
    CCMenuItemFont* medium = [CCMenuItemFont itemFromString:@"Medium" target:self selector: @selector(onSelection:)];
    [medium setTag:kDifficultyMedium];
    CCMenuItemFont* hard= [CCMenuItemFont itemFromString:@"Hard" target:self selector: @selector(onSelection:)];
    [hard setTag:kDifficultyHard];        
    CCMenu* menu = [CCMenu menuWithItems: easy,medium,hard, nil];
    
    [menu alignItemsVertically];
    [self addChild: menu];
    [self addBackButton];
  }
  return self;
}

//Create scene with quickplay menu
+(id) sceneWithMode:(gamemode) gameSelection
{
    DifficultyMenu *menu = [[DifficultyMenu alloc] initWithMode:gameSelection];
    return [Menu sceneWithMenu:menu];
}

//Create scene with quickplay menu
+(id) sceneWithMatch:(GKTurnBasedMatch*) match
{
  DifficultyMenu *menu = [[DifficultyMenu alloc] initWithMatch:match];
  return [Menu sceneWithMenu:menu];
}


/* Callback functions for menu items */

- (void) onSelection: (id) sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    
    Difficulty diff = [sender tag];
    
    if(mode == QUICKPLAY)
    {
        QuickPlayGame *game;
        switch (diff) {
            case kDifficultyLast:
                NSLog(@"User selected Continue Quickplay");
                game = [QuickPlayGame lastGame];
                break;
            case kDifficultyEasy:
                //TODO: Generate random kDifficultyEasy puzzle
                NSLog(@"User selected Easy Quickplay");
                game = [QuickPlayGame gameWithNumberOfRows:kDifficultyEasy columns:kDifficultyEasy];
                break;
            case kDifficultyMedium:
                //TODO: Generate random kDifficultyMedium puzzle
                NSLog(@"User selected Medium Quickplay");
                game = [QuickPlayGame gameWithNumberOfRows:kDifficultyMedium columns:kDifficultyMedium];
                break;
            case kDifficultyHard:
                //TODO: Generate random kDifficultyHard puzzle
                NSLog(@"User selected Hard Quickplay");
                game = [QuickPlayGame gameWithNumberOfRows:kDifficultyHard columns:kDifficultyHard];
                break;
            default:
                break;
        }
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:game]];
    }
    else //Multiplayer game
    {
      MultiplayerGame *game;
      switch (diff) {
        case kDifficultyEasy:
          NSLog(@"User selected Easy Multiplayer");
          game = [MultiplayerGame gameWithNumberOfRows:kDifficultyEasy columns:kDifficultyEasy match:match];
          break;
        case kDifficultyMedium:
          NSLog(@"User selected Medium Multiplayer");
          game = [MultiplayerGame gameWithNumberOfRows:kDifficultyMedium columns:kDifficultyMedium match:match];
          break;
        case kDifficultyHard:
          NSLog(@"User selected Hard Multiplayer");
          game = [MultiplayerGame gameWithNumberOfRows:kDifficultyHard columns:kDifficultyHard match:match];
          break;
        default:
          break;
      }
      [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:game]];
    }
}

- (void) goBack: (id) sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    
    if(mode == QUICKPLAY) //Return to Main Menu
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:kSceneTransitionTime scene:[MainMenu scene]]];
    }
    else //Return to Multiplayer menu
    {
      [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:kSceneTransitionTime scene:[MultiplayerMenu scene]]];
    }
}


@end
