//
//  Leaderboard.m
//  shift
//
//  Created by Alex Chesebro on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Leaderboard.h"
#import "GameCenterHub.h"
#import "cocos2d.h"

@implementation Leaderboard

- (id) init
{
  if(( self = [super init] )) 
  {
    [[GameCenterHub sharedInstance] showLeaderboard];
  }
  return self;
}

+ (id) scene
{
  CCScene* scene = [CCScene node];
  Leaderboard* layer = [Leaderboard node];
  [scene addChild: layer];
  return scene;
}

@end
