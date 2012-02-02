//
//  Block.h
//  shift
//
//  Created by Brad Misik on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface Block : CCSprite {
	int row, column;
}

@property(nonatomic, assign) int row, column;

+(NSArray *) availableBlocks;
-(CGSize) blockSize;
-(bool) collidingWithPoint:(CGPoint)point;

@end
