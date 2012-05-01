//
//  TutorialLayer.h
//  shift
//
//  Created by Brad Misik on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "Tutorial.h"

@interface TutorialLayer : CCLayer
{
    NSMutableArray *tutorials;
    Tutorial *currentTutorial;
}

-(void) clearAllMessages;

@end
