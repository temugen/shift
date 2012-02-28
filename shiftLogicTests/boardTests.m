//
//  boardTests.m
//  shift
//
//  Created by Brad Misik on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "boardTests.h"

@implementation boardTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    board = [[BoardLayer boardWithFilename:@"test.plist" center:CGPointMake(0, 0) cellSize:CGSizeMake(10, 10)] retain];
    block = [board blockAtX:1 y:1];
}

- (void)tearDown
{
    // Tear-down code here.
    [board release];
    
    [super tearDown];
}

- (void)testShiftRow
{
    [board shiftRowAtY:block.row x:block.column numberOfCells:1];
    STAssertEquals(block.column, 2, @"Block doesn't know it was shifted right");
    STAssertEquals(block, [board blockAtX:2 y:1], @"Board doesn't know block was shifted right");
    
    [board shiftRowAtY:block.row x:block.column numberOfCells:-1];
    STAssertEquals(block.column, 1, @"Block doesn't know it was shifted left");
    STAssertEquals(block, [board blockAtX:1 y:1], @"Board doesn't know block was shifted left");
}

- (void)testShiftColumn
{
    [board shiftColumnAtX:block.column y:block.row numberOfCells:1];
    STAssertEquals(block.row, 2, @"Block doesn't know it was shifted up");
    STAssertEquals(block, [board blockAtX:1 y:2], @"Board doesn't know block was shifted up");
    
    [board shiftColumnAtX:block.column y:block.row numberOfCells:-1];
    STAssertEquals(block.row, 1, @"Block doesn't know it was shifted down");
    STAssertEquals(block, [board blockAtX:1 y:1], @"Board doesn't know block was shifted down");
}

-(void)testIncompleteBoard
{
    BOOL result = [board isComplete]; 
    STAssertFalse(result, @"Board believes it is complete");
}

-(void)testCompletedBoard
{
    BoardLayer *completeBoard = [[BoardLayer boardWithFilename:@"completeBoard.plist" 
                                                        center:CGPointMake(0, 0) 
                                                      cellSize:CGSizeMake(10, 10)] retain];
    BOOL result = [completeBoard isComplete]; 
    STAssertTrue(result, @"Board doesn't believe it is complete");
}

-(void)testCompletedBoardWithSpecialBlocks
{
    BoardLayer *completeBoard = [[BoardLayer boardWithFilename:@"completeBoard.plist" 
                                                        center:CGPointMake(0, 0) 
                                                      cellSize:CGSizeMake(10, 10)] retain];
    BlockSprite *stationary = [StationaryBlock blockWithName:@"stationary"];
    [board setBlock:stationary x:2 y:2];
    BlockSprite *rotation = [RotationBlock blockWithName:@"rotation"];
    [board setBlock:rotation x:2 y:1];
    
    BOOL result = [completeBoard isComplete]; 
    STAssertTrue(result, @"Board doesn't believe it is complete");    
}

-(void)testSetKeyAtX
{
    BOOL result = [board setKeyAtX:2 y:2];
    STAssertTrue(result, @"Key should be successfully placed");
}

-(void)testSetKeyOutOfBounds
{
    BOOL result = [board setKeyAtX:-1 y:-1];
    STAssertFalse(result, @"Key should not have been successfully placed");
}

-(void)testSetKeyInOccupiedCell
{
    BOOL result = [board setKeyAtX:1 y:1];
    STAssertFalse(result, @"Key should not have been successfully placed");
}

-(void)testInBounds
{
    BOOL result;
    result = [board isOutOfBoundsAtX:1 y:1];
    STAssertFalse(result, @"Location should be in bounds");    
}

-(void)testOutOfBounds
{
    BOOL result;
    result = [board isOutOfBoundsAtX:board.columnCount+10 y:1];
    STAssertTrue(result, @"Location should be out of bounds %d, %d",board.columnCount+10,1);
    
    result = [board isOutOfBoundsAtX:1 y:board.rowCount+10];
    STAssertTrue(result, @"Location should be out of bounds %d, %d",1,board.rowCount+10);
    
    result = [board isOutOfBoundsAtX:-1 y:1];
    STAssertTrue(result, @"Location should be out of bounds %d, %d",-1,1);
    
    result = [board isOutOfBoundsAtX:1 y:-1];
    STAssertTrue(result, @"Location should be out of bounds %d %d",1,-1);
}

@end
