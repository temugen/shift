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
#import "RotationBlock.h"
#import "UniversalConstants.h"

//Describes the current movement occurring on the board
typedef enum {
    kColumn,
    kRow,
    kNone,
    kStarted
} Movement;

@interface BoardLayer : CCLayer
{
	BlockSprite **blocks;
    GoalSprite **goals;
    
    CGSize cellSize;
    
    Movement movement;
    NSMutableArray *movingBlocks;
    CGFloat (*rectMin)(CGRect), (*rectMax)(CGRect);
    float lowPositionLimit, highPositionLimit;
    BlockSprite *lowImmovable, *highImmovable;
    
    @public
    CGRect boundingBox;
    int rowCount, columnCount;
}

@property(readonly, assign) int rowCount, columnCount;
@property(readonly, assign) CGRect boundingBox;

+(BoardLayer *) randomBoardWithNumberOfColumns:(int)columns rows:(int)rows center:(CGPoint)center cellSize:(CGSize)size;
+(BoardLayer *) boardWithFilename:(NSString *)filename center:(CGPoint)center cellSize:(CGSize)size;

-(id) initRandomWithNumberOfColumns:(int)columns rows:(int)rows center:(CGPoint)center cellSize:(CGSize)size;
-(id) initWithFilename:(NSString *)filename center:(CGPoint)center cellSize:(CGSize)size;

-(BlockSprite *) blockAtX:(int)x y:(int)y;
-(void) setBlock:(BlockSprite *)block x:(int)x y:(int)y;
-(BOOL) isComplete;

@end
