//
//  BoardLayer.m
//  shift
//
//  Created by Brad Misik on 8/17/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "BoardLayer.h"
#import "BlockTrain.h"
#import "ColorPalette.h"

@interface BoardLayer()

/* Private Functions */
-(id) initWithNumberOfColumns:(int)columns rows:(int)rows cellSize:(CGSize)size;

-(void) setBlock:(BlockSprite *)block x:(int)x y:(int)y;
-(void) setGoal:(GoalSprite *)goal x:(int)x y:(int)y;
-(void) addGoal:(GoalSprite *)goal x:(int)x y:(int)y;
-(void) removeGoal:(GoalSprite *)goal;

-(void) randomize;
-(void) shuffle;

-(void) saveSnapshot;

-(void) clear;
-(void) clearBlocks;
-(void) clearGoals;

@end

@implementation BoardLayer

@synthesize rowCount, columnCount, moveCount;
@synthesize cellSize, blockSize;
@synthesize backgroundTexture;

+(BoardLayer *) randomBoardWithNumberOfColumns:(int)columns rows:(int)rows cellSize:(CGSize)size
{
    return [[BoardLayer alloc] initRandomWithNumberOfColumns:columns rows:rows cellSize:size];
}

+(BoardLayer *) boardWithFilename:(NSString *)filename cellSize:(CGSize)size
{
  //Find the path to the file
  NSString *extension = [filename pathExtension];
  NSString *name = [filename stringByDeletingPathExtension];
  NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
  
  //Open the file and put its contents into a dictionary
  NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:path];
  
  //Get the board attributes
  NSDictionary *board = [plist valueForKey:@"board"];
  
  return [[BoardLayer alloc] initWithDictionary:board cellSize:size];
}

+(BoardLayer *) boardWithDictionary:(NSDictionary*)dict cellSize:(CGSize)size
{  
  return [[BoardLayer alloc] initWithDictionary:dict cellSize:size];
}

-(id) initWithNumberOfColumns:(int)columns rows:(int)rows cellSize:(CGSize)size
{
	if((self = [super init])) {
        //Don't allow touch input until the pieces are loaded
        self.isTouchEnabled = NO;
        
        columnCount = columns;
        rowCount = rows;
        moveCount = 0;
        
        //Make room in our board array for all of the blocks
        int cellCount = rowCount * columnCount;
        blocks = (__unsafe_unretained BlockSprite **)malloc(cellCount * sizeof(BlockSprite *));
        goals = (__unsafe_unretained GoalSprite **)malloc(cellCount * sizeof(GoalSprite *));
        memset(blocks, 0, cellCount * sizeof(BlockSprite *));
        memset(goals, 0, cellCount * sizeof(GoalSprite *));
        
        initialBlocks = [NSMutableSet setWithCapacity:cellCount];

        //Calculate the cell size and block size
        GoalSprite *sampleGoal = [GoalSprite goalWithName:@"red"];
        BlockSprite *sampleBlock = [BlockSprite blockWithName:@"red"];
        cellSize = size;
        CGPoint scalingFactors = [sampleGoal resize:cellSize];
        blockSize = [sampleBlock scaleWithFactors:scalingFactors];

        //Calculate the bounding box for the board.
        self.isRelativeAnchorPoint = YES;
        self.contentSize = CGSizeMake(columnCount * cellSize.width, rowCount * cellSize.height);
        
        corners[0] = ccp(-2, -2);
        corners[1] = ccp(-2, self.contentSize.height+2);
        corners[2] = ccp(self.contentSize.width+2, self.contentSize.height+2);
        corners[3] = ccp(self.contentSize.width+2, -2);
        
        
        ccTexParams params = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
        backgroundTexture = [[CCTextureCache sharedTextureCache] addImage:@"background.png"];
        [backgroundTexture setTexParameters:&params];
        background = [CCSprite spriteWithTexture:backgroundTexture
                                            rect:CGRectMake(0, 0,
                                                            self.contentSize.width + 4,
                                                            self.contentSize.height + 4)];
        //darken the background texture
        [background setColor:ccc3(120, 120, 120)];
        background.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:background z:-1];
        
        blockTrains = [NSMutableDictionary dictionaryWithCapacity:MAX(columns, rows)];
	}
    
	return self;
}

