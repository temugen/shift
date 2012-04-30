//
//  GameCenterHub.m
//  shift
//
//  Created by Alex Chesebro on 2/20/12.
//  Copyright (c) 2012 __Oh_Shift__. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "GKAchievementNotification/GKAchievementHandler.h"
#import "MultiplayerTypeMenu.h"
#import "MultiplayerGame.h"
#import "GameCenterHub.h"
#import "OhShiftMatchData.h"
#import "MainMenu.h"
#import "MultiplayerResultsMenu.h"

@interface GameCenterHub()

/* Private Functions */
-(id) init;
-(void) enterNewGame:(GKTurnBasedMatch*)match;
-(void) layoutMatch:(GKTurnBasedMatch*)match andIsMyTurn:(BOOL)turn;
-(void) displayResults:(GKTurnBasedMatch*)match;

-(void) achievementViewControllerDidFinish:(GKAchievementViewController*)viewController;
-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController*)viewController;
-(void) turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController*)viewController didFindMatch:(GKTurnBasedMatch*)myMatch; 
-(void) turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController*)viewController; 
-(void) turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController*)viewController 
                        didFailWithError:(NSError *)error; 
-(void) turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController*)viewController playerQuitForMatch:(GKTurnBasedMatch*)myMatch; 
-(GKTurnBasedMatch*) setOutcomeForMatch:(GKTurnBasedMatch*)myMatch andWinnerID:(NSString*)winner;


-(void)handleInviteFromGameCenter:(NSArray*)playersToInvite; 
-(void)handleTurnEventForMatch:(GKTurnBasedMatch*)myMatch; 
-(void)handleMatchEnded:(GKTurnBasedMatch*)myMatch; 

@end


@implementation GameCenterHub

@synthesize achievementDict;
@synthesize notificationCenter;
@synthesize rootViewController;
@synthesize gameCenterAvailable;
@synthesize userAuthenticated;
@synthesize currentMatch;
@synthesize unsentScores;


// Singleton accessor method for the GameCenterHub
//
+(GameCenterHub*) sharedHub
{
  static GameCenterHub* sharedHub = nil;

  if (sharedHub != nil)
    return sharedHub;
  
  @synchronized(self)
  {
    sharedHub = [[GameCenterHub alloc] init];
  }
  return sharedHub;
}


// Default initialization method for GameCenterHub
//
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
      [notificationCenter addObserver:self 
                             selector:@selector(authenticationChanged) 
                                 name:GKPlayerAuthenticationDidChangeNotificationName 
                               object:nil];
    }
  }
  return self;
}


/*
 ********** User Account Functions **********
 */

// Authenticates the local player with Game Center
//
-(void) authenticateLocalPlayer
{
  [self loadAchievements];
  if (!gameCenterAvailable) 
    return;

  // Setup event handler
  void (^setGKEventHandlerDelegate)(NSError *) = ^ (NSError* error)
  {
    GKTurnBasedEventHandler* ev = [GKTurnBasedEventHandler sharedTurnBasedEventHandler];
    ev.delegate = self;
  };

  // Authenticate local player and setup GKEventHandlerDelegate
  if(![GKLocalPlayer localPlayer].isAuthenticated)
  {
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:setGKEventHandlerDelegate];
    NSLog(@"Authenticated user");
  }
  else
  {
    NSLog(@"Already authenticated");
    setGKEventHandlerDelegate(nil);
  }
}


// Handles any events where a players authentication changes
//
-(void) authenticationChanged 
{
  void (^setGKEventHandlerDelegate)(NSError *) = ^ (NSError* error)
  {
    GKTurnBasedEventHandler* ev = [GKTurnBasedEventHandler sharedTurnBasedEventHandler];
    ev.delegate = self;
  };

  [self loadAchievements];
  if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated)
  {
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:setGKEventHandlerDelegate];
    NSLog(@"Auth changed; player authenticated.");
    userAuthenticated = YES;
  }
  else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated)
  {
    NSLog(@"Auth changed; player not authenticated.");
    userAuthenticated = NO;
  }
}



/*
 ********** Achievement Functions **********
 */

// Displays the GKAchievementViewController on the screen
//
-(void) showAchievements
{
  if (!gameCenterAvailable || !userAuthenticated)
  {
    [self displayGameCenterNotification:@"Must be logged into GameCenter to use this"];
    return;
  }
  
  GKAchievementViewController* achievements = [[GKAchievementViewController alloc] init];
  if (achievements != nil)
  {
    achievements.achievementDelegate = self;
    [rootViewController presentModalViewController: achievements animated: YES];
  }
}


// Callback method for the GKAchievementViewController for when the view controller is closed 
//
-(void) achievementViewControllerDidFinish:(GKAchievementViewController*)viewController 
{
  [rootViewController dismissModalViewControllerAnimated:YES];
}


