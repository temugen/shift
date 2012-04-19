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
@synthesize tutorial;
@synthesize blockTrain;

-(id) initWithFilename:(NSString *)filename
{
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:filename];
    if ((self = [super initWithTexture:texture])) {
        textureFilename = [filename copy];
        comparable = YES;
        movable = YES;
        destructible = NO;
        name = @"";
        tutorial = nil;
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
    cell.tutorial = tutorial;
    cell.color = self.color;
    return cell;
}

-(CGPoint) resize:(CGSize)size
{
    self.scaleX *= size.width / CGRectGetWidth([self boundingBox]);
    self.scaleY *= size.height / CGRectGetHeight([self boundingBox]);
    return CGPointMake(self.scaleX, self.scaleY);
}

-(CGSize) scaleWithFactors:(CGPoint)factors
{
    self.scaleX = factors.x;
    self.scaleY = factors.y;
    return [self boundingBox].size;
}

-(void) completeTutorial
{
    if (tutorial != nil) {
        [tutorial complete];
        tutorial = nil;
    }
}

-(BoardLayer *) board
{
    board = (BoardLayer *)self.parent;
    return board;
}

-(BOOL) onCompareWithCell:(CellSprite *)cell
{
    return NO;
}

-(BOOL) onTap
{
    return NO;
}

-(BOOL) onTouch
{
    return NO;
}

-(BOOL) onDoubleTap
{
    return NO;
}

-(BOOL) onMoveWithDistance:(float)distance vertically:(BOOL)vertically
{
    return NO;
}

-(BOOL) onCollideWithCell:(CellSprite *)cell force:(float)force
{
    return NO;
}

-(BOOL) onSnap
{
    return NO;
}

@end
