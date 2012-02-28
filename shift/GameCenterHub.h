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

@protocol GameCenterMatchmakingDelegate
- (void) matchStarted;
- (void) matchEnded;
- (void) match: (GKMatch*) match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
- (void) onMatchmakingViewDismissed;
@end

@protocol GameCenterLeaderboardDelegate
- (void) onScoresSubmitted:(BOOL) success;
- (void) onScoresReceived:(NSArray*) players;
- (void) onLeaderboardViewDismissed;
@end

@interface GameCenterHub : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate, GKLeaderboardViewControllerDelegate>
{ 
  
  RootViewController* rootViewController;
  id <GameCenterMatchmakingDelegate> mmd;
  id <GameCenterLeaderboardDelegate> lbd;
  
  NSMutableDictionary* achievements;
  NSMutableDictionary* cachedAchievements;
  
  BOOL gameCenterAvailable;
  BOOL userAuthenticated;
  
  NSError* lastError;
  
  GKMatch* match;
  BOOL matchStarted;
}

@property (assign, readonly) BOOL gameCenterAvailable;
@property (retain) RootViewController* rootViewController;
@property (nonatomic, retain) GKMatch* match;
@property (nonatomic, retain) id <GameCenterMatchmakingDelegate> mmd;
@property (nonatomic, retain) id <GameCenterLeaderboardDelegate> lbd;
@property (nonatomic, readonly) NSMutableDictionary* achievements;
@property (nonatomic, readonly) NSError* lastError;

// Authentication and initializing functions
+ (GameCenterHub*) sharedInstance;
+ (id) alloc;
- (id) init;
- (void) authenticateLocalPlayer;
- (void) authenticationChanged;
- (void) setError:(NSError*) error;
- (BOOL) isGameCenterAvailable;

- (void) findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int) maxPlayers viewController:(UIViewController*)viewController delegate:(id<GameCenterMatchmakingDelegate>)theDelegate;

// LeaderBoard functions
- (void) submitScore:(int64_t)score category:(NSString*)category;
- (void) retrieveScoresForPlayers:(NSArray*)players category:(NSString*)category range:(NSRange)range playerScope:(GKLeaderboardPlayerScope)playerScope timeScope:(GKLeaderboardTimeScope)timeScope;
- (void) retrieveTopTenAllTimeGlobalScores;
- (void) showLeaderboard:(NSString*)category;
- (void) showMatchmakerView;

@end
