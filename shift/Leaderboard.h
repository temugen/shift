//
//  Leaderboard.h
//  shift
//
//  Created by Alex Chesebro on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import <GameKit/GameKit.h>

@interface Leaderboard : CCLayer <GKLeaderboardViewControllerDelegate>
{
  UIViewController* vc;
}

+ (id) scene;
- (id) init;
- (void) showLeaderboard:(ccTime)dt;
- (void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;

@end
