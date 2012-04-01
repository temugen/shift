//
//  GameScene.h
//  shift
//
//  Created by Brad Misik on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//The in-game background music file
#define BGM_GAME "shift_bg_game.mp3"

#import "BoardLayer.h"
#import "ControlLayer.h"
#import "BackgroundLayer.h"

@interface GameScene : CCScene
{
    BoardLayer *board;
    NSDate *startTime;
    BOOL inGame;
    
    CGPoint boardCenter;
    CGSize cellSize;
    NSTimeInterval elapsedTime;
}

@property(readonly) NSTimeInterval elapsedTime;

-(void) onNextGame;
-(void) onGameStart;
-(void) onGameEnd;

@end
