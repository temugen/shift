//
//  GameCenterHub.m
//  shift
//
//  Created by Alex Chesebro on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameCenterHub.h"
#import <GameKit/GameKit.h>

@implementation GameCenterHub

@synthesize achievementDict;
@synthesize notificationCenter;
@synthesize rootViewController;
@synthesize gameCenterAvailable;
@synthesize lastError;
@synthesize match;

static GameCenterHub* sharedHelper = nil;

// Singleton instance of gchub
+ (GameCenterHub*) sharedInstance
{
  if (!sharedHelper) 
  {
    sharedHelper = [[GameCenterHub alloc] init];
  }
  return sharedHelper;
}

+ (id) alloc{
  @synchronized(self)
  {
    NSAssert(sharedHelper == nil, @"Attempted to alloc second GCHub");
    sharedHelper = [[super alloc] retain];
    return sharedHelper;
  }
  return nil;
}

- (id) init
{
  if ((self = [super init] ))
  {
    gameCenterAvailable = [self isGameCenterAvailable];
    if (gameCenterAvailable)
    {
      notificationCenter = [NSNotificationCenter defaultCenter];
      [notificationCenter addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
    }
  }
  return self;
}

- (void) dealloc
{
  [sharedHelper release];
  sharedHelper = nil;
  [match release];
  [lastError release];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super dealloc];
}


/*
 ********** User Account Functions **********
 */

- (void) authenticateLocalPlayer
{
  if (!gameCenterAvailable) return;
  if([GKLocalPlayer localPlayer].authenticated == NO)
  {
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
  }
  [self getPlayerFriends];
  [self loadAchievements];
}

- (void) authenticationChanged 
{
  if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated)
  {
    NSLog(@"Auth changed; player authenticated.");
    userAuthenticated = YES;
    [self getPlayerFriends];
    
  }
  else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated)
  {
    NSLog(@"Auth changed; player not authenticated.");
    userAuthenticated = NO;
  }
}

- (void) getPlayerFriends
{
  GKLocalPlayer* me = [GKLocalPlayer localPlayer];
  if (me.authenticated)
  {
    [me loadFriendsWithCompletionHandler:^(NSArray* friends, NSError* error) {
      if (friends != nil)
      {
        [self loadPlayerData: friends];
      }
    }];
  }
}

- (void) inviteFriends: (NSArray*) identifiers
{
  GKFriendRequestComposeViewController* friendRequestVc = [[[GKFriendRequestComposeViewController alloc] init] autorelease];
  friendRequestVc.composeViewDelegate = self;
  if (identifiers)
  {
    [friendRequestVc addRecipientsWithPlayerIDs: identifiers];
  }
  [rootViewController presentModalViewController: friendRequestVc animated: YES];
}

- (void)friendRequestComposeViewControllerDidFinish:(GKFriendRequestComposeViewController*)viewController
{
  [rootViewController dismissModalViewControllerAnimated:YES];
}


/*
 ********** Achievement Functions **********
 */

- (void) showAchievements
{
  GKAchievementViewController* aVC = [[[GKAchievementViewController alloc] init] autorelease];
  if (aVC != nil)
  {
    aVC.achievementDelegate = self;
    [rootViewController presentModalViewController: aVC animated: YES];
  }
}

- (void) achievementViewControllerDidFinish:(GKAchievementViewController*)viewController 
{
  [rootViewController dismissModalViewControllerAnimated:YES];
}

- (void) loadAchievements
{    
  [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray* achievements, NSError* error) 
   {
     if (error != nil)
     {
       [self setError:error];
     }
     if (achievements != nil)
     {
       for (GKAchievement* achievement in achievements)
       {
         [achievementDict setObject: achievement forKey: achievement.identifier];
       }
     }
  }];
}

// Tests for existing identifier, if not then allocs it
- (GKAchievement*) addOrFindIdentifier:(NSString*)identifier
{
  GKAchievement* achievement = [achievementDict objectForKey:identifier];
  if (achievement == nil)
  {
    achievement = [[[GKAchievement alloc] initWithIdentifier:identifier] autorelease];
    [achievementDict setObject:achievement forKey:achievement.identifier];
  }
  return [[achievement retain] autorelease];
}


- (void) retrieveAchievmentMetadata
{
  [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:^(NSArray* descriptions, NSError* error) 
  {
    if (error != nil)
    {  
      [self setError:error];
    }
    if (descriptions != nil)
    {  
       // process achievement descriptions
    }
  }];
}

- (void) reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent
{
  GKAchievement* achievement = [self addOrFindIdentifier:identifier];
  if (achievement)
  {
    achievement.percentComplete = percent;
    [achievement reportAchievementWithCompletionHandler:^(NSError* error)
     {
       if (error != nil)
       {
         [self setError:error];
         // figure out what to do with non sent data
       }
     }];
  }
}


