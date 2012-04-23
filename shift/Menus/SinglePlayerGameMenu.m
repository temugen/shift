//
//  SinglePlayerGameMenu.m
//  shift
//
//  Created by Greg McLain on 4/11/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SinglePlayerGameMenu.h"
#import "SinglePlayerMenu.h"

@implementation SinglePlayerGameMenu

-(id) init
{
    if ((self = [super init])) {        
        [buttons addButtonWithDescription:@"Level Select" target:self selector: @selector(onLevelSelect:)];
    }
    
    return self;
}

-(void) onLevelSelect:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:kSceneTransitionTime 
                                                                                     scene:[SinglePlayerMenu scene]]];
}

@end
