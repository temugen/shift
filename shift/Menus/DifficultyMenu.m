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

DifficultyMenu* layer;

//Initialize the Quickplay layer
-(id) init
{
    if( (self=[super init] )) {
        
        //Set up menu items
        CCMenuItemFont *easy = [CCMenuItemFont itemFromString:@"Easy" target:self selector: @selector(onSelection:)];
        [easy setTag:EASY];
        CCMenuItemFont *medium = [CCMenuItemFont itemFromString:@"Medium" target:self selector: @selector(onSelection:)];
        [medium setTag:MEDIUM];
        CCMenuItemFont *hard= [CCMenuItemFont itemFromString:@"Hard" target:self selector: @selector(onSelection:)];
        [hard setTag:HARD];
        CCMenuItemFont *back = [CCMenuItemFont itemFromString:@"Back" target:self selector: @selector(goBack:)]; 

        //Add items to menu
        CCMenu *menu = [CCMenu menuWithItems: easy,medium,hard,back, nil];
        
        [menu alignItemsVertically];
        
        [self addChild: menu];        
    }
    return self;
}

//Create scene with quickplay menu
+(id) scene:(gamemode) gameSelection
{
    layer = [DifficultyMenu node];
    layer->mode = gameSelection;
    return [super scene:layer];
}

/* Callback functions for menu items */

- (void) onSelection: (id) sender
{
    difficulty diff = [sender tag];
    
    if(layer->mode == QUICKPLAY)
    {
        QuickPlayGame *game;
        switch (diff) {
            case EASY:
                //TODO: Generate random easy puzzle
                NSLog(@"User selected Easy Quickplay");
                game = [QuickPlayGame gameWithNumberOfRows:3 columns:3];
                break;
            case MEDIUM:
                //TODO: Generate random medium puzzle
                NSLog(@"User selected Medium Quickplay");
                game = [QuickPlayGame gameWithNumberOfRows:5 columns:5];
                break;
            case HARD:
                //TODO: Generate random hard puzzle
                NSLog(@"User selected Hard Quickplay");
                game = [QuickPlayGame gameWithNumberOfRows:7 columns:7];
                break;
            default:
                break;
        }
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipAngular transitionWithDuration:TRANS_TIME scene:game]];
    }
    else //Multiplayer game
    {
        if(layer->mode == RANDOMMULTI)
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
    if(layer->mode==QUICKPLAY) //Return to Main Menu
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:TRANS_TIME scene:[MainMenu scene]]];
    }
    else //Return to Multiplayer menu
    {
        [[CCDirector sharedDirector] replaceScene:
                                        [CCTransitionSlideInL transitionWithDuration:TRANS_TIME scene:[MultiplayerMenu scene]]];
    }
}

-(void) dealloc
{
	[super dealloc];
}

@end
