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


@implementation DifficultyMenu

//Initialize the Quickplay layer
-(id) initWithMode:(gamemode)gameSelection
{
    if( (self=[super init] )) {
        mode = gameSelection;
        
        //Set up menu items
        CCMenuItemFont *easy = [CCMenuItemFont itemFromString:@"Easy" target:self selector: @selector(onSelection:)];
        [easy setTag:kDifficultyEasy];
        CCMenuItemFont *medium = [CCMenuItemFont itemFromString:@"Medium" target:self selector: @selector(onSelection:)];
        [medium setTag:kDifficultyMedium];
        CCMenuItemFont *hard= [CCMenuItemFont itemFromString:@"Hard" target:self selector: @selector(onSelection:)];
        [hard setTag:kDifficultyHard];
        CCMenuItemFont *back = [CCMenuItemFont itemFromString:@"Back" target:self selector: @selector(goBack:)]; 

        //Add items to menu
        CCMenu *menu = [CCMenu menuWithItems: easy,medium,hard,back, nil];
        
        [menu alignItemsVertically];
        
        [self addChild: menu];        
    }
    return self;
}

//Create scene with quickplay menu
+(id) sceneWithMode:(gamemode) gameSelection
{
    DifficultyMenu *menu = [[DifficultyMenu alloc] initWithMode:gameSelection];
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
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipAngular transitionWithDuration:kSceneTransitionTime scene:game]];
    }
    else //Multiplayer game
    {
        if(mode == RANDOMMULTI)
        {
            //TODO: Setup Random Multiplayer Game
            NSLog(@"User selected Random Opponent Multiplayer");   
        }
        else //User selected Friend Opponent
        {               
            //TODO: Setup Friend Multiplayer game
            NSLog(@"User selected Friend Opponent Multiplayer");   

        }
    }
}

- (void) goBack: (id) sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    
    if(mode==QUICKPLAY) //Return to Main Menu
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:kSceneTransitionTime scene:[MainMenu scene]]];
    }
    else //Return to Multiplayer menu
    {
        [[CCDirector sharedDirector] replaceScene:
                                        [CCTransitionSlideInL transitionWithDuration:kSceneTransitionTime scene:[MultiplayerMenu scene]]];
    }
}


@end
