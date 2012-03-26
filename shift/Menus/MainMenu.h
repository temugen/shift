//
//  MainMenu.h
//  shift
//
//  Created by Greg McLain on 2/14/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "cocos2d.h"
#include "Menu.h"

@interface MainMenu : Menu
{
    CCMenu* menu;
}

-(id) init;
+(id) scene;

@end

@interface TitleLayer : CCLayer
@end
