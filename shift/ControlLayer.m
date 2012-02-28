//
//  ControlLayer.m
//  shift
//
//  Created by Akash Narkhede on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ControlLayer.h"

@implementation ControlLayer

- (id) init 
{
    if ((self = [super init])) {
        // Enable touch
        self.isTouchEnabled = YES;
        
        // Create buttons
        NSString *resetButtonFileName = [NSString stringWithFormat:@"button_reset.png"];
        CCTexture2D *resetButtonTexture = [[CCTextureCache sharedTextureCache] addImage:resetButtonFileName];
        resetButton = [CCSprite spriteWithTexture:resetButtonTexture];
        
        NSString *menuButtonFileName = [NSString stringWithFormat:@"button_menu.png"];
        CCTexture2D *menuButtonTexture = [[CCTextureCache sharedTextureCache] addImage:menuButtonFileName];
        menuButton = [CCSprite spriteWithTexture:menuButtonTexture];
        
        // Get screen size
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        float screenWidth = screenSize.width;
        float screenHeight = screenSize.height;
        
        // Resize images
        float scaleX = 0.3;
        float scaleY = 0.3;
        
        menuButton.scaleX = scaleX;
        menuButton.scaleY = scaleY;
        
        resetButton.scaleX = scaleX;
        resetButton.scaleY = scaleY;
        
        // Get width and height of buttons
        float resetButtonWidth = CGRectGetWidth([resetButton boundingBox]);
        float resetButtonHeight = CGRectGetHeight([resetButton boundingBox]);
        
        float menuButtonWidth = CGRectGetWidth([menuButton boundingBox]);
        float menuButtonHeight = CGRectGetHeight([menuButton boundingBox]);
        
        
        
        // Set button positions
        resetButton.position = ccp(screenWidth - resetButtonWidth, 
                                   screenHeight - resetButtonHeight);
        menuButton.position = ccp(screenWidth - menuButtonWidth, 
                                  screenHeight - menuButtonHeight - resetButtonHeight);
        
        [self addChild:resetButton];
        [self addChild:menuButton];
    }
    return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (CGRectContainsPoint([resetButton boundingBox], location)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetButtonPressed" object:self];
    } else if (CGRectContainsPoint([menuButton boundingBox], location)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuButtonPressed" object:self];
    }
}




@end
