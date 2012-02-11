//
//  CellSprite.m
//  shift
//
//  Created by Brad Misik on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CellSprite.h"

@implementation CellSprite

@synthesize row, column;

+(id) cellWithFilename:(NSString *)filename
{
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:filename];
    CellSprite *cell = [self spriteWithTexture:texture];
    //cell.anchorPoint = ccp(0, 0);
    return cell;
}

-(CGPoint) resize:(CGSize)size
{
    self.scaleX = size.width / CGRectGetWidth([self boundingBox]);
    self.scaleY = size.height / CGRectGetHeight([self boundingBox]);
    return CGPointMake(self.scaleX, self.scaleY);
}

-(CGSize) scaleWithFactors:(CGPoint)factors
{
    self.scaleX = factors.x;
    self.scaleY = factors.y;
    return [self boundingBox].size;
}

@end
