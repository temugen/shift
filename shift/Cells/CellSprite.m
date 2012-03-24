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
@synthesize health;
@synthesize comparable, movable;
@synthesize name;

-(id) initWithFilename:(NSString *)filename
{
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:filename];
    if ((self = [super initWithTexture:texture])) {
        textureFilename = [filename copy];
        comparable = YES;
        movable = YES;
        destructible = NO;
        name = @"";
    }
    return self;
}

-(id) copyWithZone:(NSZone *)zone
{
    CellSprite *cell = [[[self class] alloc] initWithFilename:textureFilename];
    [cell resize:[self boundingBox].size];
    cell.name = name;
    cell.column = column;
    cell.row = row;
    cell.health = health;
    cell.comparable = comparable;
    cell.movable = movable;
    [cell setColor:self.color];
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

-(BOOL) onCompareWithCell:(CellSprite *)cell
{
    if (cell == nil || ![cell.name isEqualToString:name]) {
        return false;
    }
    return true;
}

-(BOOL) onTap
{
    NSLog(@"%@ was tapped", name);
    return NO;
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
