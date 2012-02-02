//
//  BoardLayer.h
//  shift
//
//  Created by Brad Misik on 8/17/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Block.h"

// HelloWorldLayer
@interface BoardLayer : CCLayer
{
	Block **blocks;
	int boardWidth, boardHeight;
	int boardX, boardY;
	bool isMovingRow;
	Block *movingBlock;
    CGRect boundingBox;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void) updateBoard;
-(void) destroyBoard;
-(void) randomizeBoardWithWidth:(int)width withHeight:(int)height;
-(Block *) blockWithX:(int)x withY:(int)y;
-(void) setBlock:(Block *)block withX:(int)x withY:(int)y;
-(Block *) blockCollidingWithPoint:(CGPoint)point;

@end
