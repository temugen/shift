//
//  GameCenterHub.h
//  shift
//
//  Created by Alex Chesebro on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameCenterHub : NSObject
{ 
  BOOL gameCenterAvailable;
  BOOL userAuthenticated;
}

@property (assign, readonly) BOOL gameCenterAvailable;

+ (GameCenterHub*) sharedInstance;
- (BOOL) isGameCenterAvailable;
- (void) authenticateLocalPlayer;
- (void) authenticationChanged;
- (id) init;
@end
