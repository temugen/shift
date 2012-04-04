//
//  Tutorial.h
//  shift
//
//  Created by Brad Misik on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class CellSprite;
@class BoardLayer;

@interface Tutorial : CCNode
{
    CellSprite *icon;
    CCLabelTTF *label;
    BoardLayer *board;
    
    @public
    NSString *message;
}

@property(readonly) NSString *message;

-(id) initWithMessage:(NSString *)msg forCell:(CellSprite *)cell;

-(void) complete;

@end
