//
//  DifficultyMenu.h
//  shift
//
//  Created by Greg McLain on 2/16/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "cocos2d.h"
#import "Menu.h"
#import "GameConfig.h"


@interface DifficultyMenu : Menu
{
    gamemode mode;
}

-(id) init;
+(id) scene:(gamemode) gameSelection;

@end
