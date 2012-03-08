//
//  BlockTrain.h
//  shift
//
//  Created by Brad Misik on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "BlockSprite.h"

@interface BlockTrain : CCLayer
{
    NSMutableArray *movingBlocks;
    int initialRow, initialColumn;
    CGFloat (*rectMin)(CGRect), (*rectMax)(CGRect);
    float lowPositionLimit, highPositionLimit;
    BlockSprite *lowImmovable, *highImmovable; 
    BoardLayer *board;
    float totalDx, totalDy;
    
    CCRibbon *ribbon;
    
    @public
    BOOL rightLeft;
    Movement movement;
}

+(id) trainFromBoard:(BoardLayer *)boardLayer x:(int)x y:(int)y;

-(id) initFromBoard:(BoardLayer *)boardLayer x:(int)x y:(int)y;

@end
