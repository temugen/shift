//
//  SinglePlayerGame.h
//  shift
//
//  Created by Brad Misik on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "BoardLayer.h"

@interface SinglePlayerGame : CCScene
{
    BoardLayer *board;
    CGPoint boardCenter;
    CGSize cellSize;
    
    int currentLevel;
}

+(SinglePlayerGame *) gameWithLevel:(int)level;

-(id) initWithLevel:(int)level;

@end
