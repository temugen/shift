//
//  ButtonList.m
//  shift
//
//  Created by Brad Misik on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ButtonList.h"
#import "ColorPalette.h"

@implementation ButtonList

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
        
        float yDiff = buttonHeight - child.contentSize.height;
        child.contentSize = CGSizeMake(self.contentSize.width, buttonHeight);
        child.position = ccp(child.contentSize.width / 2,
                             self.contentSize.height - ((buttonHeight + platformPadding / 2) * i + buttonHeight / 2));
        for (CCNode *grandchild in child.children) {
            grandchild.position = ccp(grandchild.position.x, grandchild.position.y + yDiff);
        }
        
        RoundedRectangle *bg = [[RoundedRectangle alloc] initWithWidth:self.contentSize.width height:buttonHeight pressed:NO];
        bg.position = ccp(bg.contentSize.width / 2, bg.contentSize.height / 2);
        [child addChild:bg z:-1 tag:10];
    }
}

-(void) addNode:(CCNode *)node target:(id)target selector:(SEL)selector
{
    
}

-(void) addButtonWithDescription:(NSString *)text target:(id)target selector:(SEL)selector;
{
    CCLabelTTF *label = [CCLabelTTF labelWithString:text fontName:@"Copperplate-Light" fontSize:platformFontSize];
    [label addStrokeWithSize:5 color:ccBLACK];
    [self addChild:label];
}

-(void) addButtonWithDescription:(NSString *)text target:(id)target selector:(SEL)selector iconFilename:(NSString *)filename colorString:(NSString *)color
{
    CCSprite *sprite = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:filename]];
    sprite.color = [[ColorPalette sharedPalette] colorWithName:color fromPalette:@"_app"];
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:text fontName:@"Copperplate-Light" fontSize:platformFontSize];
    label.color = ccBLACK;
    [label addStrokeWithSize:1 color:ccWHITE];
    
    CCLayer *button = [CCLayer node];
    button.isRelativeAnchorPoint = YES;
    button.contentSize = CGSizeMake(label.contentSize.width + 3 * platformPadding + sprite.contentSize.width,
                                    MAX(label.contentSize.height, sprite.contentSize.height));
    self.contentSize = CGSizeMake(MAX(self.contentSize.width, button.contentSize.width),
                                  self.contentSize.height + button.contentSize.height + platformPadding / 2);
    
    sprite.position = ccp(platformPadding + sprite.contentSize.width / 2, button.contentSize.height / 2);
    [button addChild:sprite];
    label.position = ccp(CGRectGetMaxX(sprite.boundingBox) + platformPadding + label.contentSize.width / 2, button.contentSize.height / 2);
    [button addChild:label];
    button.userData = (__bridge_retained void *)[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [NSValue value:&selector withObjCType:@encode(SEL)], @"selector",
                                                 target, @"target", nil];
    
    [self addChild:button];
    
    buttonHeight = MAX(buttonHeight, button.contentSize.height);
    
    [self reformat];
}

-(void) dealloc
{
    for (CCNode *node in self.children) {
        CFRelease(node.userData);
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [self convertTouchToNodeSpace:[touches anyObject]];
    for (CCNode *node in self.children) {
        if (CGRectContainsPoint(node.boundingBox, location)) {
            NSDictionary *userData = (__bridge NSDictionary *)node.userData;
            SEL selector;
            [[userData objectForKey:@"selector"] getValue:&selector];
            [[userData objectForKey:@"target"] performSelector:selector withObject:self];
        }
    }
}

@end
