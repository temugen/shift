//
//  CellSprite.h
//  shift
//
//  Created by Brad Misik on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface CellSprite : CCSprite {
    @public
	int row, column;
    Boolean comparable;
    NSString *name;
}

@property(nonatomic, assign) int row, column;
@property(nonatomic, assign) Boolean comparable;
@property(nonatomic, assign) NSString *name;

+(id) cellWithFilename:(NSString *)name;

//Returns scaling factors used to resize
-(CGPoint) resize:(CGSize)size;

//Returns size after scaling
-(CGSize) scaleWithFactors:(CGPoint)factors;

@end
