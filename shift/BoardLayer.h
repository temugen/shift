//
//  BoardLayer.h
//  shift
//
//  Created by Brad Misik on 8/17/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"
#import "BlockSprite.h"
#import "GoalSprite.h"

@interface BoardLayer : CCLayer
{
	BlockSprite **blocks;
    GoalSprite **goals;
    NSMutableSet *initialBlocks;
    
    @public
    CGRect boundingBox;
    int rowCount, columnCount;
}

@property(readonly, assign) int rowCount, columnCount;
@property(readonly, assign) CGRect boundingBox;
@property(readonly, assign) CGSize cellSize;

+(BoardLayer *) randomBoardWithNumberOfColumns:(int)columns rows:(int)rows center:(CGPoint)center cellSize:(CGSize)size;
+(BoardLayer *) boardWithFilename:(NSString *)filename center:(CGPoint)center cellSize:(CGSize)size;

-(id) initRandomWithNumberOfColumns:(int)columns rows:(int)rows center:(CGPoint)center cellSize:(CGSize)size;
-(id) initWithFilename:(NSString *)filename center:(CGPoint)center cellSize:(CGSize)size;

-(BlockSprite *) blockAtX:(int)x y:(int)y;
-(void) setBlock:(BlockSprite *)block x:(int)x y:(int)y;
-(BOOL) isComplete;
-(void) removeBlock:(BlockSprite *)block;
-(void) resetBoard;
-(BOOL) isOutOfBoundsAtX:(int)x y:(int)y;
-(CGPoint) locationAtPoint:(CGPoint)point;

@end
