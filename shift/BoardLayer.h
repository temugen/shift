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
    
    @public
    CGRect boundingBox;
    int rowCount, columnCount;
    CGSize cellSize, blockSize;
}

@property(readonly, assign) int rowCount, columnCount;
@property(readonly, assign) CGRect boundingBox;
@property(readonly, assign) CGSize cellSize, blockSize;

+(BoardLayer *) randomBoardWithNumberOfColumns:(int)columns rows:(int)rows center:(CGPoint)center cellSize:(CGSize)size;
+(BoardLayer *) boardWithFilename:(NSString *)filename center:(CGPoint)center cellSize:(CGSize)size;

-(id) initRandomWithNumberOfColumns:(int)columns rows:(int)rows center:(CGPoint)center cellSize:(CGSize)size;
-(id) initWithFilename:(NSString *)filename center:(CGPoint)center cellSize:(CGSize)size;

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
