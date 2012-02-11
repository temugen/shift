//
//  BoardLayer.m
//  shift
//
//  Created by Brad Misik on 8/17/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


#import "BoardLayer.h"

@interface BoardLayer()

/* Private Functions */
-(BlockSprite *) blockAtX:(int)x y:(int)y;
-(void) setBlock:(BlockSprite *)block x:(int)x y:(int)y;
-(void) moveColumnAtX:(int)x distance:(float)distance;
-(void) moveRowAtY:(int)y distance:(float)distance;
-(void) snapColumnAtX:(int)x;
-(void) snapRowAtY:(int)y;

@end

@implementation BoardLayer

-(id) initWithNumberOfColumns:(int)columns rows:(int)rows blockSize:(CGSize)size
{
	if((self = [super init])) {
        //Needed to receive touch input callbacks (ccTouchesXXX)
        self.isTouchEnabled = YES;
        
        //Make room in our board array for all of the blocks
        columnCount = columns;
        rowCount = rows;
		blocks = (BlockSprite **)malloc(columnCount * rowCount * sizeof(BlockSprite *));
        
        blockSize = size;
        
        //Initially, no columns or rows are moving
        movement = kNone;
	}
	return self;
}

-(id) initRandomWithNumberOfColumns:(int)columns rows:(int)rows blockSize:(CGSize)size
{	
    if ((self = [self initWithNumberOfColumns:columns rows:rows blockSize:size])) {
        //Calculate the bounding box for the board.
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        boundingBox.size.width = columnCount * blockSize.width;
        boundingBox.size.height = rowCount * blockSize.height;
        boundingBox.origin.x = (screenSize.width / 2) - (CGRectGetWidth(boundingBox) / 2);
        boundingBox.origin.y = (screenSize.height / 2) - (CGRectGetHeight(boundingBox) / 2);
        
        //Fill the board in with new, random blocks
        for (int x = 0; x < columnCount; x++) {
            for (int y = 0; y < rowCount; y++) {
                
                //Keep some blocks clear
                if (arc4random() % 2 == 0) {
                    [self setBlock:nil x:x y:y];
                    continue;
                }
                
                BlockSprite *block = [BlockSprite randomBlock];
                [block resize:blockSize];
                [self setBlock:block x:x y:y];
                [self addChild:block];
            }
        }
    }
    return self;
}

-(void) dealloc
{
	if (blocks != NULL)
		free(blocks);
    
    [super dealloc];
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	BoardLayer *board = [[[BoardLayer alloc] initRandomWithNumberOfColumns:7
                                                                      rows:7
                                                                 blockSize:CGSizeMake(40.0, 40.0)]
                         autorelease];
	[scene addChild: board];
	return scene;
}

-(void) setBlock:(BlockSprite *)block x:(int)x y:(int)y
{
    //Point the corresponding board array element to the block
	blocks[(y * columnCount) + x] = block;
    
    //Update the block's location information
    block.row = y;
    block.column = x;
    block.position = ccp(CGRectGetMinX(boundingBox) + x * blockSize.width,
                         CGRectGetMinY(boundingBox) + y * blockSize.height);
}

-(BlockSprite *) blockAtX:(int)x y:(int)y
{
	return blocks[(y * columnCount) + x];
}

-(void) moveColumnAtX:(int)x distance:(float)distance
{
    //Represents either the topmost or bottommost block depending on movement direction
    BlockSprite *endBlock;
    
    if (distance > 0) {
        //The user moved up
        //Find the block at the top of the column.
        for (int y = rowCount - 1; y >= 0; y--) {
            if((endBlock = [self blockAtX:x y:y]) != nil)
                break;
        }
    }
    else {
        //The user moved down
        //Find the block at the bottom of the column. Return if none are found
        for (int y = 0; y < rowCount; y++) {
            if((endBlock = [self blockAtX:x y:y]) != nil)
                break;
        }
    }
    
    //No block was found in the row, so don't move any (return)
    if (endBlock == nil)
        return;
    
    //Set the distance to be the min of the empty space between the board border
    //and the end block, and the original touch displacement.
    //This blocks the user from pushing a column past the border of the board
    if (distance < 0)
        distance = MAX(distance, CGRectGetMinY(boundingBox) - CGRectGetMinY([endBlock boundingBox]));
    else
        distance = MIN(distance, CGRectGetMaxY(boundingBox) - CGRectGetMaxY([endBlock boundingBox]));
    
    //Move all of the blocks in the column
    for (int y = 0; y < columnCount; y++) {
        BlockSprite *block = [self blockAtX:x y:y];
        block.position = ccp(block.position.x, block.position.y + distance);
    }
}

