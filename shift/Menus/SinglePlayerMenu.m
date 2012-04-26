//
//  SinglePlayerMenu.m
//  shift
//
//  Created by Greg McLain on 2/15/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SinglePlayerMenu.h"
#import "SinglePlayerGame.h"
#import "MainMenu.h"
#import "LevelPack.h"

#define SPRITES_PER_PAGE 4
#define PADDING (platformPadding * 2)
#define LOCKED -1
#define LEVEL_TEXTURE -1

NSInteger highestLevel;

@implementation SinglePlayerMenu

//Initialize the Single Player layer
-(id) init
{
    if( (self=[super init] )) {
        
        highlightedSprite = nil;
        
        //Retrieve highest completed level by user (set to 0 if user defaults are not saved)
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        highestLevel = [defaults integerForKey:@"highestLevel"];
        if (highestLevel == 0) 
        {
            highestLevel = 1;
        }   
        highestLevel = 20;

        int numLevels = [[LevelPack sharedPack] numLevels];
        NSMutableArray * pages = [NSMutableArray arrayWithCapacity:numLevels];
        NSMutableArray * levels = [NSMutableArray arrayWithCapacity:numLevels];
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        int spriteWidth = screenSize.width/8;
        
        CCLayer *page = [[CCLayer alloc] init];
        BOOL prev;
        CGPoint position,prevPos;
        
        for (int i=1;i<=numLevels;i++)
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
            RoundedRectangle* rectSprite = [[RoundedRectangle alloc] initWithWidth:spriteWidth+20 height:spriteWidth*2 pressed:NO];
            rectSprite.position = position;
            [rectSprite setTag:i];
            [page addChild:rectSprite z:-1];
            [levels addObject:rectSprite];
            
            prevPos = position;
            
            //Only display level previews for unlocked levels
            if(i<=highestLevel)
            {
                //Create level texture
                CCSprite *levelSprite = [SinglePlayerGame previewForLevel:i];
                [levelSprite setTag:LEVEL_TEXTURE];
                levelSprite.scaleX = spriteWidth/levelSprite.contentSize.width;
                levelSprite.scaleY = -levelSprite.scaleX;
                levelSprite.position = position;
                
                [page addChild:levelSprite];
            }
            else 
            {
                CCSprite *lockSprite = [CCSprite spriteWithFile:@"block_lock.png"];
                [lockSprite setTag:LOCKED];
                lockSprite.scaleX = rectSprite.contentSize.width/lockSprite.contentSize.width;
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
        
        scroller = [[CCScrollLayer alloc] initWithLayers:pages widthOffset: 0];
        [scroller setScrollerVisibility:NO];
        
        //Set display page to page containing highest level completed by user
        //Make highestLevel 0-based for this calculation.
        int pageSelection = (highestLevel-1)/SPRITES_PER_PAGE;
        [scroller setPageVisibility:pageSelection visible:YES];
        
        [scroller selectPage:pageSelection];
        
        [self addChild:scroller];
        
        [self addBackButton];
    }
    return self;
}

-(void) loadLevel:(int) levelNum
{
    if(levelNum != LOCKED && levelNum<=highestLevel)
    {
        SinglePlayerGame *game = [SinglePlayerGame gameWithLevel:levelNum];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:kSceneTransitionTime scene:game]];
    }
}

- (void)onEnter
{
    [super onEnter];
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
}

-(void) onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    [scroller setScrollerVisibility:YES];

}

-(void) onExit
{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

-(void) goBack:(id)sender
{
    [scroller setScrollerVisibility:NO];
    [super goBack:sender]; 
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    CCLayer* currPage = [scroller getCurrentPage];
    
    for(CCSprite* curr in [currPage children])
    {
        if(CGRectContainsPoint([curr boundingBox], touchPoint) && [curr tag] > 0)
        {          
            highlightedSprite = curr;
            curr.flipY = YES;
        }
    }
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
        
    if(highlightedSprite)
    {
        highlightedSprite.flipY = NO;
        if(touch.tapCount == 1)
        {
            if(CGRectContainsPoint([highlightedSprite boundingBox], touchPoint))
            {
                [self loadLevel:[highlightedSprite tag]];
            }
        }
        highlightedSprite = nil;
    }
}


@end
