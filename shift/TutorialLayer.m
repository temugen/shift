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
#import "RoundedRectangle.h"

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
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    //Slide out of window
    for (CCNode *child in self.children) {
        CGPoint offScreen = ccp(child.position.x, -screenSize.height / 2);
        id actionMove = [CCMoveTo actionWithDuration:1.5 position:offScreen];
        id actionRemove = [CCCallFuncND actionWithTarget:child selector:@selector(removeFromParentAndCleanup:) data:(void *)YES];
        id actionSequence = [CCSequence actions:actionMove, actionRemove, nil];
        [child runAction:actionSequence];
    }
    
    if ([tutorials count] <= 0) {
        return;
    }
         
    Tutorial *tutorial = [tutorials objectAtIndex:0];
    [tutorials removeObjectAtIndex:0];
    
    CellSprite *cell = [tutorial.cell copy];
    [self addChild:cell];
    
    CCLabelTTF *message = [CCLabelTTF labelWithString:tutorial.message fontName:@"Helvetica" fontSize:20];
    [self addChild:message];
    
    RoundedRectangle *bg = [[RoundedRectangle alloc] initWithWidth:screenSize.width - platformPadding
                                                           height:CGRectGetHeight(cell.boundingBox) + (2 * platformPadding)
                                                          pressed:NO];
    [self addChild:bg z:-1];
    
    bg.position = ccp(screenSize.width / 2, bg.contentSize.height / 2);
    cell.position = ccp(CGRectGetMinX(bg.boundingBox) + platformPadding + CGRectGetWidth(cell.boundingBox) / 2,
                        CGRectGetMinY(bg.boundingBox) + platformPadding + CGRectGetHeight(cell.boundingBox) / 2);
    message.position = ccp(CGRectGetMaxX(cell.boundingBox) + platformPadding + message.contentSize.width / 2,
                           CGRectGetMinY(bg.boundingBox) + platformPadding + message.contentSize.height / 2);
    
    //Should put all of this in a single node to move it at once
    //Slide in to window
    float yDiff = -bg.contentSize.height / 2;
    for (CCNode *child in self.children) {
        id actionMove = [CCMoveTo actionWithDuration:1.0 position:child.position];
        child.position = ccp(child.position.x, yDiff);
        [child runAction:actionMove];
    }
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
