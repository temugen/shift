//
//  OptionsMenu.m
//  shift
//
//  Created by Greg McLain on 2/19/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "OptionsMenu.h"

@implementation OptionsMenu

-(id) init
{
    if( (self=[super init] )) {

        CCMenuItemFont *back = [CCMenuItemFont itemFromString:@"Back" target:self selector: @selector(goBack:)]; 
        
        //Add items to menu
        CCMenu *menu = [CCMenu menuWithItems: back, nil];
        
        [menu alignItemsVertically];
        
        [self addChild: menu];        
    }
    return self;
}

@end
