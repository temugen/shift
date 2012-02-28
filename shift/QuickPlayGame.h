//
//  QuickPlayGame.h
//  shift
//
//  Created by Brad Misik on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "BoardLayer.h"
#import "ControlLayer.h"

@interface QuickPlayGame : CCScene
{
    BoardLayer *board;
    CGPoint boardCenter;
    CGSize cellSize;
    
    ControlLayer *cLayer;
    
    int rowCount, columnCount;
}

+(QuickPlayGame *) gameWithNumberOfRows:(int)rows columns:(int)columns;

-(id) initWithNumberOfRows:(int)rows columns:(int)columns;

@end
