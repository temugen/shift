//
//  GameCenterHub.m
//  shift
//
//  Created by Alex Chesebro on 2/20/12.
//  Copyright (c) 2012 __Oh_Shift__. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "GameCenterHub.h"
#import "cocos2d.h"
#import "GKAchievementNotification/GKAchievementHandler.h"
#import "MultiplayerTypeMenu.h"
#import "MainMenu.h"
#import "MultiplayerGame.h"

@implementation GameCenterHub

@synthesize achievementDict;
@synthesize notificationCenter;
@synthesize rootViewController;
@synthesize gameCenterAvailable;
@synthesize currentMatch;
@synthesize unsentScores;


static GameCenterHub* sharedHelper = nil;


+(GameCenterHub*) sharedInstance
{
  if (!sharedHelper) 
  {
    sharedHelper = [[self alloc] init];
  }
  return sharedHelper;
}

+(id) alloc
{
  @synchronized(self)
  {
    NSAssert(sharedHelper == nil, @"Attempted to alloc second GCHub");
    sharedHelper = [super alloc];
    return sharedHelper;
  }
  return nil;
}

-(id) init
{
  if ((self = [super init]))
  {
    userAuthenticated = NO;
    gameCenterAvailable = [self isGameCenterAvailable];
    NSLog(@"GameCenter: %@", gameCenterAvailable ? @"Available" : @"Unavailable");
    achievementDict = [NSMutableDictionary dictionaryWithCapacity:25];
    unsentScores = [NSMutableDictionary dictionaryWithCapacity:25];
    
    if (gameCenterAvailable)
    {
      notificationCenter = [NSNotificationCenter defaultCenter];
      [notificationCenter addObserver:self selector:@selector(authenticationChanged) 
                                 name:GKPlayerAuthenticationDidChangeNotificationName 
                               object:nil];
    }
  }
  return self;
}

-(void) dealloc
{
  sharedHelper = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
 ********** User Account Functions **********
 */

-(void) authenticateLocalPlayer
{
  [self loadAchievements];
  if (!gameCenterAvailable) return;

  // Setup event handler
  void (^setGKEventHandlerDelegate)(NSError *) = ^ (NSError* error)
  {
    GKTurnBasedEventHandler *ev = [GKTurnBasedEventHandler sharedTurnBasedEventHandler];
    ev.delegate = self;
  };

  // Authenticate local player and setup GKEventHandlerDelegate
  if(![GKLocalPlayer localPlayer].isAuthenticated)
  {
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:setGKEventHandlerDelegate];
    [self getPlayerFriends];
    NSLog(@"Authenticated user");
  }
  else
  {
    NSLog(@"Already authenticated");
    setGKEventHandlerDelegate(nil);
  }
}

-(void) authenticationChanged 
{
  [self loadAchievements];
  if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated)
  {
    NSLog(@"Auth changed; player authenticated.");
    userAuthenticated = YES;
    [self loadAchievements];
  }
  else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated)
  {
    NSLog(@"Auth changed; player not authenticated.");
    userAuthenticated = NO;
  }
}

-(void) getPlayerFriends
{
  GKLocalPlayer* me = [GKLocalPlayer localPlayer];
  
  if (me.isAuthenticated)
  {
    [me loadFriendsWithCompletionHandler:^(NSArray* friends, NSError* error) 
    {
      if (error != nil)
      {
        NSLog(@"getPlayerFriendsError: %@", error.description);
        return;
      }
      if (![friends count])
      {
        [self loadPlayerData:friends];
      }
    }];
  }
}

-(void) loadPlayerData:(NSArray*) identifiers
{
  NSLog(@"You have this many friends: %@", [identifiers count]); 
  [GKPlayer loadPlayersForIdentifiers:identifiers 
                withCompletionHandler:^(NSArray* players, NSError* error) 
   {
     if (error != nil)
     {
       NSLog(@"loadPlayerData error: %@", error.description);
     }
     if (players != nil)
     {
       // TODO: Process the array of GKPlayer objects.
     }
   }];
}

