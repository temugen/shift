//
//  MatchMakingLayer.m
//  shift
//
//  Created by Alex Chesebro on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchMakingLayer.h"
#import "GameCenterHub.h"

@implementation MatchMakingLayer

+ (CCScene*) scene
{
  CCScene* scene = [CCScene node];
  MatchMakingLayer* layer = [MatchMakingLayer node];
  [scene addChild: layer];
  return scene;
}

- (id) init
{
  if ((self = [super init]))
  {
    GameCenterHub* gch = [[[GameCenterHub alloc] init] autorelease];
    [gch showMatchmakerView];
    [gch findMatchWithMinPlayers:2 maxPlayers:2 viewController:gch.presentingViewController delegate:self];
  }
  return self;
}

- (void) matchStarted
{
}

- (void) matchEnded
{
}

- (void) match:(GKMatch*)match didReceiveData:(NSData*)data fromPlayer:(NSString*)playerID
{  
}

- (void) onMatchmakingViewDismissed
{
  
}

@end
