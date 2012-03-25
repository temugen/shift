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
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        corners[0] = ccp(0, 0);
        corners[1] = ccp(0, screenSize.height);
        corners[2] = ccp(screenSize.width, screenSize.height);
        corners[3] = ccp(screenSize.width, 0);
        
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

-(void) draw
{
    //Draw dimmed background screen
    glColor4ub(20, 20, 20, 200);
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, corners);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
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
