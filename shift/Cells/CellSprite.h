//
//  CellSprite.h
//  shift
//
//  Created by Brad Misik on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tutorial.h"

@class BoardLayer;
@class BlockTrain;

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
    Tutorial *tutorial;
    BoardLayer *board;
    BlockTrain *blockTrain;
}

@property(nonatomic, assign) int row, column;
@property(nonatomic, assign) int health;
@property(nonatomic, assign) BOOL comparable, movable;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, retain) Tutorial *tutorial;
@property(nonatomic, readonly, assign) BoardLayer *board;
@property(nonatomic, retain) BlockTrain *blockTrain;

-(id) initWithFilename:(NSString *)filename;

//Returns scaling factors used to resize
-(CGPoint) resize:(CGSize)size;
//Returns size after scaling
-(CGSize) scaleWithFactors:(CGPoint)factors;

-(void) completeTutorial;

-(BoardLayer *) board;

//Override if you want to handle events
-(BOOL) onCompareWithCell:(CellSprite *)cell;
-(BOOL) onTouch;
-(BOOL) onTap;
-(BOOL) onDoubleTap;
-(BOOL) onMoveWithDistance:(float)distance vertically:(BOOL)vertically;
-(BOOL) onCollideWithCell:(CellSprite *)cell force:(float)force;
-(BOOL) onSnap;

@end