-(void) inviteFriends: (NSArray*) identifiers
{
  GKFriendRequestComposeViewController* friendRequestVc = [[GKFriendRequestComposeViewController alloc] init];
  friendRequestVc.composeViewDelegate = self;
  if (identifiers)
  {
    [friendRequestVc addRecipientsWithPlayerIDs: identifiers];
  }
  
  [rootViewController presentModalViewController: friendRequestVc animated: YES];
}

-(void)friendRequestComposeViewControllerDidFinish:(GKFriendRequestComposeViewController*)viewController
{
  [rootViewController dismissModalViewControllerAnimated:YES];
}


/*
 ********** Achievement Functions **********
 */

-(void) showAchievements
{
  GKAchievementViewController* achievements = [[GKAchievementViewController alloc] init];
  if (achievements != nil)
  {
    achievements.achievementDelegate = self;
    [rootViewController presentModalViewController: achievements animated: YES];
  }
}

-(void) achievementViewControllerDidFinish:(GKAchievementViewController*)viewController 
{
  [rootViewController dismissModalViewControllerAnimated:YES];
}

-(void) loadAchievements
{      
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* documentsDirectory = [paths objectAtIndex:0];
  NSString* filePath = [documentsDirectory stringByAppendingPathComponent:@"local_achievements"];  
  achievementDict = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];  
  
  if (![GKLocalPlayer localPlayer].isAuthenticated) return;
  
  [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray* achievements, NSError* error) 
  {
     if (error != nil)
     {
       NSLog(@"loadAchievements error: %@", error.description);
     }
     if (achievements != nil)
     {
       for (GKAchievement* achievement in achievements)
       {
         GKAchievement* local = [self addOrFindIdentifier:achievement.identifier];
         
         if (achievement.percentComplete > local.percentComplete)
         {
           local.percentComplete = achievement.percentComplete;
           [self saveAchievements];
         }
       }
     }
  }];
}

//Tests for existing identifier, if not then allocs it
-(GKAchievement*) addOrFindIdentifier:(NSString*)identifier
{
  GKAchievement* achievement = [achievementDict objectForKey:identifier];
  
  if (achievement == nil)
  {
    achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
    [achievementDict setObject:achievement forKey:identifier];
  }
  
  return achievement;
}

-(void) achievementCompleted:(NSString *)title message:(NSString*) msg
{
  [[GKAchievementHandler defaultHandler] notifyAchievementTitle:title andMessage:msg];
}

-(void) reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent
{
  GKAchievement* achievement = [self addOrFindIdentifier:identifier];
  achievement.percentComplete = percent;
  [achievement reportAchievementWithCompletionHandler:^(NSError* error)
  {
    if (error != nil)
    {
      NSLog(@"reportAchievementID error: %@", error.description);
    }
  }];
  [self saveAchievements];
}

- (void) resetAchievements
{
  // TODO:  Confirm reset
  achievementDict = [[NSMutableDictionary alloc] init];
  [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
  {
     if (error != nil) 
     {	
       NSLog(@"ResetAchievements: %@", error.description);
     }
  }];
}

- (void) saveAchievements
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *achievementPath = [documentsDirectory stringByAppendingPathComponent:@"local_achievements"];
  [NSKeyedArchiver archiveRootObject:achievementDict toFile:achievementPath];
}


/*
 ********** Leaderboard Functions **********
 */

-(void) showLeaderboard:(NSString*) category
{
  if (!gameCenterAvailable || ![GKLocalPlayer localPlayer].isAuthenticated) 
    [self noGameCenterNotification:@"Leaderboards are not available without being logged into Game Center"];
  
  GKLeaderboardViewController* leaderboardVc = [[GKLeaderboardViewController alloc] init];
  if (leaderboardVc != nil)
  {
    leaderboardVc.leaderboardDelegate = self;
    leaderboardVc.category = category;
    leaderboardVc.timeScope = GKLeaderboardTimeScopeAllTime;
    
    [rootViewController presentModalViewController:leaderboardVc animated:YES];
  }
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
  [rootViewController dismissModalViewControllerAnimated:YES];
}