-(void) moveRowAtY:(int)y distance:(float)distance
{
    //Represents either the leftmost or rightmost block depending on movement direction
    BlockSprite *endBlock;
    
    if (distance > 0) {
        //The user moved right
        //Find the block at the far right of the row.
        for (int x = columnCount - 1; x >= 0; x--) {
            if((endBlock = [self blockAtX:x y:y]) != nil)
                break;
        }
    }
    else {
        //The user moved left
        //Find the block at the far left of the row. Return if none are found
        for (int x = 0; x < columnCount; x++) {
            if((endBlock = [self blockAtX:x y:y]) != nil)
                break;
        }
    }
    
    //No block was found in the row, so don't move any (return)
    if (endBlock == nil) {
        return;
    }
    
    //Set the distance to be the min of the empty space between the board border
    //and the end block, and the original touch displacement.
    //This blocks the user from pushing a row past the border of the board
    if (distance < 0)
        distance = MAX(distance, CGRectGetMinX(boundingBox) - CGRectGetMinX([endBlock boundingBox]));
    else
        distance = MIN(distance, CGRectGetMaxX(boundingBox) - CGRectGetMaxX([endBlock boundingBox]));
    
    //Move all of the blocks in the row
    for (int x = 0; x < columnCount; x++) {
        BlockSprite *block = [self blockAtX:x y:y];
        block.position = ccp(block.position.x + distance, block.position.y);
    }
}

-(void) snapColumnAtX:(int)x
{
    NSMutableArray *column = [NSMutableArray arrayWithCapacity:rowCount];
    NSEnumerator *enumerator;
    BlockSprite *block;
    bool reverse = false;
    
    for (int y = 0; y < rowCount; y++) {
        if((block = [self blockAtX:x y:y]) != nil) {
            int newRow = (int)roundf((CGRectGetMinY([block boundingBox]) - CGRectGetMinY(boundingBox)) / blockSize.height);
            [column addObject:block];
            [self setBlock:nil x:block.column y:block.row];
            if (newRow > block.row)
                reverse = true;
            block.row = newRow;
        }
    }
    
    if (reverse)
        enumerator = [column reverseObjectEnumerator];
    else
        enumerator = [column objectEnumerator];

    for (block in enumerator)
        [self setBlock:block x:block.column y:block.row];
}

-(void) snapRowAtY:(int)y
{
    NSMutableArray *row = [NSMutableArray arrayWithCapacity:columnCount];
    NSEnumerator *enumerator;
    BlockSprite *block;
    bool reverse = true;
    
    for (int x = 0; x < columnCount; x++) {
        if((block = [self blockAtX:x y:y]) != nil) {
            [row addObject:block];
            [self setBlock:nil x:block.column y:block.row];
            int newColumn = (int)roundf((CGRectGetMinX([block boundingBox]) - CGRectGetMinX(boundingBox)) / blockSize.width);
            if (newColumn > block.column)
                reverse = true;
            block.column = newColumn;
        }
    }
    
    if (reverse)
        enumerator = [row reverseObjectEnumerator];
    else
        enumerator = [row objectEnumerator];
    
    for (block in enumerator)
        [self setBlock:block x:block.column y:block.row];
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Calculate the displacement of our touch in both x and y directions
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	CGPoint prevLocation = [touch previousLocationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	prevLocation = [[CCDirector sharedDirector] convertToGL:prevLocation];
    float dx = location.x - prevLocation.x, dy = location.y - prevLocation.y;
	
	switch (movement) {
            
        case kNone:
            //On our first touch, don't do anything. Wait for one more sample to calculate direction
            movement = kStarted;
            return;
            
        case kStarted:
            //When we start moving, remember which column or row we touched originally
            if (ABS(dx) >= ABS(dy)) {
                movement = kRow;
                movingIndex = (int)floorf((prevLocation.y - CGRectGetMinY(boundingBox)) / blockSize.height);
            }
            else {
                movement = kColumn;
                movingIndex = (int)floorf((prevLocation.x - CGRectGetMinX(boundingBox)) / blockSize.width);
            }
            return;
            
        case kColumn:
            [self moveColumnAtX:movingIndex distance:dy];
            break;
            
        case kRow:
            [self moveRowAtY:movingIndex distance:dx];
            break;
            
        default:
            break;
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    switch (movement) {
            
        case kColumn:
            [self snapColumnAtX:movingIndex];
            break;
            
        case kRow:
            [self snapRowAtY:movingIndex];
            break;
            
        default:
            break;
    }
    
    movement = kNone;
}

@end
