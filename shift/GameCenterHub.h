//
//  GameCenterHub.h
//  shift
//
//  Created by Alex Chesebro on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GameCenterHubDelegate
- (void) matchStarted;
- (void) matchEnded;
- (void) match: (GKMatch*) match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
@end

@interface GameCenterHub : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate>
{ 
  BOOL gameCenterAvailable;
  BOOL userAuthenticated;
  UIViewController* presentingViewController;
  GKMatch* match;
  BOOL matchStarted;
  id <GameCenterHubDelegate> delegate;
}

@property (assign, readonly) BOOL gameCenterAvailable;
@property (retain) UIViewController* presentingViewController;
@property (retain) GKMatch* match;
@property (retain) id <GameCenterHubDelegate> delegate;

+ (GameCenterHub*) sharedInstance;
- (BOOL) isGameCenterAvailable;
- (id) init;
- (void) authenticateLocalPlayer;
- (void) authenticationChanged;
- (void) findMatchWithMinPlayers:(int) minPlayers maxPlayers:(int) maxPlayers viewController:(UIViewController*) viewController delegate:(id<GameCenterHubDelegate>) theDelegate;

@end
