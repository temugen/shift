//
//  BoardLayer.m
//  shift
//
//  Created by Brad Misik on 8/17/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "BoardLayer.h"
#import "BlockTrain.h"

@interface BoardLayer()

/* Private Functions */
-(id) initWithNumberOfColumns:(int)columns rows:(int)rows center:(CGPoint)center cellSize:(CGSize)size;

-(void) setGoal:(GoalSprite *)block x:(int)x y:(int)y;

-(void) saveSnapshot;
-(void) clearBoard;

@end

@implementation BoardLayer

@synthesize rowCount, columnCount;
@synthesize boundingBox;
@synthesize cellSize;

+(BoardLayer *) randomBoardWithNumberOfColumns:(int)columns rows:(int)rows center:(CGPoint)center cellSize:(CGSize)size
{
    return [[BoardLayer alloc] initRandomWithNumberOfColumns:columns rows:rows center:center cellSize:size];
}

+(BoardLayer *) boardWithFilename:(NSString *)filename center:(CGPoint)center cellSize:(CGSize)size
{
    return [[BoardLayer alloc] initWithFilename:filename center:center cellSize:size];
}

-(id) initWithNumberOfColumns:(int)columns rows:(int)rows center:(CGPoint)center cellSize:(CGSize)size
{
	if((self = [super init])) {
        //Don't allow touch input until the pieces are loaded
        self.isTouchEnabled = NO;
        
        columnCount = columns;
        rowCount = rows;
        
        //Make room in our board array for all of the blocks
        int cellCount = rowCount * columnCount;
        blocks = (__unsafe_unretained BlockSprite **)malloc(cellCount * sizeof(BlockSprite *));
        goals = (__unsafe_unretained GoalSprite **)malloc(cellCount * sizeof(GoalSprite *));
        memset(blocks, 0, cellCount * sizeof(BlockSprite *));
        memset(goals, 0, cellCount * sizeof(GoalSprite *));
        
        initialBlocks = [NSMutableSet setWithCapacity:cellCount];

        cellSize = size;

        //Calculate the bounding box for the board.
        boundingBox.size.width = columnCount * cellSize.width;
        boundingBox.size.height = rowCount * cellSize.height;
        boundingBox.origin.x = center.x - (CGRectGetWidth(boundingBox) / 2);
        boundingBox.origin.y = center.y - (CGRectGetHeight(boundingBox) / 2);
        
        blockTrains = [NSMutableDictionary dictionaryWithCapacity:MAX(columns, rows)];
	}
	return self;
}

-(id) initRandomWithNumberOfColumns:(int)columns rows:(int)rows center:(CGPoint)center cellSize:(CGSize)size
{	
    if ((self = [self initWithNumberOfColumns:columns rows:rows center:center cellSize:size])) {
        NSArray *colorNames = [colors allKeys];
        
        //Fill the board in with new, random blocks
        for (int x = 0; x < columnCount; x++) {
            for (int y = 0; y < rowCount; y++) {
                
                //Keep some blocks clear
                if (arc4random() % 2 == 0) {
                    [self setBlock:nil x:x y:y];
                    [self setGoal:nil x:x y:y];
                    continue;
                }
                
                int randomIndex = arc4random() % [colors count];
                
                //Add the goal block
                GoalSprite *goal = [GoalSprite goalWithName:[colorNames objectAtIndex:randomIndex]];
                CGPoint scalingFactors = [goal resize:cellSize];
                [self setGoal:goal x:x y:y];
                [self addChild:goal z:0];
                
                //Add the user block
                BlockSprite *block = [BlockSprite blockWithName:[colorNames objectAtIndex:randomIndex]];
                [block scaleWithFactors:scalingFactors];
                [self setBlock:block x:x y:y];
                [self addChild:block z:1];
            }
        }
        
        //Shift random rows and columns a certain number of times
        for (int i = 0; i < (rowCount * columnCount) * (rowCount * columnCount); i++) {
            int direction = arc4random() % 2;
            int column = arc4random() % columnCount, row = arc4random() % rowCount;
            
            int reverse = 1;
            if (arc4random() % 2 == 0)
                reverse = -1;
            
            if (direction == 0) {
                int cells = arc4random() % columnCount;
                //[self shiftColumnAtX:column y:row numberOfCells:cells];
            }
            else {
                int cells = arc4random() % rowCount;
                //[self shiftRowAtY:row x:column numberOfCells:cells];
            }
        }
        
        [self saveSnapshot];
        self.isTouchEnabled = YES;
    }
    return self;
}

