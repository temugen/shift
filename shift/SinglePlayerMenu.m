//
//  SinglePlayerMenu.m
//  shift
//
//  Created by Greg McLain on 2/15/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SinglePlayerMenu.h"
#import "BoardLayer.h"
#import "MainMenu.h"


#define NUM_LEVELS 20

@implementation SinglePlayerMenu

//Initialize the Single Player layer
-(id) init
{
    if( (self=[super init] )) {
        
        //Set up menu items
        
        CCMenu *menu = [CCMenu menuWithItems:nil];
        CCMenuItemLabel *levelLabel;
        
        //Add an entry for every level
        for (int i = 1; i < NUM_LEVELS+1; i++) {
            levelLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", i] fontName:@"Marker Felt" fontSize:32.0f]target:self selector:@selector(levelSelect:)];
            [levelLabel setTag:i];
            
            //Set the colors based on which levels are unlocked.
            //CURRENTLY SETTING ONLY 1 VALUE TO TEST
            if(i==1)
                [levelLabel setColor:ccWHITE];
            else
                [levelLabel setColor:ccGRAY];

            [menu addChild:levelLabel];
        }
        CCMenuItemFont *back = [CCMenuItemFont itemFromString:@"Back" target:self selector: @selector(goBack:)]; 
        [menu addChild:back];
        
        [menu alignItemsInColumns:
         [NSNumber numberWithInt:5], 
         [NSNumber numberWithInt:5], 
         [NSNumber numberWithInt:5], 
         [NSNumber numberWithInt:5], 
         [NSNumber numberWithInt:1], 
         nil];
                
        //Add menu to layer
        [self addChild: menu];
        
    }
    return self;
}

//Create scene with single player menu
+(id) scene
{
    SinglePlayerMenu *layer = [SinglePlayerMenu node];
    return [super scene:layer];
}

/* Callback functions for menu items */

//Displays level based on selection by the user. If level is not unlocked, it does nothing.
- (void) levelSelect: (id) sender
{
    int levelNum = [sender tag];
    
    switch (levelNum) {
        case 1:
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipAngular transitionWithDuration:0.3f scene:[BoardLayer scene]]];
            break;
        default:
            break;
    }
}

- (void) goBack: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.3f scene:[MainMenu scene]]];
}

-(void) dealloc
{
	[super dealloc];
}

@end
