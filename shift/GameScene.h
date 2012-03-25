//
//  GameScene.h
//  shift
//
//  Created by Brad Misik on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BoardLayer.h"
#import "ControlLayer.h"
#import "BackgroundLayer.h"

@interface GameScene : CCScene
{
    BoardLayer *board;
    CGPoint boardCenter;
    CGSize cellSize;
    
    BackgroundLayer *background;
    ControlLayer *controls;
}
@end
