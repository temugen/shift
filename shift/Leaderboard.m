//
//  Leaderboard.m
//  shift
//
//  Created by Alex Chesebro on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Leaderboard.h"
#import <GameKit/Gamekit.h>
#import "cocos2d.h"

@implementation Leaderboard

- (id) init
{
  if(( self=[super init] )) 
  {
    vc =[[UIViewController alloc] init];
    [self schedule:@selector(showLeaderboard:) interval:3];
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

- (void) showLeaderboard:(ccTime)dt
{
  [self unschedule:@selector(showLeaderboard:)];
  
  GKLeaderboardViewController* leaderboardController = [[[GKLeaderboardViewController alloc] init] autorelease];
  if (leaderboardController != nil)
  {
    leaderboardController.leaderboardDelegate = self;
    [[[CCDirector sharedDirector] openGLView] addSubview:vc.view];
    [vc presentModalViewController:leaderboardController animated: YES];
  }
}

- (void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
  [viewController dismissModalViewControllerAnimated:YES];
  [viewController.view removeFromSuperview];
}
                                             
- (void) dealloc
{
  [vc release];
  [super dealloc];
}

@end
