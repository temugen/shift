//
//  CellSprite.h
//  shift
//
//  Created by Brad Misik on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class BoardLayer;

@interface CellSprite : CCSprite <NSCopying>
{
    NSString *textureFilename;
    
    @public
	int row, column;
    int health;
    BOOL comparable;
    BOOL movable;
    BOOL destructible;
    NSString *name;
}

@property(nonatomic, assign) int row, column;
@property(nonatomic, assign) int health;
@property(nonatomic, assign) BOOL comparable, movable;
@property(nonatomic, copy) NSString *name;

-(id) initWithFilename:(NSString *)filename;

//Returns scaling factors used to resize
-(CGPoint) resize:(CGSize)size;
//Returns size after scaling
-(CGSize) scaleWithFactors:(CGPoint)factors;

//Override if you want to handle events
-(BOOL) onCompareWithCell:(CellSprite *)cell;
-(BOOL) onTouch;
-(BOOL) onTap;
-(BOOL) onDoubleTap;
-(BOOL) onMoveWithDistance:(float)distance vertically:(BOOL)vertically;
-(BOOL) onCollideWithCell:(CellSprite *)cell force:(float)force;
-(BOOL) onSnap;

@end
