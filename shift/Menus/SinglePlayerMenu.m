//
//  SinglePlayerMenu.m
//  shift
//
//  Created by Greg McLain on 2/15/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SinglePlayerMenu.h"
#import "SinglePlayerGame.h"
#import "CCScrollLayer.h"
#import "MainMenu.h"
#import "RoundedRectangle.h"

#define SPRITES_PER_PAGE 4
#define PADDING 40
#define LOCKED -1

NSInteger highestLevel;

@implementation SinglePlayerMenu

//Initialize the Single Player layer
-(id) init
{
    if( (self=[super init] )) {
        
        //Retrieve highest completed level by user (set to 0 if user defaults are not saved)
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        highestLevel = [defaults integerForKey:@"highestLevel"];
        if (highestLevel == 0) 
        {
            highestLevel = 1;
        }   
        
        NSMutableArray * pages = [NSMutableArray arrayWithCapacity:NUM_LEVELS];
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        int spriteWidth = screenSize.width/8;
        
        CCLayer *page = [[CCLayer alloc] init];
        BOOL prev;
        CGPoint position,prevPos;
        
        RoundedRectangle* backgroundSprite = [[RoundedRectangle alloc] initWithWidth:spriteWidth+20 height:spriteWidth*2];
        
        for (int i=1;i<=NUM_LEVELS;i++)
        {
            //Determine position of sprite. If there is already a level on the page, position this one next to it.
            if(prev)
            {
                position = ccp(prevPos.x+spriteWidth+PADDING,screenSize.height/2);
            }
            else 
            {
                float offsetFactor = SPRITES_PER_PAGE/2.0 - 0.5;
                float paddingOffset = PADDING*(SPRITES_PER_PAGE-1)/2;
                position = ccp(screenSize.width/2-(offsetFactor*spriteWidth)-paddingOffset,screenSize.height/2);
                prev = YES;
            }
            
            //Add rounded rectangle
            CCSprite* rectSprite = [CCSprite spriteWithTexture:[backgroundSprite texture]];
            rectSprite.position = position;
            [rectSprite setTag:i];
            [page addChild:rectSprite z:-1];
            
            prevPos = position;
            
            //Only display level previews for unlocked levels
            if(i<=highestLevel)
            {
                //Create level texture
                CCSprite *levelSprite = [SinglePlayerGame previewForLevel:i];
                [levelSprite setTag:i];
                levelSprite.scaleX = spriteWidth/levelSprite.contentSize.width;
                levelSprite.scaleY = -levelSprite.scaleX;
                levelSprite.position = position;
                
                [page addChild:levelSprite];
            }
            else 
            {
                CCSprite *lockSprite = [CCSprite spriteWithFile:@"blue_lock.png"];
                [lockSprite setTag:LOCKED];
                lockSprite.scaleX = spriteWidth/lockSprite.contentSize.width;
                lockSprite.position = position;
                
                [page addChild:lockSprite];            
            }
            
            //If we filled up the page, create a new page
            if(i%SPRITES_PER_PAGE == 0)
            {
                [pages addObject:page];
                page = [[CCLayer alloc] init];
                
                prev = NO;
            }
        }
        
        //Don't add the page if there's nothing on it.
        if([[page children] count]>0)
        {
            [pages addObject:page];
        }
        
        CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:pages widthOffset: 0];
        
        //Set display page to page containing highest level completed by user
        int pageSelection = highestLevel/SPRITES_PER_PAGE;
        [scroller selectPage:pageSelection];
        
        [self addChild:scroller];
        
        [self addBackButton];
    }
    return self;
}

+(void) levelSelect: (int) levelNum
{    
    if(levelNum != LOCKED && levelNum<=highestLevel)
    {
        SinglePlayerGame *game = [SinglePlayerGame gameWithLevel:levelNum];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipAngular transitionWithDuration:kSceneTransitionTime scene:game]];
    }
}


@end
