//
//  GameCenterHub.h
//  shift
//
//  Created by Alex Chesebro on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "RootViewController.h"

@interface GameCenterHub : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate, GKLeaderboardViewControllerDelegate, GKFriendRequestComposeViewControllerDelegate, GKAchievementViewControllerDelegate>
{ 
  RootViewController* rootViewController;
  BOOL gameCenterAvailable;
  BOOL userAuthenticated;  
  NSNotificationCenter* notificationCenter;
  NSError* lastError;
  
  GKMatch* match;
  BOOL matchStarted;
}

@property (nonatomic, readonly) NSNotificationCenter* notificationCenter;
@property (assign, readonly) BOOL gameCenterAvailable;
@property (retain) RootViewController* rootViewController;
@property (nonatomic, retain) GKMatch* match;
@property (nonatomic, readonly) NSError* lastError;

// Initialization functions
+ (GameCenterHub*)sharedInstance;
+ (id) alloc;
- (id) init;

// Authentication functions
- (void) authenticateLocalPlayer;
- (void) authenticationChanged;
- (void) getPlayerFriends;
- (void) inviteFriends:(NSArray*)identifiers;

// Achievements functions
- (void) showAchievements;
- (void) achievementViewControllerDidFinish:(GKAchievementViewController*)viewController;

// LeaderBoard functions
- (void) showLeaderboard:(NSString*)category;
- (void) submitScore:(int64_t)score category:(NSString*)category;
- (void) retrieveScoresForPlayers:(NSArray*)players category:(NSString*)category range:(NSRange)range playerScope:(GKLeaderboardPlayerScope)playerScope timeScope:(GKLeaderboardTimeScope)timeScope;
- (void) retrieveTopTenAllTimeGlobalScores;

// Matchmaking functions
- (void) findRandomMatch;
- (void) matchEnded;

// Helper functions
- (void) setError:(NSError*)error;
- (BOOL) isGameCenterAvailable;
- (void) loadPlayerData:(NSArray*)identifiers;

@end
