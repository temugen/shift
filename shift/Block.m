//
//  Block.m
//  shift
//
//  Created by Brad Misik on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Block.h"

static NSArray *available_blocks;

@implementation Block

@synthesize row, column;

-(id) init
{
	if ((self = [super init])) {
        available_blocks = [NSArray arrayWithObjects:
                            @"block_blue.png",
                            @"block_red.png",
                            @"block_green.png",
                            @"block_brown.png",
                            @"block_purple.png",
                            @"block_yellow.png",
                            nil];
	}
	return self;
}

-(bool) collidingWithPoint:(CGPoint)point
{
	CGSize size = [self blockSize];
	
	if (point.x >= self.position.x - size.width / 2
		&& point.x <= self.position.x + size.width / 2
		&& point.y >= self.position.y - size.height / 2
		&& point.y <= self.position.y + size.height / 2) {
		return true;
	}
	return false;
}

-(CGSize) blockSize
{
	return CGSizeMake([self boundingBox].size.width, [self boundingBox].size.height);
}

+(NSArray *) availableBlocks
{
	return available_blocks;
}

@end
