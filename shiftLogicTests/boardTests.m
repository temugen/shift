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

@end
