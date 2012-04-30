//
//  BlockTrain.m
//  shift
//
//  Created by Brad Misik on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockTrain.h"
#import "BoardLayer.h"

@interface BlockTrain()

/* Private Functions */
-(void) containMovementAtX:(int)x y:(int)y;
-(void) moveBlocksWithDistance:(float)distance;

@end

@implementation BlockTrain

@synthesize movement;
@synthesize initialRow, initialColumn;
@synthesize blocks;

+(id) trainFromBoard:(BoardLayer *)boardLayer atPoint:(CGPoint)point
{
    return [[BlockTrain alloc] initFromBoard:boardLayer atPoint:point];
}

-(id) initFromBoard:(BoardLayer *)boardLayer atPoint:(CGPoint)point
{
    if ((self = [super init])) {
        board = boardLayer;
        initialRow = [board rowAtPoint:point];
        initialColumn = [board columnAtPoint:point];
        initialLocation = point;
        movement = kMovementNone;
        
        blocks = [NSMutableArray arrayWithCapacity:MAX(board.rowCount, board.columnCount)];
    }
    
    return self;
}

-(void) moveTo:(CGPoint)location
{
    float dx = location.x - currentLocation.x, dy = location.y - currentLocation.y;
    
    switch (movement) {
        case kMovementNone:
            //Calculate the displacement of our touch in both x and y directions
            dx = location.x - initialLocation.x;
            dy = location.y - initialLocation.y;
            
            if (ABS(dx - dy) < platformDirectionThreshold)
                break;
            
            if (ABS(dx) > ABS(dy))
                movement = kMovementRow;
            else
                movement = kMovementColumn;
            
            [self containMovementAtX:initialColumn y:initialRow];
            
        case kMovementRow:
        case kMovementColumn:
            [self moveBlocksWithDistance:(movement == kMovementRow ? dx : dy)];
            break;
            
        default:
            break;
    }
    
    currentLocation = location;
}

-(void) containMovementAtX:(int)x y:(int)y
{
    int variable;
    int maxVariable;
    
    //Choose the correct rect min and rect max functions for x and y directions
    switch (movement) {
        case kMovementColumn:
            rectMin = CGRectGetMinY;
            rectMax = CGRectGetMaxY;
            variable = y;
            maxVariable = board.rowCount;
            break;
            
        case kMovementRow:
            rectMin = CGRectGetMinX;
            rectMax = CGRectGetMaxX;
            variable = x;
            maxVariable = board.columnCount;
            break;
            
        default:
            return;
    }
    
    [blocks removeAllObjects];
    lowImmovable = highImmovable = nil;
    lowPositionLimit = 0, highPositionLimit = (movement == kMovementColumn ? board.contentSize.height : board.contentSize.width);
    
    int i, row, column;
    //Find the lowest index block that we can move, and mark the first unmoveable block if it exists
    for (i = variable; i >= 0; i--) {
        if (movement == kMovementColumn) {
            row = i;
            column = x;
        }
        else if (movement == kMovementRow) {
            row = y;
            column = i;
        }
        
        BlockSprite *block = [board blockAtX:column y:row];
        if (block != nil && !block.movable) {
            lowImmovable = block;
            lowPositionLimit = rectMax([lowImmovable boundingBox]);
            break;
        }
    }
    
    //Find all the blocks we can move, and mark the highest unmoveable block if it exists
    for (i = MAX(0, i + 1); i < maxVariable; i++) {
        if (movement == kMovementColumn) {
            row = i;
            column = x;
        }
        else if (movement == kMovementRow) {
            row = y;
            column = i;
        }
        
        BlockSprite *block = [board blockAtX:column y:row];
        if (block != nil && !block.movable) {
            highImmovable = block;
            highPositionLimit = rectMin([highImmovable boundingBox]);
            break;
        }
        else if (block != nil && block.movable) {
            block.blockTrain = self;
            [blocks addObject:block];
        }
    }
    
    //There is nothing to move
    if ([blocks count] == 0) {
        return;
    }
    
    ribbon = [CCRibbon ribbonWithWidth:10 image:@"block_connector.png" length:10000 color:ccc4(255, 255, 255, 255) fade:0.5];
    [board addChild:ribbon z:0];
    BlockSprite *lowBlock = [blocks objectAtIndex:0];
    BlockSprite *highBlock = [blocks objectAtIndex:[blocks count]-1];
    
    CGSize blockSize = [lowBlock boundingBox].size;
    if (movement == kMovementColumn) {
        CGPoint lowMiddleTop = [lowBlock boundingBox].origin;
        lowMiddleTop.x += blockSize.width / 2;
        lowMiddleTop.y += blockSize.height;
        [ribbon addPointAt:lowMiddleTop width:10.0];
        
        CGPoint highMiddleBottom = [highBlock boundingBox].origin;
        highMiddleBottom.x += blockSize.width / 2;
        [ribbon addPointAt:highMiddleBottom width:10.0];
    }
    else if (movement == kMovementRow) {
        CGPoint lowMiddleRight = [lowBlock boundingBox].origin;
        lowMiddleRight.x += blockSize.width;
        lowMiddleRight.y += blockSize.height / 2;
        [ribbon addPointAt:lowMiddleRight width:10.0];
        
        CGPoint highMiddleLeft = [highBlock boundingBox].origin;
        highMiddleLeft.y += blockSize.height / 2;
        [ribbon addPointAt:highMiddleLeft width:10.0];
    }
    
    
}