-(id) initWithFilename:(NSString *)filename center:(CGPoint)center cellSize:(CGSize)size
{
    //Find the path to the file
    NSString *extension = [filename pathExtension];
    NSString *name = [filename stringByDeletingPathExtension];
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    
    //Open the file and put its contents into a dictionary
    NSData *plistData = [NSData dataWithContentsOfFile:path];
    NSString *error;
    NSPropertyListFormat format;
    NSDictionary *plist = [NSPropertyListSerialization propertyListFromData:plistData
                                             mutabilityOption:NSPropertyListImmutable
                                                       format:&format
                                             errorDescription:&error];
    
    //Get the board attributes
    NSDictionary *board = [plist objectForKey:@"board"];
    int rows = [[board objectForKey:@"rows"] intValue], columns = [[board objectForKey:@"columns"] intValue];
                   
    if ((self = [self initWithNumberOfColumns:columns rows:rows center:center cellSize:size])) {
        
        //Calculate the scaling factors for all of our pieces.
        GoalSprite *sampleGoal = [GoalSprite goalWithName:@"red"];
        CGPoint scalingFactors = [sampleGoal resize:cellSize];
        
        //Loop through all of the cells
        NSArray *cells = [board objectForKey:@"cells"];
        NSEnumerator *enumerator = [cells objectEnumerator];
        for (NSDictionary *cell in enumerator) {
            
            //Get the cell's attributes
            NSString *class = [cell objectForKey:@"class"], *name = [cell objectForKey:@"name"];
            int row = [[cell objectForKey:@"row"] intValue], column = [[cell objectForKey:@"column"] intValue];
            
            //Add the cell to the board
            if ([class isEqualToString:@"GoalSprite"]) {
                GoalSprite *goal = [GoalSprite goalWithName:name];
                [goal resize:cellSize];
                [self setGoal:goal x:column y:row];
                [self addChild:goal z:0];
            }
            else {
                BlockSprite *block = [NSClassFromString(class) blockWithName:name];
                [block scaleWithFactors:scalingFactors];
                [self setBlock:block x:column y:row];
                [self addChild:block z:1];
            }
        }
        
        [self saveSnapshot];
        self.isTouchEnabled = YES;
    }
    return self;
}

-(void) draw
{
    glEnable(GL_LINE_SMOOTH);
    for (int x = 0; x <= columnCount; x += columnCount) {
        ccDrawLine(ccp(CGRectGetMinX(boundingBox) + x * cellSize.width, CGRectGetMinY(boundingBox)),
                   ccp(CGRectGetMinX(boundingBox) + x * cellSize.width, CGRectGetMaxY(boundingBox)));
    }
    for (int y = 0; y <= rowCount; y += rowCount) {
        ccDrawLine(ccp(CGRectGetMinX(boundingBox), CGRectGetMinY(boundingBox) + y * cellSize.height),
                   ccp(CGRectGetMaxX(boundingBox), CGRectGetMinY(boundingBox) + y * cellSize.height));
    }
}

-(void) saveSnapshot
{
    [initialBlocks removeAllObjects];
    for (int x = 0; x < columnCount; x++) {
        for (int y = 0; y < rowCount; y++) {
            BlockSprite *block = [self blockAtX:x y:y];
            if (block != nil)
                [initialBlocks addObject:[[self blockAtX:x y:y] copy]];
        }
    }
}

-(void) clearBoard
{
    for (int x = 0; x < columnCount; x++) {
        for (int y = 0; y < rowCount; y++) {
            BlockSprite *block = [self blockAtX:x y:y];
            [self removeBlock:block];
        }
    }   
}

-(void) resetBoard
{
    [self clearBoard];
    
    NSEnumerator *enumerator = [initialBlocks objectEnumerator];
    for (BlockSprite *block in enumerator) {
        BlockSprite *copy = [block copy];
        [self setBlock:copy x:block.column y:block.row];
        [self addChild:copy z:1];
    }
}

