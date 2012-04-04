//
//  MainMenu.m
//  shift
//
//  Created by Greg McLain on 2/14/12.
//  Copyright (c) 2012. All rights reserved.
//

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

@implementation MainMenu

//Initialize the Main Menu layer
-(id) init
{
    if( (self=[super init] )) {
        //Play background music
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@BGM_MENU];
        
        //Set up menu items
        CCMenuItemFont *quickplay = [CCMenuItemFont itemFromString:@"Quickplay" target:self selector: @selector(onQuickplay:)];
        CCMenuItemFont *single = [CCMenuItemFont itemFromString:@"Single Player" target:self selector: @selector(onSinglePlayer:)];
        CCMenuItemFont *multi = [CCMenuItemFont itemFromString:@"Multiplayer" target:self selector: @selector(onMultiplayer:)];
      CCMenuItemFont *achievements= [CCMenuItemFont itemFromString:@"Achievements" target:self selector: @selector(onAchievements:)];
        CCMenuItemFont *options = [CCMenuItemFont itemFromString:@"Options" target:self selector: @selector(onOptions:)];
        
        //Add items to menu
        menu = [CCMenu menuWithItems: quickplay, single, multi, achievements, options, nil];
        
        //Shift menu down slightly to accomodate title
        menu.position = ccp(menu.position.x,menu.position.y-40);
        
        [menu alignItemsVertically];
        
        //Add menu to main menu layer
        [self addChild: menu];
        
    }
    return self;
}

//Create scene with main menu
+(id) scene
{
    MainMenu *mainMenu = [MainMenu node];
    TitleLayer *title = [TitleLayer node];
    title.position = ccp(mainMenu->menu.position.x,mainMenu->menu.position.y+140);
    
    CCScene* scene = [super sceneWithMenu:mainMenu];
    [scene addChild:title z:1];
    return scene;
}

/* Callback functions for main menu items */

- (void) onQuickplay: (id) sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[DifficultyMenu sceneWithMode:QUICKPLAY]]];
}

- (void) onSinglePlayer: (id) sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[SinglePlayerMenu scene]]];
}

- (void) onMultiplayer: (id) sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    if ([GameCenterHub sharedInstance].gameCenterAvailable) 
    { 
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[MultiplayerMenu scene]]];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"GameCenter Error" message:@"GameCenter is required to use any of the multiplayer features" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

- (void) onOptions: (id) sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[OptionsMenu scene]]];
}

- (void) onAchievements: (id) sender
{
    //Play menu selection sound
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:[AchievementsMenu scene]]];
}

@end

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
