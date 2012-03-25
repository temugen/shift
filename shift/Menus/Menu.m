//
//  Menu.m
//  shift
//
//  Created by Greg McLain on 2/15/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "Menu.h"
#import "MainMenu.h"
#import "BackgroundLayer.h"

@implementation Menu


-(id) init
{
    if( (self=[super init] )) {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        corners[0] = ccp(0, 0);
        corners[1] = ccp(0, screenSize.height);
        corners[2] = ccp(screenSize.width, screenSize.height);
        corners[3] = ccp(screenSize.width, 0);
    }
    return self;
}

+(id) scene {
    CCScene *scene = [CCScene node];
    [scene addChild:[[BackgroundLayer alloc] init]];
    [scene addChild:[[[self class] alloc] init] z:1];
    return scene;
}

//Create scene with the given layer
+(id) sceneWithMenu:(Menu *)menu
{
    CCScene *scene = [CCScene node];
    [scene addChild:[[BackgroundLayer alloc] init]];
    [scene addChild:menu z:1];
    return scene;
}

- (void) goBack: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:kSceneTransitionTime scene:[MainMenu scene]]];
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


@end
