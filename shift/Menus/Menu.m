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
#import "ColorPalette.h"

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

-(void) addBackButton
{
    CCMenuItemImage *back = [CCMenuItemImage itemFromNormalImage:@"back.png"
                                                  selectedImage:@"back.png" target:self selector: @selector(goBack:)];
    back.color = [[ColorPalette sharedPalette] colorWithName:@"red" fromPalette:@"_app"];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCMenu *menu = [CCMenu menuWithItems:back, nil];
    menu.position = ccp(platformPadding + back.contentSize.width / 2,
                        screenSize.height - platformPadding - back.contentSize.height / 2);
    [self addChild:menu];
}

-(void) goBack:(id)sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:SFX_MENU];
    
    [[CCDirector sharedDirector] replaceSceneAndCleanup:[CCTransitionSlideInL transitionWithDuration:kSceneTransitionTime scene:[MainMenu scene]]];
}

@end