// Loads local cache of achievements and also the GameCenter's cache of achievements.
// Handles any differences between the two and updates both copies
//
-(void) loadAchievements
{  
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* documentsDirectory = [paths objectAtIndex:0];
  NSString* filePath = [documentsDirectory stringByAppendingPathComponent:@"local_achievements"];  
  achievementDict = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];  
  
  if (!gameCenterAvailable || !userAuthenticated) 
    return;
  
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


// Test for an existing achievement identifier in the achievement dictionary
// if not found, then allocates a spot for it
//
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


// Wrapper method for when an achievement is completed by the player.
// 
-(void) achievementCompleted:(NSString *)title message:(NSString*) msg
{
  [[GKAchievementHandler defaultHandler] notifyAchievementTitle:title andMessage:msg];
}


// Sends data to Game Center about the achievement's completetion progress
//
-(void) reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent
{
  // Update local achievement first
  GKAchievement* achievement = [self addOrFindIdentifier:identifier];
  achievement.percentComplete = percent;
  [self saveAchievements];

  if (!gameCenterAvailable || !userAuthenticated)
    return;
  
  [achievement reportAchievementWithCompletionHandler:^(NSError* error)
  {
    if (error != nil)
    {
      NSLog(@"reportAchievementID error: %@", error.description);
    }
  }];
}


// Resets all achievements to 0% progress for the local player
//
- (void) resetAchievements
{  
  // TODO:  Confirm reset
  achievementDict = [[NSMutableDictionary alloc] init];

  if (!gameCenterAvailable || !userAuthenticated)
  {
    [self displayGameCenterNotification:@"Must be logged into GameCenter to use this"];
    return;
  }

  [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
  {
     if (error != nil) 
     {	
       NSLog(@"ResetAchievements: %@", error.description);
     }
  }];
}


// Writes all of the achievement dictionary cache to file for localized cache of achievements
//
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

// Displays the GKLeaderboardViewController on the main screen
//
-(void) showLeaderboard:(NSString*) category
{
  if (!gameCenterAvailable || !userAuthenticated)
  {
    [self displayGameCenterNotification:@"Must be logged into GameCenter to use this"];
    return;
  }
    
  GKLeaderboardViewController* leaderboardVc = [[GKLeaderboardViewController alloc] init];
  if (leaderboardVc != nil)
  {
    leaderboardVc.leaderboardDelegate = self;
    leaderboardVc.category = category;
    leaderboardVc.timeScope = GKLeaderboardTimeScopeAllTime;
    
    [rootViewController presentModalViewController:leaderboardVc animated:YES];
  }
}


// Callback method for the ViewController for when it closes
//
-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
  [rootViewController dismissModalViewControllerAnimated:YES];
}


// Submits a player score to Game Center to be displayed on the leaderboard
// If Game Center is not available or connection is lost, then the score is written
// to file to be sent later
//
-(void) submitScore:(int64_t)score category:(NSString *)category
{
  if (!gameCenterAvailable || !userAuthenticated) 
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


// Writes the unsent scores to file
//
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

// Displays the GKTurnBasedMatchmaker on the main screen 
-(void) showMatchmaker
{
  if (!gameCenterAvailable || !userAuthenticated)
  {
    [self displayGameCenterNotification:@"Must be logged into GameCenter to use this"];
    return;
  }
  
  matchStarted = NO;
  [rootViewController dismissModalViewControllerAnimated:NO];
  
  GKMatchRequest* request = [[GKMatchRequest alloc] init];
  request.minPlayers = 2;
  request.maxPlayers = 2;
  
  GKTurnBasedMatchmakerViewController* matchmakerVc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
  matchmakerVc.turnBasedMatchmakerDelegate = self;
  
  [rootViewController presentModalViewController:matchmakerVc animated:YES];
}


// Clears the GKTurnBasedMatchmaker of all matches, no matter what the status is
//
-(void) clearMatches
{
  if (!gameCenterAvailable || !userAuthenticated)
  {
    [self displayGameCenterNotification:@"Must be logged into GameCenter to use this"];
    return;
  }
  
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


// Tests to see if results for this match exist
//
-(BOOL) matchResultsExist:(NSString*)matchName
{
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* documentsPath = [paths objectAtIndex:0];
  NSString* foofile = [documentsPath stringByAppendingPathComponent:matchName];
  return [[NSFileManager defaultManager] fileExistsAtPath:foofile];
}


// Called when a player enters a new game
//
-(void) enterNewGame:(GKTurnBasedMatch*)match 
{
  [[CCDirector sharedDirector] replaceSceneAndCleanup:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[MultiplayerTypeMenu sceneWithMatch:match]]];
}


// Displays the board of the match
//
-(void) layoutMatch:(GKTurnBasedMatch*)match andIsMyTurn:(BOOL)turn
{
  [[CCDirector sharedDirector] replaceSceneAndCleanup:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[MultiplayerGame gameWithMatchData:match andIsMyTurn:turn]]];
}


