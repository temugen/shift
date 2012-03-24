//
//  BlockTrain.h
//  shift
//
//  Created by Brad Misik on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockSprite.h"

@interface BlockTrain : NSObject
{
    NSMutableArray *movingBlocks;
    int initialRow, initialColumn;
    CGPoint initialLocation, currentLocation;
    CGFloat (*rectMin)(CGRect), (*rectMax)(CGRect);
    float lowPositionLimit, highPositionLimit;
    BlockSprite *lowImmovable, *highImmovable;
    
    BoardLayer *board;
    CCRibbon *ribbon;
    
    @public
    Movement movement;
}

+(id) trainFromBoard:(BoardLayer *)boardLayer atPoint:(CGPoint)point;

-(id) initFromBoard:(BoardLayer *)boardLayer atPoint:(CGPoint)point;

-(void) moveTo:(CGPoint)location;
-(void) snap;

@end
