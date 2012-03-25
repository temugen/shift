//
//  InGameMenu.m
//  shift
//
//  Created by Brad Misik on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InGameMenu.h"

@implementation InGameMenu

-(id) init
{
    if ((self = [super init])) {
        //Set up menu items
        CCMenuItemFont *mainMenu = [CCMenuItemFont itemFromString:@"Exit to Main Menu" target:self selector: @selector(onMainMenu:)];
        CCMenuItemFont *reset = [CCMenuItemFont itemFromString:@"Reset Board" target:self selector: @selector(onReset:)];
        CCMenuItemFont *play = [CCMenuItemFont itemFromString:@"Return to Play" target:self selector: @selector(onPlay:)];
        
        //Add items to menu
        CCMenu *menu = [CCMenu menuWithItems:mainMenu, reset, play, nil];
        
        [menu alignItemsVertically];
        
        //Add menu to main menu layer
        [self addChild: menu];
    }
    
    return self;
}

-(void) onReset:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetButtonPressed" object:self];
    [self onPlay:self];
}

-(void) onPlay:(id)sender
{
    [self.parent removeChild:self cleanup:YES];
}

-(void) onMainMenu:(id)sender
{
    [self goBack:self];
}

@end
