//
//  MultiplayerMenu.m
//  shift
//
//  Created by Greg McLain on 2/16/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "MultiplayerMenu.h"
#import "MainMenu.h"
#import "DifficultyMenu.h"
#import "MatchMakingLayer.h"
#import "Leaderboard.h"

@implementation MultiplayerMenu

//Initialize the Multiplayer Menu layer
-(id) init
{
    if( (self=[super init] )) {
        
        //Set up menu items
        CCMenuItemFont *friend = [CCMenuItemFont itemFromString:@"Friend Opponent" target:self selector: @selector(onOppSelection:)];
        [friend setTag:FRIENDMULTI];
        CCMenuItemFont *random = [CCMenuItemFont itemFromString:@"Random Opponent" target:self selector: @selector(onRandSelection:)];
        [random setTag:RANDOMMULTI];
        CCMenuItemFont *leaderboard= [CCMenuItemFont itemFromString:@"Leaderboard" target:self selector: @selector(onLeaderboard:)];
        CCMenuItemFont *back = [CCMenuItemFont itemFromString:@"Back" target:self selector: @selector(goBack:)]; 
        
        //Add items to menu
        CCMenu *menu = [CCMenu menuWithItems: friend,random,leaderboard,back, nil];
        
        [menu alignItemsVertically];
        
        [self addChild: menu];        
    }
    return self;
}

//Create scene with quickplay menu
+(id) scene
{
    MultiplayerMenu *layer = [MultiplayerMenu node];
    return [super scene:layer];
}

/* Callback functions for menu items */

- (void) onOppSelection: (id) sender
{
    gamemode selection = [sender tag];
    [[CCDirector sharedDirector] replaceScene:
                                    [CCTransitionSlideInR transitionWithDuration:TRANS_TIME scene:[DifficultyMenu scene:selection]]];
}

- (void) onRandSelection: (id) sender
{
  [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:TRANS_TIME scene:[MatchMakingLayer scene]]];
}

- (void) onLeaderboard: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:TRANS_TIME scene:[Leaderboard scene]]];
}

-(void) dealloc
{
	[super dealloc];
}

@end
