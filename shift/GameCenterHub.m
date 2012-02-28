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

@synthesize rootViewController;
@synthesize gameCenterAvailable;
@synthesize achievements;
@synthesize lastError;
@synthesize lbd;
@synthesize mmd;
@synthesize match;

static GameCenterHub* sharedHelper = nil;

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
      NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
      [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
    }
  }
  return self;
}

- (void) dealloc
{
  [sharedHelper release];
  sharedHelper = nil;
  [cachedAchievements release];
  [achievements release];
  [match release];
  [lastError release];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super dealloc];
}

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

- (void) authenticationChanged 
{
  if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated)
  {
    NSLog(@"Auth changed; player authenticated.");
    userAuthenticated = YES;
  }
  else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated)
  {
    NSLog(@"Auth changed; player not authenticated.");
    userAuthenticated = NO;
  }
}

- (void) authenticateLocalPlayer
{
  if (!gameCenterAvailable) return;
  if([GKLocalPlayer localPlayer].authenticated == NO)
  {
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
  }
}

- (void) findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(RootViewController *)viewController delegate:(id<GameCenterMatchmakingDelegate>)theDelegate
{
  if (!gameCenterAvailable) return;
  
  matchStarted = NO;
  self.match = nil;
  self.rootViewController = viewController;
  mmd = theDelegate;
  [rootViewController dismissModalViewControllerAnimated:NO];
  
  GKMatchRequest* request = [[[GKMatchRequest alloc] init] autorelease];
  
  GKMatchmakerViewController* matchvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];
  matchvc.matchmakerDelegate = self;
  
  [rootViewController presentModalViewController:matchvc animated:YES];
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

- (void) retrieveScoresForPlayers:(NSArray *)players category:(NSString *)category range:(NSRange)range playerScope:(GKLeaderboardPlayerScope)playerScope timeScope:(GKLeaderboardTimeScope)timeScope
{
  if (!gameCenterAvailable) return;
  GKLeaderboard* leaderboard = nil;
  if ([players count] > 0)
  {
    leaderboard = [[[GKLeaderboard alloc] init] autorelease];
  }
  else 
  {
    leaderboard = [[[GKLeaderboard alloc] initWithPlayerIDs:players] autorelease];
    leaderboard.playerScope = playerScope;
    leaderboard.category = category;
  }
  
  if (leaderboard != nil)
  {
    leaderboard.timeScope = timeScope;
    leaderboard.category = category;
    leaderboard.range = range;
    [leaderboard loadScoresWithCompletionHandler:^(NSArray* scores, NSError* error)
     {
       [self setError:error];
     }];
  }
}

- (void) retrieveTopTenAllTimeGlobalScores
{
  [self retrieveScoresForPlayers:nil category:nil range:NSMakeRange(1, 10) playerScope:GKLeaderboardPlayerScopeGlobal timeScope:GKLeaderboardTimeScopeAllTime];
}

- (void) showLeaderboard:(NSString*) category
{
  if (!gameCenterAvailable) return;
  GKLeaderboardViewController* lbvc = [[[GKLeaderboardViewController alloc] init] autorelease];
  if (lbvc != nil)
  {
    lbvc.leaderboardDelegate = self;
    GKLeaderboard* leaderboard = nil;
   
    leaderboard = [[[GKLeaderboard alloc] init] autorelease];
    leaderboard.category = category;
    leaderboard.timeScope = GKLeaderboardTimeScopeAllTime;
    leaderboard.playerScope = GKLeaderboardPlayerScopeGlobal;
    
    [rootViewController presentModalViewController:lbvc animated:YES];
  }
}

- (void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
  [rootViewController dismissModalViewControllerAnimated:YES];
}

- (void) showMatchmakerView
{
  if (!gameCenterAvailable) return;
  GKMatchmakerViewController* mmvc = [[[GKMatchmakerViewController alloc] init] autorelease];
  if (mmvc != nil)
  {
    mmvc.matchmakerDelegate = self;
    [rootViewController presentModalViewController:mmvc animated:YES];
  }
}

// ====== Callback methods for GKMatchViewController

// Player cancels MM
- (void) matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
  [rootViewController dismissModalViewControllerAnimated:YES];
}

// Failed with an error
- (void) matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
  [rootViewController dismissModalViewControllerAnimated:YES];
  NSLog(@"Error:  Couldn't find match: %@", error.localizedDescription);
}

// An opponent has been found
- (void) matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)myMatch
{
  [rootViewController dismissModalViewControllerAnimated:YES];
  self.match = myMatch;
  myMatch.delegate = self;
  if (!matchStarted && myMatch.expectedPlayerCount == 0)
  {
    NSLog(@"Ready to start");
  }
}

// ====== Callback methods for GKMatchDelegate

// Another player sends data to game
- (void) match: (GKMatch*) myMatch didReceiveData:(NSData*)data fromPlayer:(NSString*)playerID
{
  if (match != myMatch) return;
  [mmd match:myMatch didReceiveData:data fromPlayer:playerID];
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
      [mmd matchEnded];
      break;
  }
}

// Error with connection
- (void) match:(GKMatch*)myMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError*)error
{
  if (match != myMatch) return;
  NSLog(@"Failed to connect: %@", error.localizedDescription);
  [mmd matchEnded];
}

// Failure due to error
- (void) match:(GKMatch*) myMatch didFailWithError:(NSError*)error
{
  if (match != myMatch) return;
  NSLog(@"Match failed with error: %@", error.localizedDescription);
  matchStarted = NO;
  [mmd matchEnded];
}

@end
