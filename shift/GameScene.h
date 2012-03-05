//
//  GameScene.h
//  shift
//
//  Created by Brad Misik on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "BoardLayer.h"
#import "ControlLayer.h"

@interface GameScene : CCScene
{
    BoardLayer *board;
    CGPoint boardCenter;
    CGSize cellSize;
    
    ControlLayer *cLayer;
}

@end
