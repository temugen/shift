//
//  TitleLayer.m
//  shift
//
//  Created by Jicong Wang on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TitleLayer.h"
#import "GoalSprite.h"
#import "BlockSprite.h"
#import "ColorPalette.h"

@implementation TitleLayer

-(id) init
{
    if( (self=[super init] )) 
    {
        CCSprite *title = [CCSprite spriteWithFile:@"title.png"];
        [self addChild:title];
        
        GoalSprite *goal = [GoalSprite goalWithName:@"blue"];
        CGPoint factors = [goal resize:CGSizeMake(title.contentSize.height, title.contentSize.height)];
        goal.color = [[ColorPalette sharedPalette] colorWithName:@"blue" fromPalette:@"_app"];
        [self addChild:goal];
        
        BlockSprite *block = [BlockSprite blockWithName:@"blue"];
        [block scaleWithFactors:factors];
        block.color = [[ColorPalette sharedPalette] colorWithName:@"blue" fromPalette:@"_app"];
        [self addChild:block];
        
        self.isRelativeAnchorPoint = YES;
        self.contentSize = CGSizeMake(title.contentSize.width + CGRectGetWidth(block.boundingBox), title.contentSize.height);
        
        title.position = ccp(self.contentSize.width - title.contentSize.width / 2, self.contentSize.height / 2);
        goal.position = ccp(self.contentSize.width - CGRectGetWidth(goal.boundingBox) / 2, self.contentSize.height / 2);
        block.position = goal.position;
        
        id actionMove = [CCMoveTo actionWithDuration:1.0
                                            position:ccp(CGRectGetWidth(block.boundingBox) / 2,
                                                         self.contentSize.height / 2)];
        [block runAction:actionMove];
    }
    return self;
}

@end