-(id) initRandomWithNumberOfColumns:(int)columns rows:(int)rows cellSize:(CGSize)size
{	
    if ((self = [self initWithNumberOfColumns:columns rows:rows cellSize:size])) {
        [self randomize];
        [self saveSnapshot];
        
        self.isTouchEnabled = YES;
    }
    
    return self;
}

-(id) initWithDictionary:(NSDictionary*)board cellSize:(CGSize)size
{
    int rows = [[board objectForKey:@"rows"] intValue], columns = [[board valueForKey:@"columns"] intValue];
                   
    if ((self = [self initWithNumberOfColumns:columns rows:rows cellSize:size])) {        
        //Loop through all of the cells
        NSArray *cells = [board valueForKey:@"cells"];
        NSEnumerator *enumerator = [cells objectEnumerator];
        for (NSDictionary *cell in enumerator) {
            
            //Get the cell's attributes
            NSString *class = [cell valueForKey:@"class"], *name = [cell valueForKey:@"name"];
            NSString *tutorialMessage = [cell objectForKey:@"tutorial"];
            int row = [[cell valueForKey:@"row"] intValue], column = [[cell valueForKey:@"column"] intValue];
            
            //Add the cell to the board
            CellSprite *cell = nil;
            if ([class isEqualToString:@"GoalSprite"]) {
                GoalSprite *goal = [GoalSprite goalWithName:name];
                [self addGoal:goal x:column y:row];
                cell = goal;
            }
            else {
                BlockSprite *block = [NSClassFromString(class) blockWithName:name];
                [self addBlock:block x:column y:row];
                cell = block;
            }
            
            //Add tutorial if one was requested
            if (tutorialMessage != nil && cell != nil) {
                cell.tutorial = [[Tutorial alloc] initWithMessage:tutorialMessage forCell:cell];
            }
        }
        
        [self saveSnapshot];
        self.isTouchEnabled = YES;
    }
    
    return self;
}

-(NSDictionary *) serialize
{
    NSMutableDictionary *board = [NSMutableDictionary dictionaryWithCapacity:(3)];
    [board setValue:[NSNumber numberWithInt:rowCount] forKey:@"rows"];
    [board setValue:[NSNumber numberWithInt:columnCount] forKey:@"columns"];
    
    NSMutableArray *cells = [NSMutableArray arrayWithCapacity:(rowCount * columnCount)];
    
    for (int x = 0; x < columnCount; x++) {
        for (int y = 0; y < rowCount; y++) {
            
            CellSprite *cell;
            if ((cell = [self blockAtX:x y:y]) != nil) {
                NSDictionary *block = [NSDictionary dictionaryWithObjectsAndKeys:[[cell class] description], @"class",
                                       cell.name, @"name",
                                       [NSNumber numberWithInt:cell.row], @"row",
                                       [NSNumber numberWithInt:cell.column], @"column", nil];
                [cells addObject:block];
            }
            
            if ((cell = [self goalAtX:x y:y]) != nil) {
                NSDictionary *goal = [NSDictionary dictionaryWithObjectsAndKeys:[[cell class] description], @"class",
                                       cell.name, @"name",
                                      [NSNumber numberWithInt:cell.row], @"row",
                                      [NSNumber numberWithInt:cell.column], @"column", nil];
                [cells addObject:goal];
            }
        }
    }
    [board setValue:cells forKey:@"cells"];
    
    NSDictionary *level = [NSDictionary dictionaryWithObjectsAndKeys:board, @"board", nil];
    return level;
}

-(void) randomize
{
    [self clear];
    
    //Fill the board in with new, random blocks
    for (int x = 0; x < columnCount; x++) {
        for (int y = 0; y < rowCount; y++) {
            
            //Keep some blocks clear
            if (arc4random() % 2 == 0) {
                [self setBlock:nil x:x y:y];
                [self setGoal:nil x:x y:y];
                continue;
            }
            
            NSString *randomColor = [[ColorPalette sharedPalette] randomColorName];
            
            //Add the goal block
            GoalSprite *goal = [GoalSprite goalWithName:randomColor];
            [self addGoal:goal x:x y:y];
            
            //Add the user block
            BlockSprite *block = [BlockSprite blockWithName:randomColor];
            [self addBlock:block x:x y:y];
        }
    }
    
    [self shuffle];
}