// Sends data to the other player and ends your turn
//
-(IBAction)sendTurn:(id)sender data:(NSData*)data
{
  GKTurnBasedMatch* match = self.currentMatch;
  OhShiftMatchData* matchInfo = [[OhShiftMatchData alloc] initWithData:data];
  
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

  if ([matchInfo.difficulty isEqualToString:@"Easy"])
  {
//    [self submitScore:(int64_t)matchInfo.p1moves category:@"easy_moves"];
//   [self submitScore:(int64_t)matchInfo.p1time category:@"easy_time"]; 
  }
  else if ([matchInfo.difficulty isEqualToString:@"Medium"])
  {
//    [self submitScore:(int64_t)matchInfo.p1moves category:@"medium_moves"];
//    [self submitScore:(int64_t)matchInfo.p1time category:@"medium_time"]; 
  }
  else
  {
    [self submitScore:(int64_t)matchInfo.p1moves category:@"hard_moves"];
    [self submitScore:(int64_t)matchInfo.p1time category:@"hard_time"]; 
  }
}


// End of game has been received from the other player so the game
// needs to display the end game results
//
-(void) displayResults:(GKTurnBasedMatch*)myMatch
{
  OhShiftMatchData* match = [[OhShiftMatchData alloc] initWithData:myMatch.matchData];
    
    MultiplayerResultsMenu *results = [[MultiplayerResultsMenu alloc] initWithMatch:match];
    [[CCDirector sharedDirector] replaceSceneAndCleanup:[CCTransitionFade transitionWithDuration:kSceneTransitionTime
                                                                                           scene:[Menu sceneWithMenu:results]
                                                                                       withColor:ccBLACK]];
}


// Sends the starting board and basic information required for a match to begin
//
-(void) sendStartBoard:(NSDictionary*)board match:(GKTurnBasedMatch*)match withDifficulty:(NSString*)difficulty
{
  OhShiftMatchData* matchInfo = [[OhShiftMatchData alloc] initWithPlayerID:[GKLocalPlayer localPlayer].playerID
                                                                     alias:[GKLocalPlayer localPlayer].alias
                                                                difficulty:difficulty 
                                                                  andBoard:board];
  self.currentMatch = match;
  
  [currentMatch endTurnWithNextParticipant:currentMatch.currentParticipant 
                                 matchData:[matchInfo getDataForGameCenter]
                         completionHandler:^(NSError *error) 
   {
     if (error) 
     {
       NSLog(@"SendDataError: %@", error);
     }
   }];
}



// Sends the reuslts for a match when ended on immediately
//
-(void) sendResultsForMatch:(GKTurnBasedMatch*)myMatch withData:(NSData*)data
{
  OhShiftMatchData* matchInfo = [[OhShiftMatchData alloc] initWithData:data];
  
  if (matchInfo.p1time < matchInfo.p2time)
  {
    [self setOutcomeForMatch:myMatch andWinnerID:matchInfo.p1id];
  }
  else
  {
    [self setOutcomeForMatch:myMatch andWinnerID:matchInfo.p2id];
  }

  [myMatch endMatchInTurnWithMatchData:data completionHandler:^(NSError *error) 
   {
     if (error) 
     {
       NSLog(@"SendEndMatchError: %@", error);
     }
     
     [self handleMatchEnded:myMatch]; 
   }];

  
  if ([matchInfo.difficulty isEqualToString:@"Easy"])
  {
    //    [self submitScore:(int64_t)matchInfo.p2moves category:@"easy_moves"];
    //   [self submitScore:(int64_t)matchInfo.p2time category:@"easy_time"]; 
  }
  else if ([matchInfo.difficulty isEqualToString:@"Medium"])
  {
    //    [self submitScore:(int64_t)matchInfo.p2moves category:@"medium_moves"];
    //    [self submitScore:(int64_t)matchInfo.p2time category:@"medium_time"]; 
  }
  else
  {
    [self submitScore:(int64_t)matchInfo.p2moves category:@"hard_moves"];
    [self submitScore:(int64_t)matchInfo.p2time category:@"hard_time"]; 
  }

}


// Sets all of the participant's outcomes for the match before ending
//
-(GKTurnBasedMatch*) setOutcomeForMatch:(GKTurnBasedMatch*)myMatch andWinnerID:(NSString*)winner
{
  for (GKTurnBasedParticipant* participant in myMatch.participants)
  {
    if ([participant.playerID isEqualToString:winner])
    {
      participant.matchOutcome = GKTurnBasedMatchOutcomeWon;
    }
    else
    {
      if (participant.matchOutcome != GKTurnBasedMatchOutcomeQuit)
      {
        participant.matchOutcome = GKTurnBasedMatchOutcomeLost;
      }
    }
  }
  
  return myMatch;
}


