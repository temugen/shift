//
//  QuickPlayGame.m
//  shift
//
//  Created by Brad Misik on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickPlayGame.h"

@implementation QuickPlayGame

+(QuickPlayGame *) gameWithNumberOfRows:(int)rows columns:(int)columns;
{
    return [[[QuickPlayGame alloc] initWithNumberOfRows:rows columns:columns] autorelease];
}

-(id) initWithNumberOfRows:(int)rows columns:(int)columns
{
    if ((self = [super init])) {
        rowCount = rows;
        columnCount = columns;
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        boardCenter = CGPointMake((screenSize.width / 2), (screenSize.height / 2));
        
        board = [BoardLayer randomBoardWithNumberOfColumns:columnCount
                                                      rows:rowCount
                                                    center:boardCenter
                                                  cellSize:cellSize];
        
        [self addChild:board];
    }
    return self;
}

-(void) onBoardComplete:(NSNotification *)notification
{
    [self removeChild:board cleanup:YES];
    board = [BoardLayer randomBoardWithNumberOfColumns:columnCount
                                                  rows:rowCount
                                                center:boardCenter
                                              cellSize:cellSize];
    [self addChild:board];
}

@end
