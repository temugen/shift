//
//  BoardLayer.m
//  shift
//
//  Created by Brad Misik on 8/17/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "BoardLayer.h"

#define len(array) (sizeof((array))/sizeof(typeof((array[0]))))

static NSString *colors[] = {
    @"blue",
    @"red",
    @"green",
    @"purple",
    @"yellow",
    @"orange"
};

@interface BoardLayer()

/* Private Functions */
-(id) initWithNumberOfColumns:(int)columns rows:(int)rows cellSize:(CGSize)size;
-(BlockSprite *) blockAtX:(int)x y:(int)y;
-(void) setBlock:(BlockSprite *)block x:(int)x y:(int)y;
-(GoalSprite *) goalAtX:(int)x y:(int)y;
-(void) setGoal:(GoalSprite *)block x:(int)x y:(int)y;
-(void) moveColumnAtX:(int)x y:(int)y distance:(float)distance;
-(void) moveRowAtY:(int)y x:(int)x distance:(float)distance;
-(void) snapColumnAtX:(int)x;
-(void) snapRowAtY:(int)y;
-(Boolean) isComplete;

@end

@implementation BoardLayer

-(id) initWithNumberOfColumns:(int)columns rows:(int)rows cellSize:(CGSize)size
{
	if((self = [super init])) {
        //Needed to receive touch input callbacks (ccTouchesXXX)
        self.isTouchEnabled = YES;
        
        //Make room in our board array for all of the blocks
        columnCount = columns;
        rowCount = rows;
        int cellCount = rowCount * columnCount;
		blocks = (BlockSprite **)malloc(cellCount * sizeof(BlockSprite *));
        goals = (GoalSprite **)malloc(cellCount * sizeof(GoalSprite *));
        
        cellSize = size;
        
        //Initially, no columns or rows are moving
        movement = kNone;
	}
	return self;
}

-(id) initRandomWithNumberOfColumns:(int)columns rows:(int)rows cellSize:(CGSize)size
{	
    if ((self = [self initWithNumberOfColumns:columns rows:rows cellSize:size])) {
        //Calculate the bounding box for the board.
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        boundingBox.size.width = columnCount * cellSize.width;
        boundingBox.size.height = rowCount * cellSize.height;
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
                
                int randomIndex = arc4random() % len(colors);
                
                //Add the goal block
                GoalSprite *goal = [GoalSprite goalWithName:colors[randomIndex]];
                CGPoint scalingFactors = [goal resize:cellSize];
                [self setGoal:goal x:x y:y];
                [self addChild:goal z:0];
                
                //Add the user block
                BlockSprite *block = [BlockSprite blockWithName:colors[randomIndex]];
                [block scaleWithFactors:scalingFactors];
                [self setBlock:block x:x y:y];
                [self addChild:block z:1];
            }
        }
    }
    return self;
}

-(id) initWithFilename:(NSString *)filename cellSize:(CGSize)size
{
    if ((self = [self initRandomWithNumberOfColumns:7 rows:7 cellSize:size])) {
    }
    return self;
}

