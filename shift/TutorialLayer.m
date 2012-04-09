//
//  TutorialLayer.m
//  shift
//
//  Created by Brad Misik on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TutorialLayer.h"
#import "Tutorial.h"
#import "CellSprite.h"

@implementation TutorialLayer

-(id) init
{
    if ((self = [super init])) {
        tutorials = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onNewTutorial:)
                                                     name:@"NewTutorial"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onTutorialComplete:)
                                                     name:@"TutorialComplete"
                                                   object:nil];
    }
    return self;
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)displayNext
{
    [self removeAllChildrenWithCleanup:YES];
    
    if ([tutorials count] <= 0) {
        return;
    }
         
    Tutorial *tutorial = [tutorials objectAtIndex:0];
    [tutorials removeObjectAtIndex:0];
    
    CellSprite *cell = [tutorial.cell copy];
    cell.position = ccp(CGRectGetWidth(cell.boundingBox) / 2, CGRectGetHeight(cell.boundingBox) / 2);
    [self addChild:cell];
    
    CCLabelTTF *message = [CCLabelTTF labelWithString:tutorial.message fontName:@"Helvetica" fontSize:20];
    message.position = ccp(CGRectGetWidth(cell.boundingBox) + message.contentSize.width / 2,
                           message.contentSize.height / 2);
    [self addChild:message];
}

-(void) onNewTutorial:(NSNotification *)notification
{
    Tutorial *tutorial = [notification object];
    [tutorials addObject:tutorial];
    
    if ([tutorials count] == 1) {
        [self displayNext];
    }
}

-(void) onTutorialComplete:(NSNotification *)notification
{
    Tutorial *tutorial = [notification object];
    [tutorials removeObject:tutorial];
    [self displayNext];
}

@end
