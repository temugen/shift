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
-(id) initWithNumberOfColumns:(int)columns rows:(int)rows center:(CGPoint)center cellSize:(CGSize)size;
-(GoalSprite *) goalAtX:(int)x y:(int)y;
-(void) setGoal:(GoalSprite *)block x:(int)x y:(int)y;

-(void) containMovementAtX:(int)x y:(int)y;
-(void) moveBlocksWithDistance:(float)distance;
-(void) snapMovingBlocks;

@end

@implementation BoardLayer

@synthesize rowCount, columnCount;
@synthesize boundingBox;

-(id) initWithNumberOfColumns:(int)columns rows:(int)rows center:(CGPoint)center cellSize:(CGSize)size
{
	if((self = [super init])) {
        columnCount = columns;
        rowCount = rows;
        cellSize = size;
        movingBlocks = [[NSMutableArray alloc] initWithCapacity:MAX(rowCount, columnCount)];
        
        //Calculate the bounding box for the board.
        boundingBox.size.width = columnCount * cellSize.width;
        boundingBox.size.height = rowCount * cellSize.height;
        boundingBox.origin.x = center.x - (CGRectGetWidth(boundingBox) / 2);
        boundingBox.origin.y = center.y - (CGRectGetHeight(boundingBox) / 2);
        
        //Needed to receive touch input callbacks (ccTouchesXXX)
        self.isTouchEnabled = YES;
        
        //Make room in our board array for all of the blocks
        int cellCount = rowCount * columnCount;
		blocks = (BlockSprite **)malloc(cellCount * sizeof(BlockSprite *));
        goals = (GoalSprite **)malloc(cellCount * sizeof(GoalSprite *));
        
        //Initially, no columns or rows are moving
        movement = kNone;
	}
	return self;
}

