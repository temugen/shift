//
//  SinglePlayerMenu.h
//  shift
//
//  Created by Greg McLain on 2/15/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "cocos2d.h"
#import "Menu.h"
#import "GameConfig.h"

@interface SinglePlayerMenu : Menu
{
    NSInteger highestLevel;
}

-(id) init;
+(id) scene;

@end