-(void) shuffle
{
    //Shift random rows and columns a certain number of times
    for (int i = 0; i < (rowCount * columnCount) * (rowCount * columnCount); i++) {
        int direction = arc4random() % 2;
        int column = arc4random() % columnCount, row = arc4random() % rowCount;
        CGPoint startPoint = CGPointMake( + column * cellSize.width,
                                          + row * cellSize.height);
        
        int reverse = 1;
        if (arc4random() % 2 == 0)
            reverse = -1;
        
        int cells;
        float distance;
        BlockTrain *train;
        CGPoint endPoint;
        
        if (direction == 0) {
            cells = arc4random() % columnCount;
            distance = reverse * cells * cellSize.width;
            endPoint = CGPointMake(startPoint.x + distance, startPoint.y);
        }
        else {
            cells = arc4random() % rowCount;
            distance = reverse * cells * cellSize.height;
            endPoint = CGPointMake(startPoint.x, startPoint.y + distance);
        }
        
        train = [BlockTrain trainFromBoard:self atPoint:startPoint];
        [train moveTo:endPoint];
        [train snap];
    }
    
    moveCount = 0;
}

-(CCSprite *) screenshot
{
    CCRenderTexture *canvas = [CCRenderTexture renderTextureWithWidth:self.contentSize.width
                                                               height:self.contentSize.height];
    canvas.position = self.position;
    
    //Render board on canvas
    [canvas beginWithClear:0 g:0 b:0 a:0];
    for (int x = 0; x < columnCount; x++) {
        for (int y = 0; y < rowCount; y++) {
            GoalSprite *goal = [self goalAtX:x y:y];
            BlockSprite *block = [self blockAtX:x y:y];
            
            if (goal != nil) {
                [goal visit];
            }
            
            if (block != nil) {
                [block visit];
            }
        }
    }
    [canvas end];
    
    //Crop out board
    return canvas.sprite;
}

