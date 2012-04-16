//
//  SinglePlayerMenu.h
//  shift
//
//  Created by Greg McLain on 2/15/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "Menu.h"

#define SPRITES_PER_PAGE 4
#define PADDING 40
#define LOCKED -1
#define LEVEL_TEXTURE -1

@interface SinglePlayerMenu : Menu
{
}

+(void)levelSelect:(int)levelNum;

@end
