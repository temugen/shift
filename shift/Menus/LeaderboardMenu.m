//
//  LeaderboardMenu.m
//  shift
//
//  Created by Alex Chesebro on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeaderboardMenu.h"
#import "GameCenterHub.h"
#import "MainMenu.h"

@implementation LeaderboardMenu

LeaderboardMenu* layer;

- (id) init
{
  if( (self=[super init] )) {
    
    //Set up menu items
    CCMenuItemFont* hardTime = [CCMenuItemFont itemFromString:@"Hard Times" target:self selector: @selector(onHardTimeSelection:)];
//    [hardTime setTag:HTIMELB];
    CCMenuItemFont *hardMoves = [CCMenuItemFont itemFromString:@"Hard Moves" target:self selector: @selector(onHardMoves:)];
//    [random setTag:HMOVESLB];
    CCMenuItemFont *back = [CCMenuItemFont itemFromString:@"Back" target:self selector: @selector(goBack:)]; 
    
    //Add items to menu
    CCMenu *menu = [CCMenu menuWithItems: hardTime, hardMoves, back, nil];
    
    [menu alignItemsVertically];
    
    [self addChild: menu];        
  }
  return self;
}

+ (id) scene:(gamemode) gameSelection 
{
  layer = [LeaderboardMenu node];
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

-(void) dealloc
{
	[super dealloc];
}


@end
