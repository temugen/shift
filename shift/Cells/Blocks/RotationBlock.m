//
//  RotationBlock.m
//  shift
//
//  Created by Brad Misik on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RotationBlock.h"
#import "BoardLayer.h"

@interface RotationBlockLayer : CCLayer {
    RotationBlock *rotationBlock;
    BoardLayer *board;
    CGPoint center;
    
    NSMutableArray *blocks, *xs, *ys;
    
    float minRadius;
    float startAngle;
    BOOL valid;
    float sectorAngle;
    int lastShift, currentShift;
    BlockSprite *sampleBlock;
    int sampleX, sampleY;
}
@end

@implementation RotationBlockLayer

-(id) initWithRotationBlock:(RotationBlock *)block
{
    if ((self = [super init])) {
        lastShift = 0;
        valid = NO;
        rotationBlock = block;
        center = rotationBlock.position;
        board = (BoardLayer *)rotationBlock.board;
        minRadius = CGRectGetWidth([rotationBlock boundingBox]);
        int column = rotationBlock.column, row = rotationBlock.row;
        
        //Make room for all of the blocks surrounding the rotation block
        blocks = [NSMutableArray arrayWithCapacity:8];
        
        //Store the x positions in order clockwise
        xs = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:column - 1],
                              [NSNumber numberWithInt:column],
                              [NSNumber numberWithInt:column + 1],
                              [NSNumber numberWithInt:column + 1],
                              [NSNumber numberWithInt:column + 1],
                              [NSNumber numberWithInt:column],
                              [NSNumber numberWithInt:column - 1],
                              [NSNumber numberWithInt:column - 1], nil];
        
        //Store the y positions in order clockwise
        ys = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:row + 1],
                              [NSNumber numberWithInt:row + 1],
                              [NSNumber numberWithInt:row + 1],
                              [NSNumber numberWithInt:row],
                              [NSNumber numberWithInt:row - 1],
                              [NSNumber numberWithInt:row - 1],
                              [NSNumber numberWithInt:row - 1],
                              [NSNumber numberWithInt:row], nil];
        
        //Store the indices of all positions off the board
        NSMutableIndexSet *badIndexes = [NSMutableIndexSet indexSet];
        
        for (int i = 0; i < [xs count]; i++) {
            int x = [[xs objectAtIndex:i] intValue], y = [[ys objectAtIndex:i] intValue];
            if (x < 0 || y < 0 || x >= board.columnCount || y >= board.rowCount) {
                [badIndexes addIndex:i];
                continue;
            }
            
            //We can't add nil to NSMutableArray
            BlockSprite *block = [board blockAtX:x y:y];
            if (block == nil) {
                [blocks addObject:[NSNull null]];
            }
            else if(!block.movable) {
                [badIndexes addIndex:i];
            }
            else {
                sampleBlock = block;
                sampleX = sampleBlock.column;
                sampleY = sampleBlock.row;
                [blocks addObject:block];
            }
        }
        
        //Remove the positions off the board
        [xs removeObjectsAtIndexes:badIndexes];
        [ys removeObjectsAtIndexes:badIndexes];
        
        sectorAngle = (2 * M_PI) / [blocks count];
        
        self.isTouchEnabled = YES;
    }
    return self;
}


-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [self convertTouchToNodeSpace:touch];
    float dx = location.x - center.x, dy = location.y - center.y;
    float angle = atan2f(dx, dy);
    float distance = (dx * dx) + (dy * dy);
    
    if (distance < minRadius) {
        valid = NO;
        lastShift = currentShift;
        return;
    }
    else if (!valid) {
        valid = YES;
        startAngle = angle;
    }
    
    float dangle = angle - startAngle;
    currentShift = ((int)roundf(dangle / sectorAngle) + lastShift) % [blocks count];
    
    BOOL hasMoved = NO;
    
    for (int i = 0; i < [blocks count]; i++) {
        BlockSprite *block = [blocks objectAtIndex:i];
        if ([block isEqual:[NSNull null]]) {
            block = nil;
        }
        
        int grabIndex = (i + currentShift) % [blocks count];
        int x = [[xs objectAtIndex:grabIndex] intValue],
            y = [[ys objectAtIndex:grabIndex] intValue];
        
        if (block != nil && (block.column != x || block.row != y)) {
            hasMoved = YES;
        }
        
        [board moveBlock:block x:x y:y];
    }
    
    if (hasMoved) {
        [[SimpleAudioEngine sharedEngine] playEffect:@SFX_ROTATE];
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isTouchEnabled = NO;
    board.isTouchEnabled = YES;
    
    if (sampleBlock.column != sampleX || sampleBlock.row != sampleY) {
        board.moveCount++;
    }
    
    //Remove ourself from the scene
    [board removeChild:self cleanup:YES];
    [board isComplete];
}

@end

@implementation RotationBlock

-(id) initWithName:(NSString *)blockName
{
    NSString *filename = [NSString stringWithFormat:@"block_rotate.png"];
    if ((self = [super initWithFilename:filename])) {
        comparable = NO;
        movable = NO;
        name = blockName;
    }
    return self;
}

-(BOOL) onTouch
{
    self.board.isTouchEnabled = NO;
    
    //Add the input layer to the scene
    RotationBlockLayer *rotationBlockLayer = [[RotationBlockLayer alloc] initWithRotationBlock:self];
    [self.board addChild:rotationBlockLayer];
    
    return NO;
}

@end
