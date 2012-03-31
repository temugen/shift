//
//  BackgroundLayer.m
//  shift
//
//  Created by Brad Misik on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackgroundLayer.h"
#import "BlockSprite.h"

#define SIZE 35
#define MAX_BLOCKS 10
#define TRAVEL_TIME 3.0 


@implementation BackgroundLayer

-(id) init
{
    if ((self = [super init])) {
        
        CGSize screenSize = [[CCDirector sharedDirector] displaySizeInPixels];
        corners[0] = ccp(0, 0);
        corners[1] = ccp(0, screenSize.height);
        corners[2] = ccp(screenSize.width, screenSize.height);
        corners[3] = ccp(screenSize.width, 0);
        
        //Store blocks to check for collisions
        blocks = [NSMutableArray arrayWithCapacity:MAX_BLOCKS];

        //Initialize all of the background blocks
        for (int i=0; i<MAX_BLOCKS; i++) 
        {
            BlockSprite* block = [BlockSprite blockWithName:@"red"];
            
            //Scale the block
            [block setScaleX:SIZE/block.contentSize.width];
            [block setScaleY:SIZE/block.contentSize.height];
            
            block.visible = NO;
            
            [self addChild:block z:-1];
            [blocks addObject:block];
            
            [self createBackgroundBlock:block];
        }
    }
    
    return self;
}


//Randomly creates block and sends along background
-(void) createBackgroundBlock:(BlockSprite*) block
{
    //Choose color
    NSArray *colorNames = [colors allKeys];
    int colorIndex = arc4random() % [colors count];
    const ccColor3B *ccColor = [[colors objectForKey:[colorNames objectAtIndex:colorIndex]] bytes];
    [block setColor:*ccColor];
    
    //Get start and destination positions
    CGPoint destination = [self randomizePosition:block];
    
    //Create actions for block
    float delay = arc4random()%2;
    id move = [CCMoveTo actionWithDuration:TRAVEL_TIME position:destination];
    id doneAction = [CCCallFuncND actionWithTarget:self selector:@selector(blockComplete:data:) data:(void*)block];
    id visible = [CCToggleVisibility action];
    
    //If there is a collision with another block, delay the block, then randomly select another position
    if ([self locationCollision:block])
    {
        [block runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.5],doneAction,nil]];
    }
    else //else, run the actions normally
    {
        [block runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delay],visible,move,doneAction,nil]];
    }
}

-(void) draw
{
    //Draw dimmed background screen
    glColor4ub(20, 20, 20, 200);
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, corners);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}

//Callback function called when block is done. Make the block invisible, and then reset it and send it again.
-(void) blockComplete:(id) sender data:(BlockSprite*) block
{
    block.visible = NO;
    [self createBackgroundBlock:block];
}

-(BOOL) locationCollision:(BlockSprite*) block
{
    NSEnumerator *enumerator = [blocks objectEnumerator];
    for (BlockSprite *curr in enumerator) 
    {
        if(curr!=block && fabs(block.position.x-curr.position.x)<=SIZE && fabs(block.position.x-curr.position.x)<=SIZE)
            return YES;
    }
    return NO;
}

//Sets random position for block and returns destination point corresponding to position.
-(CGPoint) randomizePosition:(BlockSprite*) block
{
    CGPoint destination;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    int randomX = arc4random()%(int)(screenSize.width/SIZE);
    int randomY = arc4random()%(int)(screenSize.height/SIZE);
    int side = arc4random()%4;
    
    switch (side) {
        case 0:
            block.position = ccp(SIZE*-1,randomY*SIZE);
            destination = ccp(screenSize.width+SIZE,randomY*SIZE);
            break;
        case 1:
            block.position = ccp(screenSize.width+SIZE,randomY*SIZE);
            destination = ccp(SIZE*-1,randomY*SIZE);
            break;
        case 2:
            block.position = ccp(randomX*SIZE,SIZE*-1);
            destination = ccp(randomX*SIZE,screenSize.height+SIZE);
            break;
        case 3:
            block.position = ccp(randomX*SIZE,screenSize.height+SIZE);
            destination = ccp(randomX*SIZE,SIZE*-1);
            break;
            
        default:
            break;
    }
    
    return destination;
}

@end
