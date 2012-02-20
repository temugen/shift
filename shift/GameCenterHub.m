//
//  GameCenterHub.m
//  shift
//
//  Created by Alex Chesebro on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <GameKit/GameKit.h>

#import "GameCenterHub.h"

@implementation GameCenterHub

BOOL isGameCenterAPIAvailable()
{
  // Check for presence of GKLocalPlayer class.
  BOOL localPlayerClassAvailable = (NSClassFromString(@"GKLocalPlayer")) != nil;
  
  // The device must be running iOS 4.1 or later.
  NSString *reqSysVer = @"4.1";
  NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
  BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch]
                             != NSOrderedAscending);
  return (localPlayerClassAvailable && osVersionSupported);
}


- (void) authenticateLocalPlayer
{
  GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
  [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
    if (localPlayer.isAuthenticated)
    {
      // TODO:  Add tasks for authenticated player
    }
  }];
}


- (void) loadPlayerData: (NSArray *) identifiers
{
  [GKPlayer loadPlayersForIdentifiers:identifiers withCompletionHandler:^(NSArray
                                                      *players, NSError *error) {
    if (error != nil)
    {
      // error handling
      
    }
    if (players != nil)
    {
      // TODO:  Translate the player data into our display format
      
    }
  }];
}



- (void) retrieveFriends
{
  GKLocalPlayer *lp = [GKLocalPlayer localPlayer];
  if (lp.authenticated)
  {
    [lp loadFriendsWithCompletionHandler:^(NSArray *friends, NSError *error) {
      if (friends != nil)
      {
        [self loadPlayerData: friends];
      }
    }];
  }
}



- (void) inviteFriends: (NSArray*) identifiers
{

  GKFriendRequestComposeViewController *friendRequestViewController =
  [[GKFriendRequestComposeViewController alloc] init];
  friendRequestViewController.composeViewDelegate = self;
  if (identifiers)
  {
    [friendRequestViewController addRecipientsWithPlayerIDs: identifiers];
  }
  [self presentModalViewController: friendRequestViewController animated: YES];
  [friendRequestViewController release];
}
  


- (void) reportScore: (int64_t) score forCategory: (NSString*) category
{
  GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category]
                            autorelease];
  scoreReporter.value = score;
  [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
    if (error != nil)
    {
      // handle the reporting error
    }
  }];
}
  

- (void) showLeaderboard
{
  GKLeaderboardViewController *leaderboardController =
  [[GKLeaderboardViewController alloc] init];
  if (leaderboardController != nil)
  {
    leaderboardController.leaderboardDelegate = self;
    [self presentModalViewController: leaderboardController animated: YES];
  }
}


// Method for view controllr to dismiss leaderboard
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController*)viewController
{
  [self dismissModalViewControllerAnimated:YES];
}


// Retrieves the top ten scores on the leaderboard
- (void) retrieveTopTenScores
{
  GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
  if (leaderboardRequest != nil)
  {
    leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
    leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
    leaderboardRequest.range = NSMakeRange(1,10);
    [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores,
                                                           NSError *error) {
      if (error != nil)
      {
        // handle the error.
      }
      if (scores != nil)
      {
        // process the score information.
      }
    }];
  }
}

@end
