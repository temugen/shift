//
//  BoardLayer.m
//  shift
//
//  Created by Brad Misik on 8/17/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "BoardLayer.h"

// HelloWorldLayer implementation
@implementation BoardLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BoardLayer *layer = [BoardLayer node];
	[layer randomizeBoardWithWidth:11 withHeight:7];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void) destroyBoard
{
	if (blocks != NULL) {
        int count = boardWidth * boardHeight;
        for (int i = 0; i < count; i++) {
            [blocks[i] release];
        }
		free(blocks);
		blocks = NULL;
	}
}

-(void) setBlock:(Block *)block withX:(int)x withY:(int)y
{
	blocks[(y * boardWidth) + x] = block;
}

-(Block *) blockWithX:(int)x withY:(int)y
{
	return blocks[(y * boardWidth) + x];
}

-(void) randomizeBoardWithWidth:(int)width withHeight:(int)height
{
	[self destroyBoard];
	
	boardWidth = width;
	boardHeight = height;
	
	Block *sampleBlock = [Block spriteWithFile:@"block_blue.png"];
	
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	boardX = screenSize.width / 2 - (boardWidth * [sampleBlock blockSize].width) / 2 + [sampleBlock blockSize].width / 2;
	boardY = screenSize.height / 2 - (boardHeight * [sampleBlock blockSize].height) / 2 + [sampleBlock blockSize].height / 2;
	
	blocks = (Block **)malloc(width * height * sizeof(Block *));
    Block *block;
	for (int x = 0; x < boardWidth; x++) {
		for (int y = 0; y < boardHeight; y++) {
            
            //Keep random blocks clear
            if (arc4random() % 2 == 0) {
                [self setBlock:NULL withX:x withY:y];
                continue;
            }
            
            NSArray *available_blocks = [Block availableBlocks];
            NSUInteger randomIndex = arc4random() % [available_blocks count];
            block = [Block spriteWithFile:[available_blocks objectAtIndex:randomIndex]];
			[self setBlock:block withX:x withY:y];
			block.position = ccp(boardX + x * [block blockSize].width, boardY + y * [block blockSize].height);
			block.row = y;
			block.column = x;
			[self addChild:block];
            
            CCLabelTTF *label = [CCLabelTTF labelWithString:@"B" fontName:@"Marker Felt" fontSize:18];
            //label.color = ccc3(50, 50, 50);
            label.position = block.position;
            [self addChild:label z:2];
		}
	}
}

-(id) init
{
	if((self=[super init])) {
		self.isTouchEnabled = YES;
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Shift" fontName:@"Marker Felt" fontSize:18];
		CGSize size = [[CCDirector sharedDirector] winSize];
		label.position =  ccp(18, size.height - 12);
		[self addChild: label];
		
		blocks = NULL;
	}
	return self;
}

-(Block *) blockCollidingWithPoint:(CGPoint)point
{
    Block *block;
	for (int x = 0; x < boardWidth; x++) {
		for (int y = 0; y < boardHeight; y++) {
			block = [self blockWithX:x withY:y];
			if (block && [block collidingWithPoint:point]) {
				return block;
			}
		}
	}
	return NULL;
}

-(void) updateBoard
{
    int count = boardWidth * boardHeight;
    Block *newBlocks[count];
    Block *block;
    
    //clear the new block array
    for (int i = 0; i < count; i++) {
        newBlocks[i] = NULL;
    }
    
    //set up the new block array with blocks in the correct indices
    for (int i = 0; i < count; i++) {
        if ((block = blocks[i])) {
            newBlocks[(boardWidth * block.row) + block.column] = block;
        }
    }
    
    //copy the new blocks over
    for (int i = 0; i < count; i++) {
        blocks[i] = newBlocks[i];
    }
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	CGPoint prevLocation = [touch previousLocationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	prevLocation = [[CCDirector sharedDirector] convertToGL:prevLocation];
    float xDiff = location.x - prevLocation.x, yDiff = location.y - prevLocation.y;
	
	//The first time we start moving
	if (movingBlock == NULL) {
		Block *collidingBlock = [self blockCollidingWithPoint:location];
		if (collidingBlock == NULL) {
			return;
		}
		movingBlock = collidingBlock;
        
		isMovingRow = (abs(xDiff) > abs(yDiff));
	}
    
    Block *block;
	if (isMovingRow) {
        bool isMovingRight = xDiff > 0 ? true : false;
        if (isMovingRight) {
            for (int x = boardWidth - 1; x >= 0; x--) {
                if ((block = [self blockWithX:x withY:movingBlock.row])) {
                    if (block.position.x + xDiff + [block blockSize].width > boardX + boardWidth * [block blockSize].width) {
                        xDiff = boardX + boardWidth * [block blockSize].width - block.position.x - [block blockSize].width;
                    }
                    block.position = ccp(block.position.x + xDiff, block.position.y);
                }
            }
        }
        else {
            for (int x = 0; x < boardWidth; x++) {
                if ((block = [self blockWithX:x withY:movingBlock.row])) {
                    if (block.position.x + xDiff < boardX) {
                        xDiff = boardX - block.position.x;
                    }
                    block.position = ccp(block.position.x + xDiff, block.position.y);
                }
            }
        }
	}
	else {
        bool isMovingUp = yDiff > 0 ? true : false;
        if (isMovingUp) {
            for (int y = boardHeight - 1; y >= 0; y--) {
                if ((block = [self blockWithX:movingBlock.column withY:y])) {
                    if (block.position.y + yDiff + [block blockSize].height > boardY + boardHeight * [block blockSize].height) {
                        yDiff = boardY + boardHeight * [block blockSize].height - block.position.y - [block blockSize].height;
                    }
                    block.position = ccp(block.position.x, block.position.y + yDiff);
                }
            }
        }
        else {
            for (int y = 0; y < boardHeight; y++) {
                if ((block = [self blockWithX:movingBlock.column withY:y])) {
                    if (block.position.y + yDiff < boardY) {
                        yDiff = boardY - block.position.y;
                    }
                    block.position = ccp(block.position.x, block.position.y + yDiff);
                }
            }
        }
	}
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    Block *block;
    int newIndex;
    if (isMovingRow) {
		for (int x = 0; x < boardWidth; x++) {
			if ((block = [self blockWithX:x withY:movingBlock.row])) {
                newIndex = round((block.position.x - boardX) / [block blockSize].width);
                block.position = ccp(boardX + newIndex * [block blockSize].width, block.position.y);
                block.column = newIndex;
            }
		}
	}
	else {
		for (int y = 0; y < boardHeight; y++) {
			if ((block = [self blockWithX:movingBlock.column withY:y])) {
                newIndex = round((block.position.y - boardY) / [block blockSize].height);
                block.position = ccp(block.position.x, boardY + newIndex * [block blockSize].height);
                block.row = newIndex;
            }
		}
	}
    
    [self updateBoard];
    
    movingBlock = NULL;
}

-(void) dealloc
{
	[self destroyBoard];
	[super dealloc];
}
@end