// Gives player a notice when turns have changed and it is their turn
//
-(void) sendNotice:(NSString*)notice forMatch:(GKTurnBasedMatch*)match
{
  UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Oh Shift!" message:notice delegate:self cancelButtonTitle:@"Ignore" otherButtonTitles:@"View Results", nil];
  self.currentMatch = match;
  [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NSString* title = [alertView buttonTitleAtIndex:buttonIndex];
  if([title isEqualToString:@"View Results"])
  {
      [self displayResults:self.currentMatch];
  }
}



/**
 ********** TurnBasedMatch Functions **********
 */

// Called when user selects a match from the list of matches in GKMatchmakerViewController
//
-(void) turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)myMatch 
{
  [rootViewController dismissModalViewControllerAnimated:YES];
  self.currentMatch = myMatch;
  GKTurnBasedParticipant* firstParticipant = [myMatch.participants objectAtIndex:0];

  // If match is done
  if (myMatch.status == GKTurnBasedMatchStatusEnded)
  {
    [self displayResults:myMatch];
  }
  else
  {
    if (firstParticipant.lastTurnDate)
    {
      if ([myMatch.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) 
      {
        NSLog(@"didFindMatch: My turn");
        [self layoutMatch:myMatch andIsMyTurn:YES];
      } 
      else 
      {
        NSLog(@"didFindMatch: Not my turn");
        [self layoutMatch:myMatch andIsMyTurn:NO];
      }     
    } 
    else 
    {
      NSLog(@"didFindMatch: New Game");
      [self enterNewGame:myMatch];
    }
  }
}


// Called when user hits cancel button in the GKTurnBasedMatchmakerViewController
//
-(void)turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController 
{
  NSLog(@"TBMVC: viewControllerWasCanceled");
  [rootViewController dismissModalViewControllerAnimated:YES];
}


// Called when there is an error in the GKTurnBasedMatchmakerViewController
// EX:  Connection lost
//	
-(void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController 
                        didFailWithError:(NSError *)error 
{
  NSLog(@"TBMVC: didFailWithError");
  [rootViewController dismissModalViewControllerAnimated:YES];
}


// Called when a player removes or just quits a match
//
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
  NSLog(@"TBMVC: playerquitforMatch, %@, %@", myMatch, myMatch.currentParticipant);
  [myMatch participantQuitInTurnWithOutcome: GKTurnBasedMatchOutcomeQuit 
                            nextParticipant:part 
                                  matchData:myMatch.matchData 
                          completionHandler:nil];
}



/**
 ********** Event Handler Functions **********
 */

// Handles any invitations received from GameCenter for match requests
//
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


// Handles any Turn changed events from Game Center
//
-(void)handleTurnEventForMatch:(GKTurnBasedMatch*)myMatch 
{
  NSLog(@"Turn has happened");
  self.currentMatch = myMatch;
  if ([self matchResultsExist:myMatch.matchID])
  {
    OhShiftMatchData* updatedData = [[OhShiftMatchData alloc] initFromFile:myMatch.matchID 
                                                                   andData:myMatch.matchData];
    [self sendResultsForMatch:myMatch withData:[updatedData getDataForGameCenter]];
      
      [self handleMatchEnded:myMatch];
  }
}


// Handles the match end event from Game Center 
//
-(void)handleMatchEnded:(GKTurnBasedMatch*)myMatch 
{
    NSLog(@"This game is over");
    
    OhShiftMatchData* match = [[OhShiftMatchData alloc] initWithData:myMatch.matchData];
    NSString *partnerName;
    if ([match.p1id isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
        partnerName = match.p2alias;
    }
    else {
        partnerName = match.p1alias;
    }
    
    [self sendNotice:[NSString stringWithFormat:@"Your game with %@ has ended", partnerName] forMatch:myMatch];
}



/*
 ********** Helper Functions **********
 */

// Checks to see if the iOS version is sufficient and GameCenter is present
//
-(BOOL) isGameCenterAvailable
{
  BOOL localPlayerClassAvailable = (NSClassFromString(@"GKLocalPlayer")) != nil;
  NSString* reqSysVer = @"4.1";
  NSString* currSysVer = [[UIDevice currentDevice] systemVersion];
  BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
  return (localPlayerClassAvailable && osVersionSupported);
}


// Displays a notification to the player
//
-(void) displayGameCenterNotification:(NSString*) message
{
  [[[UIAlertView alloc] initWithTitle:@"GameCenter" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

@end
