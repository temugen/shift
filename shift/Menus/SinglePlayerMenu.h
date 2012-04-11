//
//  SinglePlayerMenu.h
//  shift
//
//  Created by Greg McLain on 2/15/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "cocos2d.h"
#import "Menu.h"

@interface SinglePlayerMenu : Menu
{
}

+(void) createGradient:(CGRect) rect;
+(void)levelSelect:(int)levelNum;
+(CCSprite*) createRectForWidth:(int)width height:(int)height;

@end
