//
//  OptionsMenu.m
//  shift
//
//  Created by Greg McLain on 2/19/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "OptionsMenu.h"
#import "SinglePlayerGame.h"
#import "ColorPalette.h"

#define SPRITES_PER_PAGE 4
#define PADDING (platformPadding * 4)

@implementation OptionsMenu

-(id) init
{
    if( (self=[super init] )) {
        [self addBackButton];
        [self addSoundButton];
        [self addBlockColors];
    }
    
    return self;
}

-(void)toggleMute:(id)sender
{
    [SimpleAudioEngine sharedEngine].mute = ![SimpleAudioEngine sharedEngine].mute;
    if (![SimpleAudioEngine sharedEngine].mute) {
        [[SimpleAudioEngine sharedEngine] playEffect:SFX_MENU];
    }
}

-(void)addSoundButton
{
    CCMenuItem *playing = [CCMenuItemImage itemFromNormalImage:@"mute.png" 
                                    selectedImage:@"mute.png" target:nil selector:nil];
    
    CCMenuItem *muted = [CCMenuItemImage itemFromNormalImage:@"mute.png" 
                                     selectedImage:@"mute.png" target:nil selector:nil];
    CCLabelTTF *redX = [CCLabelTTF labelWithString:@"X" fontName:@"Helvetica" fontSize:muted.contentSize.height];
    redX.position = ccp(muted.contentSize.width / 2, muted.contentSize.height / 2);
    redX.color = [[ColorPalette sharedPalette] colorWithName:@"red" fromPalette:@"_app"];
    [muted addChild:redX];
    
    CCMenuItemToggle *toggleItem = [CCMenuItemToggle itemWithTarget:self 
                                                           selector:@selector(toggleMute:) items:playing, muted, nil];
    CCMenu *toggleMenu = [CCMenu menuWithItems:toggleItem, nil];
    toggleMenu.position = ccp(platformPadding + playing.contentSize.width / 2, platformPadding + playing.contentSize.height / 2);
    [self addChild:toggleMenu];
}

-(void) addBlockColors
{
    int numPacks = [[ColorPalette sharedPalette].paletteNames count];
    NSMutableArray *pages = [NSMutableArray arrayWithCapacity:numPacks];
    NSMutableArray *levels = [NSMutableArray arrayWithCapacity:numPacks];
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    int spriteWidth = screenSize.width/8;
    
    CCLayer *page = [[CCLayer alloc] init];
    BOOL prev;
    CGPoint position,prevPos;
    
    NSString *currentPalette = [ColorPalette sharedPalette].currentPalette;
    
    int i = 0, paletteIndex = -1;
    for (NSString *paletteName in [ColorPalette sharedPalette].paletteNames) {
        paletteIndex++;
        
        //don't display private colors
        if ([paletteName hasPrefix:@"_"]) {
            continue;
        }
        
        i++;
        
        //Determine position of sprite. If there is already a level on the page, position this one next to it.
        if(prev) {
            position = ccp(prevPos.x+spriteWidth+PADDING,screenSize.height/2);
        }
        else {
            float offsetFactor = SPRITES_PER_PAGE/2.0 - 0.5;
            float paddingOffset = PADDING*(SPRITES_PER_PAGE-1)/2;
            position = ccp(screenSize.width/2-(offsetFactor*spriteWidth)-paddingOffset,screenSize.height/2);
            prev = YES;
        } 
        
        //Add rounded rectangle
        RoundedRectangle* rectSprite = [[RoundedRectangle alloc] initWithWidth:spriteWidth+20 height:spriteWidth*2 pressed:NO];
        rectSprite.position = position;
        rectSprite.tag = paletteIndex;
        [page addChild:rectSprite z:-1];
        [levels addObject:rectSprite];
        
        prevPos = position;
        
        [[ColorPalette sharedPalette] setPalette:paletteName];
        int numColors = [[ColorPalette sharedPalette].colorNames count];
        float blockHeight = rectSprite.contentSize.height / numColors - (platformPadding * 2 / numColors);
        CGSize blockSize = CGSizeMake(blockHeight, blockHeight);
        CGPoint blockStartPos = ccp(position.x, position.y - rectSprite.contentSize.height / 2 + platformPadding + blockHeight / 2);
        
        //Create block sprites
        for (int j = 0; j < numColors; j++) {
            BlockSprite *block = [BlockSprite blockWithName:[[ColorPalette sharedPalette].colorNames objectAtIndex:j]];
            [block resize:blockSize];
            block.scaleY = -block.scaleY;
            block.position = ccp(blockStartPos.x, blockStartPos.y + j * blockHeight);
        
            [page addChild:block];
        }
        
        //If we filled up the page, create a new page
        if(i%SPRITES_PER_PAGE == 0)
        {
            [pages addObject:page];
            page = [[CCLayer alloc] init];
            
            prev = NO;
        }
    }
    
    [[ColorPalette sharedPalette] setPalette:currentPalette];
    
    //Don't add the page if there's nothing on it.
    if([[page children] count]>0)
    {
        [pages addObject:page];
    }
    
    scroller = [[CCScrollLayer alloc] initWithLayers:pages widthOffset: 0];
    [scroller setScrollerVisibility:NO];
    
    //Set display page to page containing highest level completed by user
    [scroller setPageVisibility:0 visible:YES];
    [scroller selectPage:0];
    [self addChild:scroller];
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
    [scroller setPageVisibility:[scroller currentScreen] visible:YES];
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
                NSString *paletteName = [[ColorPalette sharedPalette].paletteNames objectAtIndex:highlightedSprite.tag];
                [[ColorPalette sharedPalette] setPalette:paletteName];
            }
        }
        highlightedSprite = nil;
    }
}

@end
