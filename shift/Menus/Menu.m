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
    }
    return self;
}

+(id) scene {
    CCScene *scene = [CCScene node];
    [scene addChild:[[BackgroundLayer alloc] init] z:-1];
    [scene addChild:[[[self class] alloc] init]];
    return scene;
}

//Create scene with the given layer
+(id) sceneWithMenu:(Menu *)menu
{
    CCScene *scene = [CCScene node];
    [scene addChild:[[BackgroundLayer alloc] init] z:-1];
    [scene addChild:menu];
    return scene;
}

- (void) goBack: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:kSceneTransitionTime scene:[MainMenu scene]]];
}

@end
