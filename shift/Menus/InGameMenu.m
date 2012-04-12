//
//  InGameMenu.m
//  shift
//
//  Created by Brad Misik on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InGameMenu.h"
#import "SinglePlayerMenu.h"

@implementation InGameMenu

-(id) init
{
    if ((self = [super init])) {
        //Pause the background music
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];        
        
        //Set up menu items
        CCMenuItemFont *play = [CCMenuItemFont itemFromString:@"Return to Play" target:self selector: @selector(onPlay:)];
        CCMenuItemFont *reset = [CCMenuItemFont itemFromString:@"Reset Board" target:self selector: @selector(onReset:)];
        CCMenuItemFont *mainMenu = [CCMenuItemFont itemFromString:@"Exit to Main Menu" target:self selector: @selector(onMainMenu:)];
        
        //Add items to menu
        menu = [CCMenu menuWithItems:play,reset,mainMenu, nil];
        
        [menu alignItemsVertically];
        
        //Add menu to main menu layer
        [self addChild: menu];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onPlay:)
                                                     name:@"onPlay"
                                                   object:nil];
    }
    
    return self;
}

-(void) onReset:(id)sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetButtonPressed" object:self];
    [self onPlay:self];
}

-(void) onPlay:(id)sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    
    //Resume the background music
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    
    [self removeFromParentAndCleanup:YES];
}

-(void) onMainMenu:(id)sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    
    [self goBack:self];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) draw
{
    CGPoint corners[4];
    CGSize screenSize = [[CCDirector sharedDirector] displaySizeInPixels];
    corners[0] = ccp(0, 0);
    corners[1] = ccp(0, screenSize.height);
    corners[2] = ccp(screenSize.width, screenSize.height);
    corners[3] = ccp(screenSize.width, 0);
    
    glColor4ub(0, 0, 0, 255);
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, corners);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}

- (void)onEnter
{
	[super onEnter];
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void)onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

@end
