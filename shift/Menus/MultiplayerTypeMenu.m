//
//  MultiplayerTypeMenu.m
//  shift
//
//  Created by Brad Misik on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MultiplayerTypeMenu.h"
#import "ButtonList.h"
#import "MultiplayerMenu.h"
#import "MultiplayerGame.h"

@implementation MultiplayerTypeMenu

-(id) init
{
    if ((self = [super init])) {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        ButtonList *buttons = [ButtonList buttonList];
        [buttons addButtonWithDescription:@"Easy" target:self selector:@selector(onEasy:)];
        [buttons addButtonWithDescription:@"Medium" target:self selector:@selector(onMedium:)];
        [buttons addButtonWithDescription:@"Hard" target:self selector:@selector(onHard:)];
    
        buttons.position = ccp(screenSize.width / 2, screenSize.height / 2);
        [self addChild:buttons];
    }
    
    return self;
}

-(id) initWithMatch:(GKTurnBasedMatch*) myMatch
{
    if ((self = [self init])) 
    {
        match = myMatch;
    }
    return self;
}

//Create scene with quickplay menu
+(id) sceneWithMatch:(GKTurnBasedMatch*) match
{
    MultiplayerTypeMenu *menu = [[MultiplayerTypeMenu alloc] initWithMatch:match];
    return [Menu sceneWithMenu:menu];
}

-(void) play:(MultiplayerGame *)game
{
    [[CCDirector sharedDirector] replaceSceneAndCleanup:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:game]];
}

-(void) onEasy:(id)sender
{
  [self play:[MultiplayerGame gameWithDifficulty:@"Easy" match:match]];
}

-(void) onMedium:(id)sender
{
  [self play:[MultiplayerGame gameWithDifficulty:@"Medium" match:match]];

}

-(void) onHard:(id)sender
{
  [self play:[MultiplayerGame gameWithDifficulty:@"Hard" match:match]];
}

-(void) onBack:(id)sender
{
    [[CCDirector sharedDirector] replaceSceneAndCleanup:[CCTransitionSlideInL transitionWithDuration:kSceneTransitionTime scene:[MultiplayerMenu scene]]];
}

@end
