//
//  SinglePlayerGame.m
//  shift
//
//  Created by Brad Misik on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SinglePlayerGame.h"

@implementation SinglePlayerGame

-(id) initWithLevel:(int)level
{
    if ((self = [super init])) {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        NSString *levelFilename = [NSString stringWithFormat:@"%d.plist", level];
        BoardLayer *board = [BoardLayer boardWithFilename:levelFilename center:CGPointMake((screenSize.width / 2), (screenSize.height / 2))
                                                 cellSize:CGSizeMake(40.0, 40.0)];
        [self addChild: board];
    }
    return self;
}

+(SinglePlayerGame *) gameWithLevel:(int)level
{
    return [[[SinglePlayerGame alloc] initWithLevel:level] autorelease];
}
                             
@end