-(void) moveBlocksWithDistance:(float)distance
{
    //There is nothing to move
    if ([blocks count] == 0) {
        return;
    }
    
    //Get the first and last moving blocks
    BlockSprite *lowBlock = [blocks objectAtIndex:0], *highBlock = [blocks objectAtIndex:[blocks count] - 1];
    
    //This blocks the user from pushing the blocks past a barrier (unmoveable block or board border)
    float limitedDistance;
    BlockSprite *immovable, *block;
    if (distance < 0) {
        limitedDistance = MAX(distance, lowPositionLimit - rectMin([lowBlock boundingBox]));
        immovable = lowImmovable;
        block = lowBlock;
    }
    else {
        limitedDistance = MIN(distance, highPositionLimit - rectMax([highBlock boundingBox]));
        immovable = highImmovable;
        block = highBlock;
    }
    
    //Move all of the moving blocks by distance in the correct direction
    for (BlockSprite *block in blocks) {
        if (movement == kMovementColumn)
            block.position = ccp(block.position.x, block.position.y + limitedDistance);
        else if (movement == kMovementRow)
            block.position = ccp(block.position.x + limitedDistance, block.position.y);
        
        //Let the block know it was moved
        [block onMoveWithDistance:distance vertically:(movement == kMovementColumn)];
    }
    
    //Move the ribbon
    if (movement == kMovementRow)
        ribbon.position = ccp(ribbon.position.x + limitedDistance, ribbon.position.y);
    else if (movement == kMovementColumn)
        ribbon.position = ccp(ribbon.position.x, ribbon.position.y + limitedDistance);
    
    //Let blocks know if they collided with each other
    if (immovable != nil && ABS(limitedDistance) < ABS(distance)) {
        
        //Only show smoke if there is a forceful collision
        if (ABS(distance) > platformMinCollisionForce) {
            CCParticleGalaxy *debris  = [[CCParticleGalaxy alloc] initWithTotalParticles:10];
            [debris setEmitterMode:kCCParticleModeRadius];
            debris.texture = [[CCTextureCache sharedTextureCache] addImage:@"debris.png"];
            
            float position;
            if (distance < 0)
                position = lowPositionLimit;
            else
                position = highPositionLimit;
            
            if (movement == kMovementColumn)
                debris.position = ccp(immovable.position.x, position);
            else if (movement == kMovementRow)
                debris.position = ccp(position, immovable.position.y);
            
            debris.startSize = 10;
            debris.endSize = 15;
            
            ccColor4F white = {1.0, 1.0, 1.0, 1.0};
            debris.startColor = white;
            debris.endColor = white;
            
            debris.life = 0.05;
            debris.duration = 0.05;
            
            debris.emissionRate = 100;
            
            debris.startRadius = 10;
            debris.endRadius = 15;
            
            [board addChild:debris z:10];
            
            [immovable onCollideWithCell:block force:ABS(distance)];
            [block onCollideWithCell:immovable force:ABS(distance)];
        }
    }
}

-(void) snap
{
    if (movement == kMovementSnapped)
        return;
    
    movement = kMovementSnapped;
    
    //There is nothing to snap
    if ([blocks count] == 0) {
        return;
    }
    
    [board removeChild:ribbon cleanup:YES];
    
    BlockSprite *firstBlock = [blocks objectAtIndex:0];
    int firstRow = firstBlock.row, firstColumn = firstBlock.column;
    
    int row,column;
    NSEnumerator *enumerator = [blocks objectEnumerator];
    for (BlockSprite *block in enumerator) {
        //Move the block to the closest cell's position on the board
        column = (int)roundf((block.position.x - board.cellSize.width / 2) / board.cellSize.width);
        row = (int)roundf((block.position.y - board.cellSize.height / 2) / board.cellSize.height);
        
        [board moveBlock:block x:column y:row];
        [block onSnap];
        block.blockTrain = nil;
    }
    
    if (firstBlock.row != firstRow || firstBlock.column != firstColumn) {
        board.moveCount++;
    }
}

@end
