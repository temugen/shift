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

@synthesize gameCenterAvailable;
@synthesize presentingViewController;
@synthesize match;
@synthesize delegate;

static GameCenterHub* sharedHelper = nil;

+ (GameCenterHub*) sharedInstance
{
  if (!sharedHelper) 
  {
    sharedHelper = [[GameCenterHub alloc] init];
  }
  return sharedHelper;
}

- (id) init
{
  self = [super init];
  if (self != NULL)
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

- (BOOL) isGameCenterAvailable
{
  // Needs GKLocalPlayer class
  BOOL localPlayerClassAvailable = (NSClassFromString(@"GKLocalPlayer")) != nil;
  
  // requires 4.1
  NSString* reqSysVer = @"4.1";
  NSString* currSysVer = [[UIDevice currentDevice] systemVersion];
  BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch]
                             != NSOrderedAscending);
  return (localPlayerClassAvailable && osVersionSupported);
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

- (void) findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GameCenterHubDelegate>)theDelegate
{
  if (!gameCenterAvailable) return;
  
  matchStarted = NO;
  self.match = nil;
  self.presentingViewController = viewController;
  delegate = theDelegate;
  [presentingViewController dismissModalViewControllerAnimated:NO];
  
  GKMatchRequest* request = [[[GKMatchRequest alloc] init] autorelease];
  request.minPlayers;
  request.maxPlayers;
  
  GKMatchmakerViewController* matchvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];
  matchvc.matchmakerDelegate = self;
  
  [presentingViewController presentModalViewController:matchvc animated:YES];
}

// ====== Callback methods for GKMatchViewController

// Player cancels MM
- (void) matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
  [presentingViewController dismissModalViewControllerAnimated:YES];
}

// Failed with an error
- (void) matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
  [presentingViewController dismissModalViewControllerAnimated:YES];
  NSLog(@"Error:  Couldn't find match: %@", error.localizedDescription);
}

// An opponent has been found
- (void) matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)myMatch
{
  [presentingViewController dismissModalViewControllerAnimated:YES];
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
  [delegate match:myMatch didReceiveData:data fromPlayer:playerID];
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
      [delegate matchEnded];
      break;
  }
}

// Error with connection
- (void) match:(GKMatch*)myMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError*)error
{
  if (match != myMatch) return;
  NSLog(@"Failed to connect: %@", error.localizedDescription);
  [delegate matchEnded];
}

// Failure due to error
- (void) match:(GKMatch*) myMatch didFailWithError:(NSError*)error
{
  if (match != myMatch) return;
  NSLog(@"Match failed with error: %@", error.localizedDescription);
  matchStarted = NO;
  [delegate matchEnded];
}

@end
