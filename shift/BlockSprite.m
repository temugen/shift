//
//  Block.m
//  shift
//
//  Created by Brad Misik on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "BlockSprite.h"

#define len(array) (sizeof((array))/sizeof(typeof((array[0]))))

static const char *available_images[] = {
    "block_blue.png",
    "block_red.png",
    "block_green.png",
    "block_purple.png",
    "block_yellow.png",
    "block_orange.png"
};

@implementation BlockSprite

@synthesize row, column;

+(id) randomBlock
{
    int randomIndex = arc4random() % len(available_images);
    NSString *filename = [NSString stringWithUTF8String:available_images[randomIndex]];
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:filename];
    BlockSprite *block = [self spriteWithTexture:texture];
    block.anchorPoint = ccp(0, 0);
    return block;
}

-(void) resize:(CGSize)size
{
    self.scaleX = size.width / CGRectGetWidth([self boundingBox]);
    self.scaleY = size.height / CGRectGetHeight([self boundingBox]);
}

@end
