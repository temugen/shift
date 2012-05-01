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

-(void) onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super onExit];
}

-(void) clearAllMessages
{
    if ([tutorials count] <= 0) {
        return;
    }
    
    [self clearCurrentMessage];
    
    [tutorials removeAllObjects];
}

-(void) clearCurrentMessage
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
    
    [tutorials removeObject:currentTutorial];
    currentTutorial = nil;
}

-(void) displayNext
{
    [self clearCurrentMessage];
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    if ([tutorials count] <= 0) {
        return;
    }
         
    currentTutorial = [tutorials objectAtIndex:0];
    
    CellSprite *cell = [currentTutorial.cell copy];
    [self addChild:cell];
    
    CGFloat textWidth = screenSize.width - 5 * platformPadding - CGRectGetWidth(cell.boundingBox);
    CGSize textSize = [currentTutorial.message sizeWithFont:[UIFont fontWithName:@"Helvetica" size:platformFontSize * 0.65]
                                   constrainedToSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                       lineBreakMode:UILineBreakModeWordWrap];
    
    CCLabelTTF *message = [CCLabelTTF labelWithString:currentTutorial.message 
                                           dimensions:textSize
                                            alignment:UITextAlignmentCenter
                                             fontName:@"Helvetica"
                                             fontSize:platformFontSize * 0.65];
    message.color = ccWHITE;
    //[message addStrokeWithSize:1 color:ccWHITE];
    [self addChild:message];

    CGFloat rectHeight = MAX(CGRectGetHeight(cell.boundingBox), CGRectGetHeight(message.boundingBox));
    RoundedRectangle *bg = [[RoundedRectangle alloc] initWithWidth:screenSize.width - (platformPadding * 2)
                                                           height:rectHeight + (2 * platformPadding)
                                                          pressed:NO];
    [self addChild:bg z:-1];
        
    bg.position = ccp(screenSize.width / 2, bg.contentSize.height / 2);
    cell.position = ccp(CGRectGetMinX(bg.boundingBox) + platformPadding + CGRectGetWidth(cell.boundingBox) / 2,
                        CGRectGetMidY(bg.boundingBox));
    message.position = ccp(CGRectGetMaxX(cell.boundingBox) + platformPadding + message.contentSize.width / 2,
                           CGRectGetMidY(bg.boundingBox));
    
    //Should put all of this in a single node to move it at once
    //Slide in to window
    float yDiff = -bg.contentSize.height / 2;
    for (CCNode *child in [NSArray arrayWithObjects:bg, cell, message, nil]) {
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
    if ([tutorial isEqual:currentTutorial]) {
        [self displayNext];
    }
}

@end
