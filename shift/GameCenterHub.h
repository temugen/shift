//
//  GameCenterHub.h
//  shift
//
//  Created by Alex Chesebro on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GKLeaderboard, GKAchievement, GKPlayer;

@protocol GameCenterHubDelegate <NSObject>
@optional
- (void) processGameCenterAuth: (NSError*) error;
- (void) scoreReported: (NSError*) error;
- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
- (void) achievementResetResult: (NSError*) error;
- (void) mappedPlayerIDToPlayer: (GKPlayer*) player error: (NSError*) error;
@end

@interface GameCenterHub : NSObject
{
  NSMutableDictionary* earnedAchievementCache;
  id <GameCenterHubDelegate, NSObject> delegate;
}

//This property must be attomic to ensure that the cache is always in a viable state...
@property (retain) NSMutableDictionary* earnedAchievementCache;

@property (nonatomic, assign) id <GameCenterHubDelegate> delegate;

+ (BOOL) isGameCenterAPIAvailable;
- (void) authenticateLocalPlayer;
- (void) reportScore: (int64_t) score forCategory: (NSString*) category;
- (void) reloadHighScoresForCategory: (NSString*) category;
- (void) submitAchievement: (NSString*) identifier percentComplete: (double) percentComplete;
- (void) resetAchievements;
- (void) mapPlayerIDtoPlayer: (NSString*) player;

@end
