//
//  GameCenterHub.m
//  shift
//
//  Created by Alex Chesebro on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameCenterHub.h"

@implementation GameCenterHub

@synthesize gameCenterAvailable;
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
    userAuthenticated = YES;
  }
  else
  {
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

@end
