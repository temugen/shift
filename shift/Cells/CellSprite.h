//
//  CellSprite.h
//  shift
//
//  Created by Brad Misik on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface CellSprite : CCSprite
{
    @public
	int row, column, health;
    BOOL comparable;
    BOOL movable;
    NSString *name;
}

@property(nonatomic, assign) int row, column, health;
@property(nonatomic, assign) BOOL comparable, movable;
@property(nonatomic, copy) NSString *name;

+(id) cellWithFilename:(NSString *)name;

//Returns scaling factors used to resize
-(CGPoint) resize:(CGSize)size;

//Returns size after scaling
-(CGSize) scaleWithFactors:(CGPoint)factors;

//Override if you want to handle touch events
-(BOOL) onTouch;
-(BOOL) onDoubleTap;
-(BOOL) onMoveWithDistance:(float)distance vertically:(BOOL)vertically;
-(BOOL) onCollideWithCell:(CellSprite *)cell force:(float)force;

@end
