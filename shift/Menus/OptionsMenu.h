//
//  OptionsMenu.h
//  shift
//
//  Created by Greg McLain on 2/19/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "cocos2d.h"
#import "Menu.h"

@interface OptionsMenu : Menu
{
    CCMenuItem *_plusItem; 
    CCMenuItem *_minusItem;
}
-(void)addSoundButton;
@end
