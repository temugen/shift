//
//  Tutorial.m
//  shift
//
//  Created by Brad Misik on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tutorial.h"
#import "CellSprite.h"
#import "BoardLayer.h"

@implementation Tutorial

@synthesize message;

-(id) initWithMessage:(NSString *)msg forCell:(CellSprite *)cell
{
    if ((self = [super init])) {
        message = msg;
        board = (BoardLayer *)cell.parent;
        
        icon = [cell copy];
        icon.position = ccp(CGRectGetWidth([icon boundingBox]) / 2, CGRectGetHeight([icon boundingBox]) / 2);
        [board addChild:icon];
        
        label = [CCLabelTTF labelWithString:msg fontName:@"Helvetica" fontSize:24];
        label.position = ccp(CGRectGetMaxX([icon boundingBox]) + label.contentSize.width / 2,
                             label.contentSize.height / 2);
        [board addChild:label];
    }
    
    return self;
}

-(void) complete
{
    [board removeChild:icon cleanup:YES];
    [board removeChild:label cleanup:YES];
}

@end
