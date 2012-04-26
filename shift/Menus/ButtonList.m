//
//  ButtonList.m
//  shift
//
//  Created by Brad Misik on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ButtonList.h"
#import "ColorPalette.h"
#import "SimpleAudioEngine.h"

@implementation ButtonList

+(id) buttonList
{
    return [[ButtonList alloc] init];
}

-(id) init
{
    if ((self = [super init])) {
        self.isRelativeAnchorPoint = YES;
        self.contentSize = CGSizeMake(0, 0);
        self.isTouchEnabled = YES;
        buttonHeight = 0;
    }
    
    return self;
}

-(void) reformat
{
    for (int i = 0; i < [self.children count]; i++) {
        CCLayer *child = [self.children objectAtIndex:i];
        
        [child removeChildByTag:10 cleanup:YES];
        
        child.contentSize = CGSizeMake(self.contentSize.width, buttonHeight);
        child.position = ccp(child.contentSize.width / 2,
                             self.contentSize.height - ((buttonHeight + platformPadding) * i + buttonHeight / 2 + platformPadding / 2));
        
        CCNode *grandchild = [child.children objectAtIndex:0];
        grandchild.position = ccp(platformPadding + grandchild.contentSize.width / 2, buttonHeight / 2);
        
        RoundedRectangle *bg = [[RoundedRectangle alloc] initWithWidth:self.contentSize.width height:buttonHeight pressed:NO];
        bg.position = ccp(child.contentSize.width / 2, child.contentSize.height / 2);
        [child addChild:bg z:-1 tag:10];
    }
}

-(void) addNode:(CCNode *)node target:(id)target selector:(SEL)selector
{
    buttonHeight = MAX(buttonHeight, node.contentSize.height);
    self.contentSize = CGSizeMake(MAX(self.contentSize.width, node.contentSize.width + 2 * platformPadding),
                                  (buttonHeight + platformPadding) * ([self.children count] + 1));
    
    CCLayer *button = [CCLayer node];
    button.isRelativeAnchorPoint = YES;
    button.userData = (__bridge_retained void *)[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [NSValue value:&selector withObjCType:@encode(SEL)], @"selector",
                                                 target, @"target", nil];
    [button addChild:node];
    
    [self addChild:button];
}

-(void) addButtonWithDescription:(NSString *)text target:(id)target selector:(SEL)selector;
{
    CCLabelTTF *label = [CCLabelTTF labelWithString:text fontName:@"Copperplate-Light" fontSize:platformFontSize];
    label.color = ccBLACK;
    [label addStrokeWithSize:1  color:ccWHITE];
    [self addNode:label target:target selector:selector];
    [self reformat];
}

-(void) addButtonWithDescription:(NSString *)text target:(id)target selector:(SEL)selector iconFilename:(NSString *)filename colorString:(NSString *)color
{
    CCSprite *sprite = [CCSprite spriteWithFile:filename];
    sprite.color = [[ColorPalette sharedPalette] colorWithName:color fromPalette:@"_app"];
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:text fontName:@"Copperplate-Light" fontSize:platformFontSize];
    label.color = ccBLACK;
    [label addStrokeWithSize:1  color:ccWHITE];
    
    CCLayer *node = [CCLayer node];
    node.isRelativeAnchorPoint = YES;
    node.contentSize = CGSizeMake(sprite.contentSize.width + platformPadding + label.contentSize.width,
                                    MAX(label.contentSize.height, sprite.contentSize.height));
    
    sprite.position = ccp(sprite.contentSize.width / 2, node.contentSize.height / 2);
    [node addChild:sprite];
    label.position = ccp(CGRectGetMaxX(sprite.boundingBox) + platformPadding + label.contentSize.width / 2, node.contentSize.height / 2);
    [node addChild:label];
    
    [self addNode:node target:target selector:selector];
    [self reformat];
}

-(void) onExit
{
    for (CCNode *node in self.children) {
        CFRelease(node.userData);
    }
    [super onExit];
}

-(void) dealloc
{
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSSet *set = [NSSet setWithObject:touch];
    [self ccTouchesEnded:set withEvent:event];
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [self convertTouchToNodeSpace:[touches anyObject]];
    for (CCNode *node in self.children) {
        if (CGRectContainsPoint(node.boundingBox, location)) {
            NSDictionary *userData = (__bridge NSDictionary *)node.userData;
            SEL selector;
            [[userData objectForKey:@"selector"] getValue:&selector];
            
            [[SimpleAudioEngine sharedEngine] playEffect:SFX_MENU];
            [[userData objectForKey:@"target"] performSelector:selector withObject:self];
        }
    }
}

@end
