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
    if ((self = [super init])) {
        NSString *shift = @"SHIFT!";
        NSString *colors[] = {@"blue", @"purple", @"red", @"orange", @"yellow", @"green"};
        BlockSprite *blocks[[shift length]];
        CCLabelTTF *labels[[shift length]];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        float titleHeight = screenSize.height / 5;
        
        GoalSprite *goal = [GoalSprite goalWithName:@"blue"];
        CGPoint scaleFactors = [goal resize:CGSizeMake(titleHeight, titleHeight)];
        goal.position = ccp(titleHeight / 2, titleHeight / 2);
        [self addChild:goal];
        
        float blockWidth;
        
        for (int i = 0; i < [shift length]; i++) {
            blocks[i] = [BlockSprite blockWithName:colors[i]];
            [blocks[i] scaleWithFactors:scaleFactors];
            blockWidth = blocks[i].contentSize.width * blocks[i].scaleX; 
            blocks[i].position = ccp(goal.position.x + (blockWidth * i), goal.position.y);
            [self addChild:blocks[i]];
            
            labels[i] = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%c", [shift characterAtIndex:i]]
                                           fontName:@"Copperplate-Light" fontSize:blockWidth];
            [labels[i] addStrokeWithSize:2 color:ccc3(0, 0, 0)];
            labels[i].position = blocks[i].position;
            [self addChild:labels[i]];
            
            id actionMove = [CCMoveTo actionWithDuration:1.0 position:blocks[i].position];
            blocks[i].position = goal.position;
            [blocks[i] runAction:actionMove];
            
            actionMove = [CCMoveTo actionWithDuration:1.0 position:labels[i].position];
            labels[i].position = goal.position;
            [labels[i] runAction:actionMove];
        }
        
        self.isRelativeAnchorPoint = YES;
        self.contentSize = CGSizeMake((titleHeight / 2) + (blockWidth / 2) + (blockWidth * ([shift length] - 1)),
                                      titleHeight);
    }
    return self;
}

@end