-(void) dealloc
{
    free(blocks);
    free(goals);
    
    [super dealloc];
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	BoardLayer *board = [[[BoardLayer alloc] initRandomWithNumberOfColumns:7
                                                                      rows:7
                                                                 cellSize:CGSizeMake(40.0, 40.0)]
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
    block.position = ccp(CGRectGetMinX(boundingBox) + x * cellSize.width + cellSize.width / 2,
                         CGRectGetMinY(boundingBox) + y * cellSize.height + cellSize.height / 2);
}

-(BlockSprite *) blockAtX:(int)x y:(int)y
{
	return blocks[(y * columnCount) + x];
}

-(void) setGoal:(GoalSprite *)goal x:(int)x y:(int)y
{
    //Point the corresponding board array element to the goal
	goals[(y * columnCount) + x] = goal;
    
    //Update the goal's location information
    goal.row = y;
    goal.column = x;
    goal.position = ccp(CGRectGetMinX(boundingBox) + x * cellSize.width + cellSize.width / 2,
                         CGRectGetMinY(boundingBox) + y * cellSize.height + cellSize.height / 2);
}

-(GoalSprite *) goalAtX:(int)x y:(int)y
{
	return goals[(y * columnCount) + x];
}

-(void) moveColumnAtX:(int)x y:(int)y distance:(float)distance
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

-(void) moveRowAtY:(int)y x:(int)x distance:(float)distance
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
            //Add all of the blocks in the column to an array for rearranging later
            [column addObject:block];
            [self setBlock:nil x:block.column y:block.row];
            int newRow = (int)roundf((block.position.y - cellSize.height / 2 - CGRectGetMinY(boundingBox)) / cellSize.height);
            //Choose which way to loop through the blocks to make sure we don't overwrite other blocks
            if (newRow > block.row)
                reverse = true;
            block.row = newRow;
        }
    }
    
    if (reverse)
        enumerator = [column reverseObjectEnumerator];
    else
        enumerator = [column objectEnumerator];

    //Move the blocks to their new locations in the board array
    for (block in enumerator)
        [self setBlock:block x:block.column y:block.row];
    
    if ([self isComplete]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BoardComplete" object:self];
    }
}

-(void) snapRowAtY:(int)y
{
    NSMutableArray *row = [NSMutableArray arrayWithCapacity:columnCount];
    NSEnumerator *enumerator;
    BlockSprite *block;
    bool reverse = true;
    
    for (int x = 0; x < columnCount; x++) {
        if((block = [self blockAtX:x y:y]) != nil) {
            //Add all of the blocks in the row to an array for rearranging later
            [row addObject:block];
            [self setBlock:nil x:block.column y:block.row];
            int newColumn = (int)roundf((block.position.x - cellSize.width / 2 -CGRectGetMinX(boundingBox)) / cellSize.width);
            //Choose which way to loop through the blocks to make sure we don't overwrite other blocks
            if (newColumn > block.column)
                reverse = true;
            block.column = newColumn;
        }
    }
    
    if (reverse)
        enumerator = [row reverseObjectEnumerator];
    else
        enumerator = [row objectEnumerator];
    
    //Move the blocks to their new locations in the board array
    for (block in enumerator)
        [self setBlock:block x:block.column y:block.row];
    
    if ([self isComplete]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BoardComplete" object:self];
    }
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
            break;
            
        case kStarted:
            //When we start moving, remember which column or row we touched originally
            movingRow = (int)floorf((prevLocation.y - CGRectGetMinY(boundingBox)) / cellSize.height);
            movingColumn = (int)floorf((prevLocation.x - CGRectGetMinX(boundingBox)) / cellSize.width);
            
            //If the user moved something outside the board, do nothing
            if (movingRow < 0 || movingColumn < 0 || movingRow >= rowCount || movingColumn >= columnCount) {
                break;
            }
                
            if (ABS(dx) >= ABS(dy)) {
                movement = kRow;
            }
            else {
                movement = kColumn;
            }
            break;
            
        case kColumn:
            [self moveColumnAtX:movingColumn y:movingRow distance:dy];
            break;
            
        case kRow:
            [self moveRowAtY:movingRow x:movingColumn distance:dx];
            break;
            
        default:
            break;
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    switch (movement) {
            
        case kColumn:
            [self snapColumnAtX:movingColumn];
            break;
            
        case kRow:
            [self snapRowAtY:movingRow];
            break;
            
        default:
            break;
    }
    
    movement = kNone;
}

-(void) toggleMovementLock
{
    if (movement == kLocked)
        movement = kNone;
    else
        movement = kLocked;
}

-(Boolean) isComplete
{
    for (int x = 0; x < columnCount; x++) {
        for (int y = 0; y < rowCount; y++) {
            GoalSprite *goal = [self goalAtX:x y:y];
            BlockSprite *block = [self blockAtX:x y:y];
            
            if (goal == nil && block != nil && block.comparable)
                return false;
            else if (block == nil && goal != nil && goal.comparable)
                return false;
            else if (block != nil && goal != nil && block.comparable && goal.comparable && ![block.name isEqualToString:goal.name])
                return false;
        }
    }
    return true;
}

@end
