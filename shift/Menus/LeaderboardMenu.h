//
//  LeaderboardMenu.h
//  shift
//
//  Created by Alex Chesebro on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Menu.h"
#import "cocos2d.h"

@interface LeaderboardMenu : Menu
{
  gamemode mode;
}
- (id) init;
+ (id) scene:(gamemode) gameSelection;

@end
