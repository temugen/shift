//
//  BoardLayer.h
//  shift
//
//  Created by Brad Misik on 8/17/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


#import "cocos2d.h"
#import "BlockSprite.h"

typedef enum {
    kColumn,
    kRow,
    kNone,
    kStarted
} Movement;

// HelloWorldLayer
@interface BoardLayer : CCLayer
{
	BlockSprite **blocks;
    CGSize blockSize;
    Movement movement;
    int movingIndex;
    
    @public
    CGRect boundingBox;
    int rowCount, columnCount;
}

// returns a CCScene that contains the BoardLayer as the only child
+(CCScene *) scene;

-(id) initWithNumberOfColumns:(int)columns rows:(int)rows blockSize:(CGSize)size;
-(id) initRandomWithNumberOfColumns:(int)columns rows:(int)rows blockSize:(CGSize)size;

@end
