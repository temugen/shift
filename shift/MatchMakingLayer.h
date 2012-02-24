//
//  MatchMakingLayer.h
//  shift
//
//  Created by Alex Chesebro on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameCenterHub.h"

@interface MatchMakingLayer : CCLayer <GameCenterMatchmakingDelegate>

- (id) init;
+ (CCScene*) scene;
@end
