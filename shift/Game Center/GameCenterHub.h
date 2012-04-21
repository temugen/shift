//
//  GameCenterHub.h
//  shift
//
//  Created by Alex Chesebro on 2/20/12.
//  Copyright (c) 2012 __Oh_Shift__. All rights reserved.
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
  
  NSMutableDictionary* achievementDict;
  NSMutableDictionary* unsentScores;
  GKTurnBasedMatch* currentMatch;
  BOOL matchStarted;
}

@property (strong) NSMutableDictionary* achievementDict;
@property (strong) NSMutableDictionary* unsentScores;
@property (nonatomic, weak, readonly) NSNotificationCenter* notificationCenter;
@property (assign, readonly) BOOL gameCenterAvailable;
@property (assign, readonly) BOOL userAuthenticated;
@property (strong) RootViewController* rootViewController;
@property (strong) GKTurnBasedMatch* currentMatch;

// Initialization functions
+(GameCenterHub*)sharedHub;
-(id) init;

// Authentication functions
-(void) authenticateLocalPlayer;
-(BOOL) isGameCenterAvailable;
-(void) authenticationChanged;
-(void) getPlayerFriends;
-(void) loadPlayerData:(NSArray*) identifiers;
-(void) inviteFriends:(NSArray*) identifiers;
-(void) displayGameCenterNotification:(NSString*) message;

// Achievements functions
-(void) showAchievements;
-(void) loadAchievements;
-(void) achievementViewControllerDidFinish:(GKAchievementViewController*) viewController;	  	
-(void) reportAchievementIdentifier:(NSString*) identifier percentComplete:(float) percent;
-(GKAchievement*) addOrFindIdentifier:(NSString*) identifier;
-(void) achievementCompleted:(NSString*) title message:(NSString*) msg;
-(void) resetAchievements;
-(void) saveAchievements;

// LeaderBoard functions
-(void) showLeaderboard:(NSString*) category;
-(void) submitScore:(int64_t) score category:(NSString*) category;
-(void) saveUnsentScores;

// Matchmaking functions
-(void) findMatch;
-(void) clearMatches;
-(void) enterNewGame:(GKTurnBasedMatch*) match;
-(void) waitForAnotherPlayer:(GKTurnBasedMatch*) match;
-(void) layoutMatch:(GKTurnBasedMatch*) match;
-(void) recieveEndGame:(GKTurnBasedMatch*) match;
-(void) sendNotice:(NSString*) notice forMatch:(GKTurnBasedMatch*) match;
-(IBAction) sendTurn:(id)sender data:(NSData*)data;


@end
