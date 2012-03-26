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

@interface GameCenterHub : NSObject <GKLeaderboardViewControllerDelegate, GKFriendRequestComposeViewControllerDelegate, GKAchievementViewControllerDelegate, GKTurnBasedMatchmakerViewControllerDelegate, GKTurnBasedEventHandlerDelegate>
{ 
  RootViewController* rootViewController;
  BOOL gameCenterAvailable;
  BOOL userAuthenticated;  
  NSNotificationCenter* __weak notificationCenter;
  NSError* lastError;
  
  NSMutableDictionary* achievementDict;
  GKTurnBasedMatch* currentMatch;
  BOOL matchStarted;
}

@property(nonatomic, strong) NSMutableDictionary* achievementDict;
@property (nonatomic, weak, readonly) NSNotificationCenter* notificationCenter;
@property (assign, readonly) BOOL gameCenterAvailable;
@property (strong) RootViewController* rootViewController;
@property (nonatomic, readonly) NSError* lastError;
@property (nonatomic, strong) GKTurnBasedMatch* currentMatch;

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
- (void) loadAchievements;
- (void) achievementViewControllerDidFinish:(GKAchievementViewController*) viewController;	  	
- (void) retrieveAchievmentMetadata;
- (void) reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent;
- (GKAchievement*) addOrFindIdentifier:(NSString*)identifier;

// LeaderBoard functions
- (void) showLeaderboard:(NSString*)category;
- (void) submitScore:(int64_t)score category:(NSString*)category;

// Matchmaking functions
- (void) findRandomMatch;
- (void) enterNewGame:(GKTurnBasedMatch*)match;
- (void) layoutMatch:(GKTurnBasedMatch*)match;
- (void) takeTurn:(GKTurnBasedMatch*)match;
- (void) recieveEndGame:(GKTurnBasedMatch*)match;
- (void) sendNotice:(NSString*)notice forMatch:(GKTurnBasedMatch*)match;

// Helper functions
- (void) setError:(NSError*)error;
- (BOOL) isGameCenterAvailable;
- (void) loadPlayerData:(NSArray*)identifiers;

@end
