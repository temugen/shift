//
//  TitleLayer.m
//  shift
//
//  Created by Jicong Wang on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TitleLayer.h"
#import "MainMenu.h"
#import "SinglePlayerMenu.h"
#import "MultiplayerMenu.h"
#import "DifficultyMenu.h"
#import "OptionsMenu.h"
#import "AchievementsMenu.h"
#import "GameCenterHub.h"
#import "GoalSprite.h"
#import "BlockSprite.h"
#import "ColorPalette.h"

#define TEXT_BLOCK_SIZE 35
#define TITLE_BORDER_SIZE 50
@implementation TitleLayer

-(id) init
{
    if( (self=[super init] )) 
    {
        [self addTileWithText:@"S" color:@"red" position:-2];
        [self addTileWithText:@"H" color:@"blue" position:-1];
        [self addTileWithText:@"I" color:@"orange" position:0];
        [self addTileWithText:@"F" color:@"green" position:1];
        [self addTileWithText:@"T" color:@"purple" position:2];
        [self addTileWithText:@"!" color:@"yellow" position:3];
        
        
        //Add "Oh" sprite to title
        CCSprite *ohSprite = [CCSprite spriteWithFile:@"title_block.png"];
        [ohSprite setScaleX:TITLE_BORDER_SIZE/ohSprite.contentSize.width];
        [ohSprite setScaleY:TITLE_BORDER_SIZE/ohSprite.contentSize.height]; 
        ohSprite.position = ccp(ohSprite.position.x-160,ohSprite.position.y+20);
        
        
        CCLabelTTF* label = [[CCLabelTTF alloc] initWithString:@"Oh" 
                                                    dimensions:CGSizeMake([ohSprite contentSize].width, [ohSprite contentSize].height)  
                                                     alignment:UITextAlignmentCenter 
                                                      fontName:@"Helvetica-BoldOblique" 
                                                      fontSize:60.0f];
        
        label.color = ccBLACK;
        
        //Attempt to center the label.
        label.position = ccp(label.position.x+45,label.position.y+34);
        
        //Add label to the given block
        [ohSprite addChild:label z:1];
        
        //Rotate the sprite and add animation
        ohSprite.rotation = -15.0f;
        id scaleUp = [CCScaleTo actionWithDuration:0.5f scale:1.5f];
        id scaleDown = [CCScaleTo actionWithDuration:0.5f scale:0.5f];
        [ohSprite runAction:[CCSequence actions:scaleUp,scaleDown,nil]];
        
        [self addChild:ohSprite z:1];
    }
    return self;
}

//Creates a title tile based on the text and color given. The position is the tile offset
//of the current tile from the center of the title layer.
-(void)addTileWithText:(NSString*)text color:(NSString*)color position:(int)pos
{
    //Initialize border and block
    GoalSprite* border = [GoalSprite goalWithName:color];
    BlockSprite* block = [BlockSprite blockWithName:color];
    
    //Set the color of the block to the desired color
    //[block setColor:[[ColorPalette sharedPalette] colorWithName:color]];
    
    //Add label to the block
    [TitleLayer createLabelWithText:text textBox:block];
    
    //Scale the block and the border
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGPoint factors = [block resize:CGSizeMake(screenSize.height / 8, screenSize.height / 8)];
    [border scaleWithFactors:factors];
    
    //Set the border and block position based on the position given. 
    border.position = ccp(border.position.x + (CGRectGetWidth([border boundingBox]) * pos), border.position.y);
    
    //Add some animation
    id move = [CCMoveBy actionWithDuration:1.5 position:border.position];
    id action = [CCEaseElasticIn actionWithAction:move];
    [block runAction: action];
    
    //Add the border and block to the title layer
    [self addChild:border z:0];
    [self addChild:block z:1];
    
}

//Create a label for the given letter in the title
+(void)createLabelWithText:(NSString*)text textBox:(CCSprite*)textBox
{
    CCLabelTTF* label = [[CCLabelTTF alloc] initWithString:text
                                                  fontName:@"Helvetica-Bold"
                                                  fontSize:CGRectGetWidth([textBox boundingBox])];
    
    label.color = ccBLACK;
    
    //Attempt to center the label.
    label.position = ccp(textBox.contentSize.width / 2, textBox.contentSize.height / 2);
    
    //Add label to the given block
    [textBox addChild:label z:1];
}

@end
