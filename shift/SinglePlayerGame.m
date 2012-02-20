//
//  SinglePlayerGame.m
//  shift
//
//  Created by Brad Misik on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SinglePlayerGame.h"

@implementation SinglePlayerGame

+(SinglePlayerGame *) gameWithLevel:(int)level
{
    return [[[SinglePlayerGame alloc] initWithLevel:level] autorelease];
}

-(id) initWithLevel:(int)level
{
    if ((self = [super init])) {
        currentLevel = level;
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        boardCenter = CGPointMake((screenSize.width / 2), (screenSize.height / 2));
        cellSize = CGSizeMake(40.0, 40.0);
        
        board = [BoardLayer boardWithFilename:[NSString stringWithFormat:@"%d.plist", currentLevel]
                                       center:boardCenter
                                     cellSize:cellSize];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onBoardComplete:)
                                                     name:@"BoardComplete"
                                                   object:nil];
        
        [self addChild:board];
    }
    return self;
}

-(void) onBoardComplete:(NSNotification *)notification
{
    [self removeChild:board cleanup:YES];
    currentLevel++;
    board = [BoardLayer boardWithFilename:[NSString stringWithFormat:@"%d.plist", currentLevel]
                                   center:boardCenter
                                 cellSize:cellSize];
    [self addChild:board];
}
                             
@end
