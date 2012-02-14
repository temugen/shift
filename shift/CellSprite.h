//
//  CellSprite.h
//  shift
//
//  Created by Brad Misik on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class BoardLayer;

@interface CellSprite : CCSprite {
    @public
    BoardLayer *board;
	int row, column;
    BOOL comparable;
    BOOL moveable;
    NSString *name;
}

@property(nonatomic, assign) BoardLayer *board;
@property(nonatomic, assign) int row, column;
@property(nonatomic, assign) BOOL comparable, moveable;
@property(nonatomic, assign) NSString *name;

+(id) cellWithFilename:(NSString *)name;

//Returns scaling factors used to resize
-(CGPoint) resize:(CGSize)size;

//Returns size after scaling
-(CGSize) scaleWithFactors:(CGPoint)factors;

//Override and return YES if the board needs to be checked for 
-(BOOL) onClick;

@end
