//
//  ControlLayer.m
//  shift
//
//  Created by Akash Narkhede on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ControlLayer.h"
#import "InGameMenu.h"

@implementation ControlLayer

- (id) init 
{
    if ((self = [super init])) {
        // Enable touch
        self.isTouchEnabled = YES;
        
        // Create buttons
        NSString *menuButtonFileName = [NSString stringWithFormat:@"pause.png"];
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
        
        // Get width and height of buttons
        float menuButtonWidth = CGRectGetWidth([menuButton boundingBox]);
        float menuButtonHeight = CGRectGetHeight([menuButton boundingBox]);
        
        // Set button positions
        menuButton.position = ccp(screenWidth - menuButtonWidth, 
                                  screenHeight - menuButtonHeight);
        
        [self addChild:menuButton];
    }
    return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        
        if (CGRectContainsPoint([menuButton boundingBox], location)) {
            InGameMenu *menu = [[InGameMenu alloc] init];
            [self addChild:menu];
        }
    }
}




@end
