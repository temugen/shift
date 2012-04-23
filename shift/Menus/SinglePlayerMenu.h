//
//  SinglePlayerMenu.h
//  shift
//
//  Created by Greg McLain on 2/15/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "Menu.h"
#import "CCScrollLayer.h"
#import "RoundedRectangle.h"

@interface SinglePlayerMenu : Menu
{
    CCScrollLayer* scroller;
    CCSprite* highlightedSprite;
}

-(void)loadLevel:(int) levelNum;

@end
