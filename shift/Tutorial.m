//
//  TutorialLayer.m
//  shift
//
//  Created by Brad Misik on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tutorial.h"
#import "CellSprite.h"

@implementation Tutorial

@synthesize cell;
@synthesize message;

-(id) initWithMessage:(NSString *)msg forCell:(CellSprite *)tutorialCell
{
    if ((self = [super init])) {
        message = msg;
        cell = [tutorialCell copy];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewTutorial" object:self];
    }
    return self;
}

-(void) complete
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialComplete" object:self];
}

@end
