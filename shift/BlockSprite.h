//
//  Block.h
//  shift
//
//  Created by Brad Misik on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "cocos2d.h"

@interface BlockSprite : CCSprite {
    @public
	int row, column;
}

@property(nonatomic, assign) int row, column;

+(id) randomBlock;
-(void) resize:(CGSize)size;

@end
