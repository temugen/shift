//
//  TutorialLayer.h
//  shift
//
//  Created by Brad Misik on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CellSprite;

@interface Tutorial : NSObject
{
    @public
    CellSprite *cell;
    NSString *message;
}

@property(readonly) CellSprite *cell;
@property(readonly) NSString *message;

-(id) initWithMessage:(NSString *)msg forCell:(CellSprite *)tutorialCell;

-(void) complete;

@end