-(id) initRandomWithNumberOfColumns:(int)columns rows:(int)rows center:(CGPoint)center cellSize:(CGSize)size
{	
    if ((self = [self initWithNumberOfColumns:columns rows:rows center:center cellSize:size])) {
        //Fill the board in with new, random blocks
        for (int x = 0; x < columnCount; x++) {
            for (int y = 0; y < rowCount; y++) {
                
                //Keep some blocks clear
                if (arc4random() % 2 == 0) {
                    [self setBlock:nil x:x y:y];
                    [self setGoal:nil x:x y:y];
                    continue;
                }
                
                //Make some block stationary
                if(arc4random() % 14 == 0) {
                    BlockSprite *block = [BlockSprite blockWithName:@"stationary"];
                    block.comparable = NO;
                    block.movable = NO;
                    [block resize:cellSize];
                    [self setBlock:block x:x y:y];
                    [self setGoal:nil x:x y:y];
                    [self addChild:block];
                    continue;
                }
                
                //Make some block rotate
                if(arc4random() % 14 == 0) {
                    RotationBlock *block = [RotationBlock block];
                    block.board = self;
                    [block resize:cellSize];
                    [self setBlock:block x:x y:y];
                    [self setGoal:nil x:x y:y];
                    [self addChild:block];
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

-(id) initWithFilename:(NSString *)filename center:(CGPoint)center cellSize:(CGSize)size
{
    if ((self = [self initRandomWithNumberOfColumns:7 rows:7 center:center cellSize:size])) {
    }
    return self;
}

-(void) dealloc
{
    free(blocks);
    free(goals);
    [movingBlocks release];
    
    [super dealloc];
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
	BoardLayer *board = [[[BoardLayer alloc] initRandomWithNumberOfColumns:7
                                                                      rows:7
                                                                    center:CGPointMake((screenSize.width / 2), (screenSize.height / 2))
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

-(void) containMovementAtX:(int)x y:(int)y
{
    int variable;
    int maxVariable;
    
    //Choose the correct rect min and rect max functions for x and y directions
    switch (movement) {
        case kColumn:
            rectMin = CGRectGetMinY;
            rectMax = CGRectGetMaxY;
            variable = y;
            maxVariable = rowCount;
            break;
            
        case kRow:
            rectMin = CGRectGetMinX;
            rectMax = CGRectGetMaxX;
            variable = x;
            maxVariable = columnCount;
            break;
            
        default:
            return;
    }

    [movingBlocks removeAllObjects];
    lowImmovable = highImmovable = nil;
    lowPositionLimit = rectMin(boundingBox), highPositionLimit = rectMax(boundingBox);
    
    int i, row, column;
    //Find the lowest index block that we can move, and mark the first unmoveable block if it exists
    for (i = variable; i >= 0; i--) {
        if (movement == kColumn) {
            row = i;
            column = x;
        }
        else if (movement == kRow) {
            row = y;
            column = i;
        }
        
        BlockSprite *block = [self blockAtX:column y:row];
        if (block != nil && !block.movable) {
            lowImmovable = block;
            lowPositionLimit = rectMax([lowImmovable boundingBox]);
            break;
        }
    }
    
    //Find all the blocks we can move, and mark the highest unmoveable block if it exists
    for (i = MAX(0, i + 1); i < maxVariable; i++) {
        if (movement == kColumn) {
            row = i;
            column = x;
        }
        else if (movement == kRow) {
            row = y;
            column = i;
        }
        
        BlockSprite *block = [self blockAtX:column y:row];
        if (block != nil && !block.movable) {
            highImmovable = block;
            highPositionLimit = rectMin([highImmovable boundingBox]);
            break;
        }
        else if (block != nil && block.movable) {
            [movingBlocks addObject:block];
        }
    }
}

-(void) moveBlocksWithDistance:(float)distance
{
    //There is nothing to move
    if ([movingBlocks count] == 0) {
        return;
    }
    
    //Get the first and last moving blocks
    BlockSprite *lowBlock = [movingBlocks objectAtIndex:0], *highBlock = [movingBlocks objectAtIndex:[movingBlocks count] - 1];
    
    //This blocks the user from pushing the blocks past a barrier (unmoveable block or board border)
    float limitedDistance;
    if (distance < 0) {
        limitedDistance = MAX(distance, lowPositionLimit - rectMin([lowBlock boundingBox]));
        
        //Let blocks know if they collided with each other
        if (lowImmovable != nil && ABS(limitedDistance) < ABS(distance)) {
            [lowImmovable onCollideWithCell:lowBlock force:ABS(distance)];
            [lowBlock onCollideWithCell:lowImmovable force:ABS(distance)];
        }
    }
    else {
        limitedDistance = MIN(distance, highPositionLimit - rectMax([highBlock boundingBox]));
        
        //Let blocks know if they collided with each other
        if (highImmovable != nil && ABS(limitedDistance) < ABS(distance)) {
            [highImmovable onCollideWithCell:highBlock force:ABS(distance)];
            [highBlock onCollideWithCell:highImmovable force:ABS(distance)];
        }
    }
    
    //Move all of the moving blocks by distance in the correct direction
    for (BlockSprite *block in movingBlocks) {
        if (movement == kColumn)
            block.position = ccp(block.position.x, block.position.y + limitedDistance);
        else if (movement == kRow)
            block.position = ccp(block.position.x + limitedDistance, block.position.y);
        
        //Let the block know it was moved
        [block onMoveWithDistance:distance vertically:(movement == kColumn)];
    }
}

-(void) snapMovingBlocks
{
    NSEnumerator *enumerator = [movingBlocks objectEnumerator];
    for (BlockSprite *block in enumerator) {
        //Clear the block's space on the board
        [self setBlock:nil x:block.column y:block.row];
    }
    enumerator = [movingBlocks objectEnumerator];
    for (BlockSprite *block in enumerator) {
        //Move the block to the closest cell's position on the board
        block.column = (int)roundf((block.position.x - cellSize.width / 2 -CGRectGetMinX(boundingBox)) / cellSize.width);
        block.row = (int)roundf((block.position.y - cellSize.height / 2 - CGRectGetMinY(boundingBox)) / cellSize.height);
        [self setBlock:block x:block.column y:block.row];
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Notify a block if it was pressed
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];

    //Figure out the cell that the user pressed
    int row = (int)floorf((location.y - CGRectGetMinY(boundingBox)) / cellSize.height);
    int column = (int)floorf((location.x - CGRectGetMinX(boundingBox)) / cellSize.width);
    
    //If the user touched something outside the board, do nothing
    if (row < 0 || column < 0 || row >= rowCount || column >= columnCount) {
        return;
    }
    
    //Tell the block it was clicked.
    BlockSprite *block = [self blockAtX:column y:row];
    [block onTouch];
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
	float row, column;
    
	switch (movement) {
        case kLocked:
            return;
            
        case kNone:
            //On our first move, don't do anything. Wait for one more sample to calculate direction
            movement = kStarted;
            break;
            
        case kStarted:
            //When we start moving, remember which column or row we touched originally
            row = (int)floorf((prevLocation.y - CGRectGetMinY(boundingBox)) / cellSize.height);
            column = (int)floorf((prevLocation.x - CGRectGetMinX(boundingBox)) / cellSize.width);
            
            //If the user moved something outside the board, do nothing
            if (row < 0 || column < 0 || row >= rowCount || column >= columnCount)
                break;
                
            if (ABS(dx) >= ABS(dy))
                movement = kRow;
            else
                movement = kColumn;
            
            [self containMovementAtX:column y:row];
            break;
            
        case kColumn:
            [self moveBlocksWithDistance:dy];
            break;
            
        case kRow:
            [self moveBlocksWithDistance:dx];
            break;
            
        default:
            break;
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    switch (movement) {
            
        case kLocked:
            return;
            
        case kColumn:
            
        case kRow:
            [self snapMovingBlocks];
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

-(BOOL) isComplete
{
    for (int x = 0; x < columnCount; x++) {
        for (int y = 0; y < rowCount; y++) {
            GoalSprite *goal = [self goalAtX:x y:y];
            BlockSprite *block = [self blockAtX:x y:y];
            
            if (goal == nil && block != nil && block.comparable)
                return NO;
            else if (block == nil && goal != nil && goal.comparable)
                return NO;
            else if (block != nil && goal != nil && block.comparable && goal.comparable && ![block.name isEqualToString:goal.name])
                return NO;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BoardComplete" object:self];
    
    return YES;
}

@end
