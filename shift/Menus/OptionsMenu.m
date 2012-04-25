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

@implementation OptionsMenu

-(id) init
{
    if( (self=[super init] )) {
        [self addBackButton];
        [self addSoundButton];
    }
    
    return self;
}

-(void)toggleMute:(id)sender
{
    [SimpleAudioEngine sharedEngine].mute = ![SimpleAudioEngine sharedEngine].mute;
    if (![SimpleAudioEngine sharedEngine].mute) {
        [[SimpleAudioEngine sharedEngine] playEffect:@SFX_MENU];
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
    //CCScrollLayer *scroll = [CCScrollLayer alloc] initWithLayers:<#(NSArray *)#> widthOffset:<#(int)#>];
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
            }
        }
        highlightedSprite = nil;
    }
}

@end
