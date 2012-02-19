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
        
        //Retrieve highest completed level by user (set to 0 if user defaults are not saved)
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        highestLevel = [defaults integerForKey:@"highestLevel"];

        //Set up menu items
        CCMenu *menu = [CCMenu menuWithItems:nil];
        CCMenuItemLabel *levelLabel;
        
        //Add an entry for every level
        for (int i = 0; i < NUM_LEVELS; i++) {
            levelLabel = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", i+1] fontName:@"Marker Felt" fontSize:32.0f]target:self selector:@selector(levelSelect:)];
            [levelLabel setTag:i];
            
            //Set the colors based on which levels are unlocked.
            if(i<=highestLevel)
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
    
    if(levelNum<=highestLevel)
    {
        NSString *levelFile = [NSString stringWithFormat:@"%d.plist", levelNum+1];

        [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipAngular transitionWithDuration:TRANS_TIME scene:[BoardLayer scene]]];
    }
}

-(void) dealloc
{
	[super dealloc];
}

@end
