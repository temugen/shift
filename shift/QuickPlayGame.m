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
        cellSize = CGSizeMake(40.0, 40.0);
        
        board = [BoardLayer randomBoardWithNumberOfColumns:columnCount
                                                      rows:rowCount
                                                    center:boardCenter
                                                  cellSize:cellSize];
        cLayer = [[[ControlLayer alloc] init] retain];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onBoardComplete:)
                                                     name:@"BoardComplete"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onResetButtonPressed:)
                                                     name:@"ResetButtonPressed"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onMenuButtonPressed:)
                                                     name:@"MenuButtonPressed"
                                                   object:nil];
        
        [self addChild:board];
        [self addChild:cLayer];
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

-(void) onResetButtonPressed:(NSNotification *)notification
{
    NSLog(@"Reset Button Pressed");
    [board resetBoard];
}

-(void) onMenuButtonPressed:(NSNotification *)notification
{
    // TODO: Display menu
    NSLog(@"Menu Button Pressed");
}

@end
