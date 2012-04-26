//
//  BackgroundLayer.m
//  shift
//
//  Created by Brad Misik on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackgroundLayer.h"
#import "BlockSprite.h"
#import "GoalSprite.h"
#import "ColorPalette.h"

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
        
        CCLayerGradient *gradient = [CCLayerGradient layerWithColor:ccc4(255, 255, 255, 255) fadingTo:ccc4(0, 0, 0, 255)];
        gradient.compressedInterpolation = NO;
        [self addChild:gradient z:-1];
        
        //Store blocks to check for collisions
        blocks = [NSMutableArray arrayWithCapacity:MAX_BLOCKS];

        //Initialize all of the background blocks
        for (int i=0; i<MAX_BLOCKS; i++) 
        {
            BlockSprite* block = [BlockSprite blockWithName:@"red"];
            
            //Scale the block
            GoalSprite *sampleGoal = [GoalSprite goalWithName:@"red"];
            CGPoint scalingFactors = [sampleGoal resize:CGSizeMake(platformCellSize.width * 2, platformCellSize.height * 2)];
            blockSize = [block scaleWithFactors:scalingFactors];
            
            block.visible = NO;
            block.opacity = 50;
            
            [self addChild:block];
            
            [blocks addObject:block];
        }
    }
    
    return self;
}


//Randomly creates block and sends along background
-(void) createBackgroundBlock:(BlockSprite*) block
{
    //Choose color
    block.color = [[ColorPalette sharedPalette] randomColor];
    
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

-(void) onExit
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super onExit];
}

-(void) onEnter
{
    [super onEnter];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onRecolor:)
                                                 name:@"ColorChanged"
                                               object:nil];
    for(BlockSprite *block in blocks) {
        [self createBackgroundBlock:block];
    }
}

-(void) onRecolor:(NSNotification *)notification
{
    for (BlockSprite *block in blocks) {
        block.color = [[ColorPalette sharedPalette] randomColor];
    }
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
        if(curr!=block && fabs(block.position.x-curr.position.x)<=blockSize.width)
            return YES;
    }
    return NO;
}

//Sets random position for block and returns destination point corresponding to position.
-(CGPoint) randomizePosition:(BlockSprite*) block
{
    CGPoint destination;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    int randomX = arc4random()%(int)(screenSize.width/blockSize.width);
    int randomY = arc4random()%(int)(screenSize.height/blockSize.width);
    int side = arc4random()%4;
    
    switch (side) {
        case 0:
            block.position = ccp(blockSize.width*-1,randomY*blockSize.width);
            destination = ccp(screenSize.width+blockSize.width,randomY*blockSize.width);
            break;
        case 1:
            block.position = ccp(screenSize.width+blockSize.width,randomY*blockSize.width);
            destination = ccp(blockSize.width*-1,randomY*blockSize.width);
            break;
        case 2:
            block.position = ccp(randomX*blockSize.width,blockSize.width*-1);
            destination = ccp(randomX*blockSize.width,screenSize.height+blockSize.width);
            break;
        case 3:
            block.position = ccp(randomX*blockSize.width,screenSize.height+blockSize.width);
            destination = ccp(randomX*blockSize.width,blockSize.width*-1);
            break;
            
        default:
            break;
    }
    
    return destination;
}

@end
