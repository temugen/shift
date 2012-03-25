//
//  LeaderboardMenu.m
//  shift
//
//  Created by Alex Chesebro on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeaderboardMenu.h"
#import "GameCenterHub.h"
#import "MultiplayerMenu.h"
#import "MainMenu.h"

@implementation LeaderboardMenu


- (id) initWithMode:(gamemode)gameSelection
{
    if ((self=[super init])) {
        mode = gameSelection;
        
        // Menu Items
        CCMenuItemFont* hardTime = [CCMenuItemFont itemFromString:@"Hard Times" target:self selector: @selector(onHardTimeSelection:)];
        CCMenuItemFont *hardMoves = [CCMenuItemFont itemFromString:@"Hard Moves" target:self selector: @selector(onHardMoves:)];
        CCMenuItemFont *back = [CCMenuItemFont itemFromString:@"Back" target:self selector: @selector(goBack:)]; 
        
        // Set tags
        [hardMoves setTag:HARDMOVELB];
        [hardTime setTag:HARDTIMELB];
        
        // Set items
        CCMenu *menu = [CCMenu menuWithItems: hardTime, hardMoves, back, nil];
        
        [menu alignItemsVertically];
        
        [self addChild: menu];        
    }
    return self;
}

+ (id) sceneWithMode:(gamemode) gameSelection 
{
    LeaderboardMenu* menu = [[LeaderboardMenu alloc] initWithMode:gameSelection];
    return [Menu sceneWithMenu:menu]; 
}

- (void) onHardTimeSelection: (id) sender
{
  [[GameCenterHub sharedInstance] showLeaderboard:@"hard_time"];
}

- (void) onHardMoves: (id) sender
{
  [[GameCenterHub sharedInstance] showLeaderboard:@"hard_moves"];
}

- (void) goBack: (id) sender
{
  [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:kSceneTransitionTime scene:[MultiplayerMenu scene]]];
}



@end
