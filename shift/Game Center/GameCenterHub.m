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
@synthesize currentMatch;

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
    sharedHelper = [super alloc];
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
  sharedHelper = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
 ********** User Account Functions **********
 */

- (void) authenticateLocalPlayer
{
  if (!gameCenterAvailable) return;

  // Setup event handler
  void (^setGKEventHandlerDelegate)(NSError *) = ^ (NSError *error)
  {
    GKTurnBasedEventHandler *ev = [GKTurnBasedEventHandler sharedTurnBasedEventHandler];
    ev.delegate = self;
  };

  // Authenticate local player and setup GKEventHandlerDelegate
  if([GKLocalPlayer localPlayer].authenticated == NO)
  {
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:setGKEventHandlerDelegate];
  }
  else
  {
    NSLog(@"Already authenticated.");
    setGKEventHandlerDelegate(nil);
  }
  
  // Get friends
  [self getPlayerFriends];
}

- (void) authenticationChanged 
{
  if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated)
  {
    NSLog(@"Auth changed; player authenticated.");
    userAuthenticated = YES;
    [self getPlayerFriends];
    [self loadAchievements];
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
  GKFriendRequestComposeViewController* friendRequestVc = [[GKFriendRequestComposeViewController alloc] init];
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
  GKAchievementViewController* achievements = [[GKAchievementViewController alloc] init];
  if (achievements != nil)
  {
    achievements.achievementDelegate = self;
    [rootViewController presentModalViewController: achievements animated: YES];
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
    achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
    [achievementDict setObject:achievement forKey:achievement.identifier];
  }
  return achievement;
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
  GKLeaderboardViewController* leaderboardVc = [[GKLeaderboardViewController alloc] init];
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
  GKScore* myScore = [[GKScore alloc] init];
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
  [rootViewController dismissModalViewControllerAnimated:NO];
  
  GKMatchRequest* request = [[GKMatchRequest alloc] init];
  request.minPlayers = 2;
  request.maxPlayers = 2;
  
  GKTurnBasedMatchmakerViewController* matchmakerVc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
  matchmakerVc.turnBasedMatchmakerDelegate = self;
  
  [rootViewController presentModalViewController:matchmakerVc animated:YES];
}


- (void) enterNewGame:(GKTurnBasedMatch*)match 
{
  // TODO:  Implement method
}
- (void) layoutMatch:(GKTurnBasedMatch*)match
{
  // TODO:  Implement method
  [self checkForEnd:match.matchData];
}

- (void) takeTurn:(GKTurnBasedMatch*)match 
{
  // TODO:  Implement method
  [self checkForEnd:match.matchData];
}

- (void) recieveEndGame:(GKTurnBasedMatch*)match
{
  [self layoutMatch:match];
  // TODO:  Add in data to display final scores
}

- (void) sendNotice:(NSString*)notice forMatch:(GKTurnBasedMatch*)match
{
  UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Your turn in another game" message:notice delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
  [av show];
}

- (void) checkForEnd:(NSData*) data
{
  // TODO:  Implement method 
}


/**
 *  TurnBasedMatchmaker Callbacks
 */
-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)myMatch 
{
  [rootViewController dismissModalViewControllerAnimated:YES];
  self.currentMatch = myMatch;
  GKTurnBasedParticipant* firstParticipant = [myMatch.participants objectAtIndex:0];
  if (firstParticipant.lastTurnDate) 
  {
    if ([myMatch.currentParticipant.playerID 
         isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
      // Your turn
      [self takeTurn:myMatch];
    } else {
      // Not your turn display the game
      [self layoutMatch:myMatch];
    }     
  } else 
  {
    [self enterNewGame:myMatch];
  }
}

-(void)turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController 
{
  [rootViewController dismissModalViewControllerAnimated:YES];
  NSLog(@"has cancelled");
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error 
{
  [rootViewController dismissModalViewControllerAnimated:YES];
  NSLog(@"Error finding match: %@", error.localizedDescription);
}

-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)myMatch 
{
  NSUInteger currentIndex = [myMatch.participants indexOfObject:myMatch.currentParticipant];
  GKTurnBasedParticipant *part;
  
  for (int i = 0; i < [myMatch.participants count]; i++) {
    part = [myMatch.participants objectAtIndex:
            (currentIndex + 1 + i) % myMatch.participants.count];
    if (part.matchOutcome != GKTurnBasedMatchOutcomeQuit) {
      break;
    } 
  }
  NSLog(@"playerquitforMatch, %@, %@", myMatch, myMatch.currentParticipant);
  [myMatch participantQuitInTurnWithOutcome: GKTurnBasedMatchOutcomeQuit nextParticipant:part                                matchData:myMatch.matchData completionHandler:nil];
}

/**
 *  Event Handler
 */

- (void)handleInviteFromGameCenter:(NSArray *)playersToInvite 
{
  [rootViewController dismissModalViewControllerAnimated:YES];
  GKMatchRequest *request = [[GKMatchRequest alloc] init]; 
  request.playersToInvite = playersToInvite;
  request.maxPlayers = 2;
  request.minPlayers = 2;
  GKTurnBasedMatchmakerViewController* viewController = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
  viewController.showExistingMatches = NO;
  viewController.turnBasedMatchmakerDelegate = self;
  [rootViewController presentModalViewController:viewController animated:YES];
}

- (void)handleTurnEventForMatch:(GKTurnBasedMatch*)myMatch 
{
    NSLog(@"Turn has happened");
    if ([myMatch.matchID isEqualToString:currentMatch.matchID]) {
      if ([myMatch.currentParticipant.playerID 
           isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
        // Current game, your turn
        self.currentMatch = myMatch;
        [self takeTurn:myMatch];
      } else {
        // Current game, not your turn
        self.currentMatch = myMatch;
        [self layoutMatch:myMatch];
      }
    } else {
      if ([myMatch.currentParticipant.playerID 
           isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
        // Other game, your turn
        [self sendNotice:@"It's your turn for another match" forMatch:myMatch];
      } 
    }
}

- (void)handleMatchEnded:(GKTurnBasedMatch*)myMatch 
{
  NSLog(@"This game is over");
  if ([myMatch.matchID isEqualToString:currentMatch.matchID]) 
  {
    [self recieveEndGame:myMatch];
  } 
  else 
  {
    [self sendNotice:@"A different game has ended" forMatch:myMatch];
  }
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