/*
 ********** Leaderboard Functions **********
 */

- (void) showLeaderboard:(NSString*) category
{
  if (!gameCenterAvailable) return;
  GKLeaderboardViewController* leaderboardVc = [[[GKLeaderboardViewController alloc] init] autorelease];
  if (leaderboardVc != nil)
  {
    leaderboardVc.leaderboardDelegate = self;
    leaderboardVc.category = category;
    leaderboardVc.timeScope = GKLeaderboardTimeScopeAllTime;
    
    [rootViewController presentModalViewController:leaderboardVc animated:YES];
  }
}

- (void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
  [rootViewController dismissModalViewControllerAnimated:YES];
}

- (void) submitScore:(int64_t)score category:(NSString *)category
{
  if (!gameCenterAvailable) return;
  GKScore* myScore = [[[GKScore alloc] init] autorelease];
  myScore.value = score;
  [myScore reportScoreWithCompletionHandler:^(NSError* error)
   {
     [self setError:error];
   }];
}


/*
 ********** Matchmaking functions **********
 */


- (void) findRandomMatch
{
  if (!gameCenterAvailable) return;
  
  matchStarted = NO;
  match = nil;
  [rootViewController dismissModalViewControllerAnimated:NO];
  
  GKMatchRequest* request = [[[GKMatchRequest alloc] init] autorelease];
  request.minPlayers = 2;
  request.maxPlayers = 2;
  
  GKMatchmakerViewController* matchmakerVc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];
  matchmakerVc.matchmakerDelegate = self;
  
  [rootViewController presentModalViewController:matchmakerVc animated:YES];
}

- (void) matchEnded
{
  
}

/*
 ********** Callback methods for GKMatchViewController **********
 */

// Player cancels MM
- (void) matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
  [rootViewController dismissModalViewControllerAnimated:YES];
}

// Failed with an error
- (void) matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError*)error
{
  [rootViewController dismissModalViewControllerAnimated:YES];
  NSLog(@"Error:  Couldn't find match: %@", error.localizedDescription);
}

// An opponent has been found
- (void) matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch*)myMatch
{
  [rootViewController dismissModalViewControllerAnimated:YES];
  self.match = myMatch;
  myMatch.delegate = self;
  if (!matchStarted && myMatch.expectedPlayerCount == 0)
  {
    NSLog(@"Ready to start");
  }
}


/*
 ********** Callback methods for GKMatchDelegate **********
 */

// Another player sends data to game
- (void) match: (GKMatch*) myMatch didReceiveData:(NSData*)data fromPlayer:(NSString*)playerID
{
  if (match != myMatch) return;
  [self match:myMatch didReceiveData:data fromPlayer:playerID];
}

//  Makes sure all players are connected
- (void) match: (GKMatch*)myMatch player:(NSString*) playerID didChangeState:(GKPlayerConnectionState)state
{
  if (match != myMatch) return;
  switch (state)
  {
    case GKPlayerStateConnected:
      if (!matchStarted && myMatch.expectedPlayerCount == 0)
      {
        NSLog(@"Ready to start");
      }
      break;
      
    case GKPlayerStateDisconnected:
      NSLog(@"Player disconnected");
      matchStarted = NO;
      [self matchEnded];
      break;
  }
}

// Error with connection
- (void) match:(GKMatch*)myMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError*)error
{
  if (match != myMatch) return;
  NSLog(@"Failed to connect: %@", error.localizedDescription);
  [self matchEnded];
}

// Failure due to error
- (void) match:(GKMatch*) myMatch didFailWithError:(NSError*)error
{
  if (match != myMatch) return;
  NSLog(@"Match failed with error: %@", error.localizedDescription);
  matchStarted = NO;
  [self matchEnded];
}


/*
 ********** Helper Functions **********
 */

- (BOOL) isGameCenterAvailable
{
  BOOL localPlayerClassAvailable = (NSClassFromString(@"GKLocalPlayer")) != nil;
  NSString* reqSysVer = @"4.1";
  NSString* currSysVer = [[UIDevice currentDevice] systemVersion];
  BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
  NSLog(@"GameCenter: %@", gameCenterAvailable ? @"Available" : @"Unavailable");
  return (localPlayerClassAvailable && osVersionSupported);
}

- (void) setError:(NSError*) error
{
  [lastError release];
  lastError = [error copy];
  if (lastError)
  {
    NSLog(@"GCHub Error: %@", [[lastError userInfo] description]);
  }
}

- (void) loadPlayerData: (NSArray *) identifiers
{
  [GKPlayer loadPlayersForIdentifiers:identifiers withCompletionHandler:^(NSArray *players, NSError *error) {
    if (error != nil)
    {
      [self setError:error];
    }
    if (players != nil)
    {
      // Process the array of GKPlayer objects.
    }
  }];
}

@end