-(void) submitScore:(int64_t)score category:(NSString *)category
{
  if (!gameCenterAvailable || ![GKLocalPlayer localPlayer].isAuthenticated) 
  {
      // Process unsent scores
  }
  else 
  {
    GKScore* myScore = [[GKScore alloc] init];
    myScore.value = score;
    [myScore reportScoreWithCompletionHandler:^(NSError* error)
     {
       NSLog(@"submitScore error: %@", error.description);
     }];  
  }
}

-(void) saveUnsentScores
{
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* documentsDirectory = [paths objectAtIndex:0];
  NSString* scorePath = [documentsDirectory stringByAppendingPathComponent:@"unsent_scores"];
  [NSKeyedArchiver archiveRootObject:unsentScores toFile:scorePath];
}


/*
 ********** Matchmaking functions **********
 */

-(void) findMatch
{
  if (!gameCenterAvailable || ![GKLocalPlayer localPlayer].isAuthenticated)
    [self noGameCenterNotification:@"Matchmaking features are only available with Game Center"];
  
  matchStarted = NO;
  [rootViewController dismissModalViewControllerAnimated:NO];
  
  GKMatchRequest* request = [[GKMatchRequest alloc] init];
  request.minPlayers = 2;
  request.maxPlayers = 2;
  
  GKTurnBasedMatchmakerViewController* matchmakerVc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
  matchmakerVc.turnBasedMatchmakerDelegate = self;
  
  [rootViewController presentModalViewController:matchmakerVc animated:YES];
}


-(void) clearMatches
{
  if ([GKLocalPlayer localPlayer].authenticated)
  {
    [GKTurnBasedMatch loadMatchesWithCompletionHandler:^(NSArray *matches, NSError *error)
     {
       for (GKTurnBasedMatch *match in matches) 
       { 
         NSLog(@"%@", match.matchID); 
         [match removeWithCompletionHandler:^(NSError *error)
          {
            NSLog(@"%@", error);
          }]; 
       }
     }];
  }
}


-(void) enterNewGame:(GKTurnBasedMatch*)match 
{
  NSLog(@"Entering a new game");
  [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[MultiplayerTypeMenu sceneWithMatch:match]]];
}


// Show current match board
-(void) layoutMatch:(GKTurnBasedMatch*)match
{
  [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[MultiplayerGame gameWithMatchData:match]]];

  // TO STOP MOVEMENTS, Board.isTouchEnabled
  // TODO:  Implement method, show current match board
}

 
-(void) takeTurn:(GKTurnBasedMatch*)match 
{
  
}


// Sends data to the other player and ends your turn
-(IBAction)sendTurn:(id)sender data:(NSData*)data
{
  GKTurnBasedMatch* match =  self.currentMatch;
  NSUInteger currentIndex = [currentMatch.participants indexOfObject:match.currentParticipant];
  GKTurnBasedParticipant* nextParticipant = [match.participants objectAtIndex:((currentIndex + 1) % [currentMatch.participants count])];
  [currentMatch endTurnWithNextParticipant:nextParticipant 
                                 matchData:data 
                         completionHandler:^(NSError *error) 
  {
    if (error) 
    {
      NSLog(@"SendDataError: %@", error);
    }
  }];
  [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[MainMenu scene]]];
}


// End of game has been received from the other player
-(void) recieveEndGame:(GKTurnBasedMatch*)match
{
  [self layoutMatch:match];
}


// Gives player a notice when turns have changed and it is there turn
-(void) sendNotice:(NSString*)notice forMatch:(GKTurnBasedMatch*)match
{
  UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Your turn in another game" message:notice delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
  [av show];
}


