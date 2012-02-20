//
//  GameCenterHub.h
//  shift
//
//  Created by Alex Chesebro on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameCenterHub : NSObject

BOOL isGameCenterAPIAvailable();
- (void) authenticateLocalPlayer;
- (void) loadPlayerData: (NSArray *) identifiers;
- (void) retrieveFriends;
- (void) inviteFriends: (NSArray*) identifiers;
- (void) reportScore: (int64_t) score forCategory: (NSString*) category;
- (void) showLeaderboard;
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController*)viewController;
- (void) retrieveTopTenScores;

@end