-(void) draw
{
    //Draw white border
    glColor4ub(255, 255, 255, 255);
    ccDrawPoly(corners, 4, YES);
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

-(void) clear
{
    [self clearBlocks];
    [self clearGoals];
}

-(void) clearBlocks
{
    for (int x = 0; x < columnCount; x++) {
        for (int y = 0; y < rowCount; y++) {
            BlockSprite *block = [self blockAtX:x y:y];
            [self removeBlock:block];
        }
    }   
}

-(void) clearGoals
{
    for (int x = 0; x < columnCount; x++) {
        for (int y = 0; y < rowCount; y++) {
            GoalSprite *goal = [self goalAtX:x y:y];
            if (goal != nil) {
                [self removeGoal:goal];
            }
        }
    }   
}

-(void) reset
{
    [self clearBlocks];
    
    NSEnumerator *enumerator = [initialBlocks objectEnumerator];
    for (BlockSprite *block in enumerator) {
        BlockSprite *copy = [block copy];
        [self addBlock:copy x:block.column y:block.row];
    }
}

-(void) dealloc
{
    [self clear];
    free(blocks);
    free(goals);
    
}

-(void) setBlock:(BlockSprite *)block x:(int)x y:(int)y
{
    //Point the corresponding board array element to the block
	blocks[(y * columnCount) + x] = block;
    
    //Update the block's location information
    if (block != nil) {
        block.position = ccp(x * cellSize.width + cellSize.width / 2,
                             y * cellSize.height + cellSize.height / 2);
    }
}

-(void) setGoal:(GoalSprite *)goal x:(int)x y:(int)y
{
    //Point the corresponding board array element to the goal
	goals[(y * columnCount) + x] = goal;
    
    //Update the goal's location information
    if (goal != nil) {
        goal.position = ccp(x * cellSize.width + cellSize.width / 2,
                            y * cellSize.height + cellSize.height / 2);
    }
}

-(BlockSprite *) blockAtX:(int)x y:(int)y
{
	return blocks[(y * columnCount) + x];
}

-(GoalSprite *) goalAtX:(int)x y:(int)y
{
	return goals[(y * columnCount) + x];
}

-(void) removeBlock:(BlockSprite *)block
{
    if (block.blockTrain != nil) {
        [block.blockTrain snap];
    }
    [self setBlock:nil x:block.column y:block.row];
    [self removeChild:block cleanup:YES];
}

-(void) removeGoal:(GoalSprite *)goal
{    
    [self setGoal:nil x:goal.column y:goal.row];
    [self removeChild:goal cleanup:YES];
}

-(void) addBlock:(BlockSprite *)block x:(int)x y:(int)y;
{
    block.column = x;
    block.row = y;
    [block resize:blockSize];
    [self setBlock:block x:x y:y];
    [self addChild:block z:1];
}

-(void) addGoal:(GoalSprite *)goal x:(int)x y:(int)y;
{
    goal.column = x;
    goal.row = y;
    [goal resize:cellSize];
    [self setGoal:goal x:x y:y];
    [self addChild:goal z:0];
}

-(void) moveBlock:(BlockSprite *)block x:(int)x y:(int)y
{
    if ([self blockAtX:block.column y:block.row] == block) {
        [self setBlock:nil x:block.column y:block.row];
    }
    
    block.column = x;
    block.row = y;
    [self setBlock:block x:x y:y];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for(UITouch *touch in touches)
    {
        //remove stale touch association
        BlockTrain *currentTrain = [blockTrains objectForKey:[NSNumber numberWithUnsignedLongLong:(unsigned long long)touch]];
        if (currentTrain != nil) {
            [currentTrain snap];
            [blockTrains removeObjectForKey:[NSNumber numberWithUnsignedLongLong:(unsigned long long)touch]];
        }
             
        CGPoint location = [self convertTouchToNodeSpace:touch];
        int row = [self rowAtPoint:location], column = [self columnAtPoint:location];
        
        //If the user touched something outside the board, do nothing
        if ([self isOutOfBoundsAtX:column y:row])
            return;
        
        
        //Tell the block it was clicked or double-tapped.
        BlockSprite *block = [self blockAtX:column y:row];
        if (block != nil) {
            if(touch.tapCount == 2)
                [block onDoubleTap];
            else if(touch.tapCount == 1)
                [block onTap];
            [block onTouch];
        }
        
        if (block == nil || block.movable) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"train_pickup.m4a"];
            
            BlockTrain *train = [BlockTrain trainFromBoard:self atPoint:location];
            [blockTrains setObject:train
                            forKey:[NSNumber numberWithUnsignedLongLong:(unsigned long long)touch]];
        }
    }
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [self convertTouchToNodeSpace:touch];
        
        BlockTrain *train = [blockTrains objectForKey:[NSNumber numberWithUnsignedLongLong:(unsigned long long)touch]];
        if (train != nil) {
            if (train.movement == kMovementSnapped) {
                [blockTrains removeObjectForKey:[NSNumber numberWithUnsignedLongLong:(unsigned long long)touch]];
            }
            else {
                [train moveTo:location];
            }
        }
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        BlockTrain *train = [blockTrains objectForKey:[NSNumber numberWithUnsignedLongLong:(unsigned long long)touch]];
        if (train != nil) {
            //Play block drop sound
            [[SimpleAudioEngine sharedEngine] playEffect:@"train_snap.m4a"];
            [train snap];
            [blockTrains removeObjectForKey:[NSNumber numberWithUnsignedLongLong:(unsigned long long)touch]];
            if ([self isComplete])
            {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"BoardComplete" object:self];
            }
        }
    }
}

-(BOOL) isComplete
{
    if ([blockTrains count] > 0) {
        return NO;
    }
    
    for (int x = 0; x < columnCount; x++) {
        for (int y = 0; y < rowCount; y++) {
            GoalSprite *goal = [self goalAtX:x y:y];
            BlockSprite *block = [self blockAtX:x y:y]; 
            if (goal != nil && goal.comparable) {
                 if (!([goal onCompareWithCell:block] || (block != nil && [block onCompareWithCell:goal])))
                     return NO;
            }
        }
    }
  
    return YES;
}

-(BOOL) isOutOfBoundsAtX:(int)x y:(int)y
{
    return x<0||y<0||x>=columnCount||y>=rowCount;
}

-(int) rowAtPoint:(CGPoint)point
{
    return (int)floorf(point.y / cellSize.height);
}

-(int) columnAtPoint:(CGPoint)point
{
    return (int)floorf(point.x / cellSize.width);
}

@end