/**
 ********** TurnBasedMatch Functions **********
 */

// Called when user selects a match from the list of matches in GameCenter
-(void) turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)myMatch 
{
  [rootViewController dismissModalViewControllerAnimated:YES];
  self.currentMatch = myMatch;
  GKTurnBasedParticipant* firstParticipant = [myMatch.participants objectAtIndex:0];
  
  if (firstParticipant.lastTurnDate)
  {
    if ([myMatch.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) 
    {
      [self layoutMatch:myMatch];
    } 
    else 
    {
      [self layoutMatch:myMatch];
    }     
  } 
  else 
  {
    [self enterNewGame:myMatch];
  }
}

// Called when user hits cancel button
-(void)turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController 
{
  [rootViewController dismissModalViewControllerAnimated:YES];
  NSLog(@"has cancelled");
}

// Called when there is an error (ex:  connection loss)
-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error 
{
  [rootViewController dismissModalViewControllerAnimated:YES];
  NSLog(@"Error finding match: %@", error.localizedDescription);
}

// Called when a player removes a match, or just quits a match
-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)myMatch 
{
  NSUInteger currentIndex = [myMatch.participants indexOfObject:myMatch.currentParticipant];
  GKTurnBasedParticipant* part;
  
  for (int i = 0; i < [myMatch.participants count]; i++) {
    part = [myMatch.participants objectAtIndex:(currentIndex + 1 + i) % myMatch.participants.count];
    if (part.matchOutcome != GKTurnBasedMatchOutcomeQuit) 
    {
      break;
    } 
  }
  NSLog(@"playerquitforMatch, %@, %@", myMatch, myMatch.currentParticipant);
  [myMatch participantQuitInTurnWithOutcome: GKTurnBasedMatchOutcomeQuit nextParticipant:part matchData:myMatch.matchData completionHandler:nil];
}

/**
 ********** Event Handler Functions **********
 */

-(void)handleInviteFromGameCenter:(NSArray *)playersToInvite 
{
  [rootViewController dismissModalViewControllerAnimated:YES];
  GKMatchRequest* request = [[GKMatchRequest alloc] init]; 
  request.playersToInvite = playersToInvite;
  request.maxPlayers = 2;
  request.minPlayers = 2;
  
  GKTurnBasedMatchmakerViewController* viewController = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
  viewController.showExistingMatches = NO;
  viewController.turnBasedMatchmakerDelegate = self;
  [rootViewController presentModalViewController:viewController animated:YES];
}

-(void)handleTurnEventForMatch:(GKTurnBasedMatch*)myMatch 
{
    NSLog(@"Turn has happened");
    if ([myMatch.matchID isEqualToString:currentMatch.matchID]) 
    {
      if ([myMatch.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) 
      {
        // Current game, your turn
        self.currentMatch = myMatch;
        [self takeTurn:myMatch];
      } 
      else 
      {
        // Current game, not your turn
        self.currentMatch = myMatch;
        [self layoutMatch:myMatch];
      }
    } 
    else 
    {
      if ([myMatch.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) 
      {
        // Other game, your turn
        [self sendNotice:@"It's your turn for another match" forMatch:myMatch];
      } 
    }
}

-(void)handleMatchEnded:(GKTurnBasedMatch*)myMatch 
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

-(BOOL) isGameCenterAvailable
{
  BOOL localPlayerClassAvailable = (NSClassFromString(@"GKLocalPlayer")) != nil;
  NSString* reqSysVer = @"4.1";
  NSString* currSysVer = [[UIDevice currentDevice] systemVersion];
  BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
  return (localPlayerClassAvailable && osVersionSupported);
}

-(void) noGameCenterNotification:(NSString*) message
{
  [[[UIAlertView alloc] initWithTitle:@"GameCenter Error" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

@end
