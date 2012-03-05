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


- (id) init
{
  if ((self=[super init])) {
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

+ (id) scene:(gamemode) gameSelection 
{
  LeaderboardMenu* layer = [LeaderboardMenu node];
  layer->mode = gameSelection;
  return [super scene:layer]; 
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

-(void) dealloc
{
	[super dealloc];
}


@end
