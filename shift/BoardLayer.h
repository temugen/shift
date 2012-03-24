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

-(GoalSprite *) goalAtX:(int)x y:(int)y;

-(BlockSprite *) blockAtX:(int)x y:(int)y;
-(void) setBlock:(BlockSprite *)block x:(int)x y:(int)y;
-(void) removeBlock:(BlockSprite *)block;

-(BOOL) isComplete;
-(void) resetBoard;
-(BOOL) isOutOfBoundsAtX:(int)x y:(int)y;

-(int) rowAtPoint:(CGPoint)point;
-(int) columnAtPoint:(CGPoint)point;

@end
