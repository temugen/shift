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
@synthesize comparable, movable;
@synthesize name;

+(id) cellWithFilename:(NSString *)filename
{
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:filename];
    CellSprite *cell = [self spriteWithTexture:texture];
    cell.comparable = YES;
    cell.movable = YES;
    cell.name = @"";
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

-(BOOL) onTouch
{
    NSLog(@"%@ was touched", name);
    return NO;
}

-(BOOL) onDoubleTap
{
    NSLog(@"%@ was double-tapped", name);
    return NO;
}

-(BOOL) onMoveWithDistance:(float)distance vertically:(BOOL)vertically
{
    return NO;
}

-(BOOL) onCollideWithCell:(CellSprite *)cell force:(float)force
{
    if (force > 20.0) {
        NSLog(@"%@ collided with %@ with force %f", name, cell.name, force);
    }
    return NO;
}

@end
