//
//  ControlLayer.m
//  shift
//
//  Created by Akash Narkhede on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ControlLayer.h"
#import "InGameMenu.h"
#import "ColorPalette.h"

@implementation ControlLayer

- (id) init 
{
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
        
        pauseButton = [CCSprite spriteWithFile:@"pause.png"];
        self.isRelativeAnchorPoint = YES;
        self.contentSize = pauseButton.contentSize;
        pauseButton.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        pauseButton.color = [[ColorPalette sharedPalette] colorWithName:@"red" fromPalette:@"_app"];
        [self addChild:pauseButton];
    }
    return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{    
	for (UITouch *touch in touches) {
        CGPoint location = [self convertTouchToNodeSpace:touch];
        
        if (CGRectContainsPoint([pauseButton boundingBox], location)) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PauseButtonPressed" object:self];
        }
    }
}




@end
