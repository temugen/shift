//
//  BoardLayer.h
//  shift
//
//  Created by Brad Misik on 8/17/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "BlockSprite.h"
#import "GoalSprite.h"

@interface BoardLayer : CCLayer
{
    __unsafe_unretained BlockSprite **blocks;
    __unsafe_unretained GoalSprite **goals;
    NSMutableSet *initialBlocks;
    NSMutableDictionary *blockTrains;
    
    CGPoint corners[4];
    CCSprite *background;
    
    @public
    int rowCount, columnCount, moveCount;
    CCTexture2D *backgroundTexture;
    CGSize cellSize, blockSize;
}

@property(readonly, assign) int rowCount, columnCount;
@property(readonly, assign) CGSize cellSize, blockSize;
@property(readonly) CCTexture2D *backgroundTexture;
@property(readwrite, assign) int moveCount;

+(BoardLayer *) randomBoardWithNumberOfColumns:(int)columns rows:(int)rows cellSize:(CGSize)size;
+(BoardLayer *) boardWithFilename:(NSString *)filename cellSize:(CGSize)size; 

-(id) initRandomWithNumberOfColumns:(int)columns rows:(int)rows cellSize:(CGSize)size;
-(id) initWithFilename:(NSString *)filename cellSize:(CGSize)size;

-(CCSprite *) screenshot;

-(GoalSprite *) goalAtX:(int)x y:(int)y;
-(BlockSprite *) blockAtX:(int)x y:(int)y;
-(void) moveBlock:(BlockSprite *)block x:(int)x y:(int)y;
-(void) removeBlock:(BlockSprite *)block;
-(void) addBlock:(BlockSprite *)block x:(int)x y:(int)y;

-(BOOL) isComplete;
-(void) reset;
-(BOOL) isOutOfBoundsAtX:(int)x y:(int)y;

-(int) rowAtPoint:(CGPoint)point;
-(int) columnAtPoint:(CGPoint)point;

@end
