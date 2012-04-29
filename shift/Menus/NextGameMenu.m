//
//  NextGameMenu.m
//  shift
//
//  Created by Brad Misik on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NextGameMenu.h"
#import "RoundedRectangle.h"
#import "ButtonList.h"

@implementation NextGameMenu

-(id) initWithMessage:(NSString *)msg time:(NSTimeInterval)time moves:(int)moves
{
    if ((self = [super initWithColor:ccc4(10, 10, 10, 100)])) {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:msg fontName:platformFontName fontSize:platformFontSize*1.25];
        label.color = ccWHITE;
        [label addStrokeWithSize:1 color:ccBLACK];
        
        int min = time / 60;
        float sec = time - (min * 60);
        CCLabelTTF *timeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d:%0.2f", min, sec]
                                                   fontName:platformFontName fontSize:platformFontSize];
        timeLabel.color = ccWHITE;
        [timeLabel addStrokeWithSize:1 color:ccBLACK];
        
        CCLabelTTF *movesLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d moves", moves]
                                                    fontName:platformFontName fontSize:platformFontSize];
        movesLabel.color = ccWHITE;
        [movesLabel addStrokeWithSize:1 color:ccBLACK];
        
        buttons = [ButtonList buttonList];
        [buttons addButtonWithDescription:@"Continue" target:self selector:@selector(onContinue:)];
        
        float boxHeight = label.contentSize.height + timeLabel.contentSize.height + movesLabel.contentSize.height + buttons.contentSize.height + (platformPadding * 5);
        float boxWidth = MAX(label.contentSize.width, MAX(timeLabel.contentSize.width, MAX(movesLabel.contentSize.width, buttons.contentSize.width))) + (platformPadding * 2);
        
        label.position = ccp(screenSize.width / 2, screenSize.height / 2 + boxHeight / 2 - label.contentSize.height / 2 - platformPadding);
        timeLabel.position = ccp(label.position.x, label.position.y - label.contentSize.height / 2 - timeLabel.contentSize.height / 2 - platformPadding);
        movesLabel.position = ccp(label.position.x, timeLabel.position.y - timeLabel.contentSize.height / 2 - movesLabel.contentSize.height / 2 - platformPadding);
        buttons.position = ccp(label.position.x, movesLabel.position.y - movesLabel.contentSize.height / 2 - buttons.contentSize.height / 2 - platformPadding);
        
        RoundedRectangle *rect = [[RoundedRectangle alloc] initWithWidth:boxWidth height:boxHeight pressed:NO];
        RoundedRectangle *rect2 = [[RoundedRectangle alloc] initWithWidth:boxWidth height:boxHeight pressed:NO];
        rect2.position = rect.position = ccp(screenSize.width / 2, screenSize.height / 2);
        rect2.color = rect.color = ccc3(75, 75, 75);
        rect.flipY = YES;
        
        [self addChild:rect z:-1];
        [self addChild:rect2 z:-1];
        [self addChild:label];
        [self addChild:timeLabel];
        [self addChild:movesLabel];
        [self addChild:buttons];
    }
    
    return self;
}

- (void)onEnter
{
	[super onEnter];
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:buttons priority:0 swallowsTouches:YES];
}

- (void)onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:buttons];
	[super onExit];
}

-(void) onContinue:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NextGameButtonPressed" object:self];
    [self removeFromParentAndCleanup:YES];
}

@end
