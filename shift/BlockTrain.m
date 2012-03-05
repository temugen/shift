//
//  BlockTrain.m
//  shift
//
//  Created by Brad Misik on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockTrain.h"
#import "BoardLayer.h"

#define directionThreshold 5

@interface BlockTrain()

/* Private Functions */
-(void) containMovementAtX:(int)x y:(int)y;
-(void) moveBlocksWithDistance:(float)distance;
-(void) snapMovingBlocks;

@end

@implementation BlockTrain

+(id) trainFromBoard:(BoardLayer *)boardLayer x:(int)x y:(int)y
{
    return [[[BlockTrain alloc] initFromBoard:boardLayer x:x y:y] autorelease];
}

-(id) initFromBoard:(BoardLayer *)boardLayer x:(int)x y:(int)y
{
    if ((self = [super init])) {
        board.isTouchEnabled = NO;
        movement = kMovementNone;
        self.isTouchEnabled = YES;
        
        totalDx = totalDy = 0;
        board = boardLayer;
        initialRow = y;
        initialColumn = x;
        
        movingBlocks = [[NSMutableArray arrayWithCapacity:MAX(board.rowCount, board.columnCount)] retain];
        
        [board addChild:self];
    }
    
    return self;
}

-(void) dealloc
{
    [movingBlocks release];
    
    [super dealloc];
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Calculate the displacement of our touch in both x and y directions
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	CGPoint prevLocation = [touch previousLocationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	prevLocation = [[CCDirector sharedDirector] convertToGL:prevLocation];
    float dx = location.x - prevLocation.x, dy = location.y - prevLocation.y;
    
    switch (movement) {
        case kMovementNone:
            totalDx += dx;
            totalDy += dy;
            
            if (ABS(totalDx - totalDy) > directionThreshold) {
                if (ABS(totalDx) > ABS(totalDy))
                    movement = kMovementRow;
                else
                    movement = kMovementColumn;
                
                [self containMovementAtX:initialColumn y:initialRow];
            }
            break;
            
        case kMovementRow:
        case kMovementColumn:
            [self moveBlocksWithDistance:(movement == kMovementRow ? dx : dy)];
            break;
            
        default:
            break;
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self snapMovingBlocks];
    self.isTouchEnabled = NO;
    board.isTouchEnabled = YES;
    [board removeChild:self cleanup:YES];
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
    
    [movingBlocks removeAllObjects];
    lowImmovable = highImmovable = nil;
    lowPositionLimit = rectMin(board.boundingBox), highPositionLimit = rectMax(board.boundingBox);
    
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
            [movingBlocks addObject:block];
        }
    }
}

-(void) moveBlocksWithDistance:(float)distance
{
    //There is nothing to move
    if ([movingBlocks count] == 0) {
        return;
    }
    
    //Get the first and last moving blocks
    BlockSprite *lowBlock = [movingBlocks objectAtIndex:0], *highBlock = [movingBlocks objectAtIndex:[movingBlocks count] - 1];
    
    //This blocks the user from pushing the blocks past a barrier (unmoveable block or board border)
    float limitedDistance;
    if (distance < 0) {
        limitedDistance = MAX(distance, lowPositionLimit - rectMin([lowBlock boundingBox]));
        
        //Let blocks know if they collided with each other
        if (lowImmovable != nil && ABS(limitedDistance) < ABS(distance)) {
            [lowImmovable onCollideWithCell:lowBlock force:ABS(distance)];
            [lowBlock onCollideWithCell:lowImmovable force:ABS(distance)];
        }
    }
    else {
        limitedDistance = MIN(distance, highPositionLimit - rectMax([highBlock boundingBox]));
        
        //Let blocks know if they collided with each other
        if (highImmovable != nil && ABS(limitedDistance) < ABS(distance)) {
            [highImmovable onCollideWithCell:highBlock force:ABS(distance)];
            [highBlock onCollideWithCell:highImmovable force:ABS(distance)];
        }
    }
    
    //Move all of the moving blocks by distance in the correct direction
    for (BlockSprite *block in movingBlocks) {
        if (movement == kMovementColumn)
            block.position = ccp(block.position.x, block.position.y + limitedDistance);
        else if (movement == kMovementRow)
            block.position = ccp(block.position.x + limitedDistance, block.position.y);
        
        //Let the block know it was moved
        [block onMoveWithDistance:distance vertically:(movement == kMovementColumn)];
    }
}

-(void) snapMovingBlocks
{
    NSEnumerator *enumerator = [movingBlocks objectEnumerator];
    for (BlockSprite *block in enumerator) {
        //Clear the block's space on the board
        [board setBlock:nil x:block.column y:block.row];
    }
    
    int row,column;
    enumerator = [movingBlocks objectEnumerator];
    for (BlockSprite *block in enumerator) {
        //Move the block to the closest cell's position on the board
        column = (int)roundf((block.position.x - board.cellSize.width / 2 -CGRectGetMinX(board.boundingBox)) / board.cellSize.width);
        row = (int)roundf((block.position.y - board.cellSize.height / 2 - CGRectGetMinY(board.boundingBox)) / board.cellSize.height);
        
        //If there is a block in the cell we want to snap to, shift the tiles back 1 space.
        int vertShift = 0, horizShift = 0;
        if([board blockAtX:column y:row])
        {
            if(block.row > row)
                vertShift = 1;
            else if (block.row < row)
                vertShift = -1;
            else if (block.column > column)
                horizShift = 1;
            else
                horizShift = -1;
        }
        
        block.row = row+vertShift;
        block.column = column+horizShift;
        
        [board setBlock:block x:block.column y:block.row];
    }
    
    //If the user initiated the move, check if they completed the board
    if (self.isTouchEnabled) {
        [board isComplete];
    }
}

@end