-(void) dealloc
{
    [self clearBoard];
    free(blocks);
    free(goals);
    
}

-(void) setBlock:(BlockSprite *)block x:(int)x y:(int)y
{
    //Point the corresponding board array element to the block
	blocks[(y * columnCount) + x] = block;
    
    //Update the block's location information
    if (block != nil) {
        block.row = y;
        block.column = x;
        block.position = ccp(CGRectGetMinX(boundingBox) + x * cellSize.width + cellSize.width / 2,
                             CGRectGetMinY(boundingBox) + y * cellSize.height + cellSize.height / 2);
    }
}

-(BlockSprite *) blockAtX:(int)x y:(int)y
{
	return blocks[(y * columnCount) + x];
}

-(void) removeBlock:(BlockSprite *) block
{
    //Don't need to do anything if the user wants to remove an empty space
    if (block == nil)
        return;
    
    //If block was in the process of being moved, remove it from the movingBlocks array
    //if ([movingBlocks containsObject:block]) 
    //    [movingBlocks removeObject:block];
    
    [self setBlock:nil x:block.column y:block.row];
    [self removeChild:block cleanup:YES];
}

-(void) setGoal:(GoalSprite *)goal x:(int)x y:(int)y
{
    //Point the corresponding board array element to the goal
	goals[(y * columnCount) + x] = goal;
    
    //Update the goal's location information
    if (goal != nil) {
        goal.row = y;
        goal.column = x;
        goal.position = ccp(CGRectGetMinX(boundingBox) + x * cellSize.width + cellSize.width / 2,
                            CGRectGetMinY(boundingBox) + y * cellSize.height + cellSize.height / 2);
    }
}

-(GoalSprite *) goalAtX:(int)x y:(int)y
{
	return goals[(y * columnCount) + x];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for(UITouch *touch in touches)
    {
        NSLog(@"new touch %p\n", touch);
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        int row = [self rowAtPoint:location], column = [self columnAtPoint:location];
        
        //If the user touched something outside the board, do nothing
        if ([self isOutOfBoundsAtX:column y:row])
            return;
        
        //Tell the block it was clicked or double-tapped.
        BlockSprite *block = [self blockAtX:column y:row];
        if (block != nil) {
            if(touch.tapCount >= 2)
                [block onDoubleTap];
            else if(touch.tapCount == 1)
                [block onTap];
            else
                [block onTouch];
        }
        
        if (block == nil || block.movable) {
            BlockTrain *blockTrain = [BlockTrain trainFromBoard:self atPoint:location];
            [blockTrains setObject:blockTrain
                            forKey:[NSNumber numberWithUnsignedLongLong:(unsigned long long)touch]];
        }
    }
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        
        BlockTrain *blockTrain = [blockTrains objectForKey:[NSNumber numberWithUnsignedLongLong:(unsigned long long)touch]];
        if (blockTrain != nil) {
            [blockTrain moveTo:location];
        }
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        BlockTrain *blockTrain = [blockTrains objectForKey:[NSNumber numberWithUnsignedLongLong:(unsigned long long)touch]];
        if (blockTrain != nil) {
            [blockTrain snap];
            [blockTrains removeObjectForKey:[NSNumber numberWithUnsignedLongLong:(unsigned long long)touch]];
        }
    }
}

-(BOOL) isComplete
{
    for (int x = 0; x < columnCount; x++) {
        for (int y = 0; y < rowCount; y++) {
            GoalSprite *goal = [self goalAtX:x y:y];
            BlockSprite *block = [self blockAtX:x y:y]; 
             if (goal != nil && goal.comparable && ![goal onCompareWithCell:block])
                 return NO;
             if (block != nil && block.comparable && ![block onCompareWithCell:goal])
                 return NO;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BoardComplete" object:self];
    
    return YES;
}

-(BOOL) isOutOfBoundsAtX:(int)x y:(int)y
{
    return x<0||y<0||x>=columnCount||y>=rowCount;
}

-(int) rowAtPoint:(CGPoint)point
{
    return (int)floorf((point.y - CGRectGetMinY(boundingBox)) / cellSize.height);
}

-(int) columnAtPoint:(CGPoint)point
{
    return (int)floorf((point.x - CGRectGetMinX(boundingBox)) / cellSize.width);
}

@end
