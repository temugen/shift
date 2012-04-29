//
//  InGameMenu.m
//  shift
//
//  Created by Brad Misik on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InGameMenu.h"
#import "BackgroundLayer.h"

@implementation InGameMenu

-(id) init
{
    if ((self = [super init])) {
        buttons = [ButtonList buttonList];
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        [buttons addButtonWithDescription:@"Return to Play" target:self selector:@selector(onPlay:)];
        [buttons addButtonWithDescription:@"Reset Board" target:self selector:@selector(onReset:)];
        [buttons addButtonWithDescription:@"Exit to Main Menu" target:self selector:@selector(onMainMenu:)];
        buttons.position = ccp(screenSize.width / 2, screenSize.height / 2);
        [self addChild:buttons];
        
        [self addChild:[[BackgroundLayer alloc] init] z:-1];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayButtonPressed" object:self];
    [self removeFromParentAndCleanup:YES];
}

-(void) onMainMenu:(id)sender
{
    [self goBack:self];
}

- (void)onEnter
{
	[super onEnter];
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:buttons priority:0 swallowsTouches:YES];
}

- (void)onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:buttons];
	[super onExit];
}

@end
