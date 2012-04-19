//
//  DifficultyMenu.m
//  shift
//
//  Created by Greg McLain on 2/16/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "DifficultyMenu.h"
#import "QuickPlayGame.h"
#import "MainMenu.h"
#import "MultiplayerMenu.h"
#import "MultiplayerGame.h"
#import "GameCenterHub.h"
#import "ButtonList.h"

@implementation DifficultyMenu

//Initialize the Quickplay layer
-(id) init
{
    if ((self = [super init])) 
    {  
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        ButtonList *buttons = [ButtonList buttonList];
        [buttons addButtonWithDescription:@"Easy" target:self selector:@selector(onEasy:)];
        [buttons addButtonWithDescription:@"Medium" target:self selector:@selector(onMedium:)];
        [buttons addButtonWithDescription:@"Hard" target:self selector:@selector(onHard:)];
        buttons.position = ccp(screenSize.width / 2, screenSize.height / 2);
        [self addChild:buttons];
        
        QuickPlayGame *lastGame = [QuickPlayGame lastGame];
        if (lastGame != nil) 
        {
            [buttons addButtonWithDescription:@"Continue" target:self selector:@selector(onContinue:)];
        }
         
        [self addBackButton];
    }
    return self;
}

-(void) play:(QuickPlayGame *)game
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:game]];
}

-(void) onEasy:(id)sender
{
    [self play:[QuickPlayGame gameWithNumberOfRows:kDifficultyEasy columns:kDifficultyEasy]];
}

-(void) onMedium:(id)sender
{
    [self play:[QuickPlayGame gameWithNumberOfRows:kDifficultyMedium columns:kDifficultyMedium]];
}

-(void) onHard:(id)sender
{
    [self play:[QuickPlayGame gameWithNumberOfRows:kDifficultyHard columns:kDifficultyHard]];
}

-(void) onContinue:(id)sender
{
    [self play:[QuickPlayGame lastGame]];
}


@end
