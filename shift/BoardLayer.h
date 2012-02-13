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

//Describes the current movement occurring on the board
typedef enum {
    kColumn,
    kRow,
    kNone,
    kStarted,
    kLocked
} Movement;

@interface BoardLayer : CCLayer
{
	BlockSprite **blocks;
    GoalSprite **goals;
    CGSize cellSize;
    Movement movement;
    int movingRow, movingColumn;
    
    @public
    CGRect boundingBox;
    int rowCount, columnCount;
}

// returns a CCScene that contains the BoardLayer as the only child
+(CCScene *) scene;

-(id) initRandomWithNumberOfColumns:(int)columns rows:(int)rows cellSize:(CGSize)size;
-(id) initWithFilename:(NSString *)filename cellSize:(CGSize)size;

-(void)toggleMovementLock;

@end
