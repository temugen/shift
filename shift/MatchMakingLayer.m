//
//  MatchMakingLayer.m
//  shift
//
//  Created by Alex Chesebro on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchMakingLayer.h"
#import "shiftAppDelegate.h"
#import "RootViewController.h"

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
    shiftAppDelegate* delegate = (shiftAppDelegate*) [UIApplication sharedApplication].delegate;
    [[GameCenterHub sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:delegate.viewController delegate: self];
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

@end
