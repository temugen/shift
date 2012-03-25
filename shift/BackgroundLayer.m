//
//  BackgroundLayer.m
//  shift
//
//  Created by Brad Misik on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer

@synthesize texture;

-(id) init
{
    if ((self = [super init])) {
        ccTexParams params = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
        texture = [[CCTextureCache sharedTextureCache] addImage:@"background.png"];
        [texture setTexParameters:&params];
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithTexture:texture
                                                      rect:CGRectMake(0, 0, screenSize.width, screenSize.height)];
        background.position = ccp(screenSize.width / 2, screenSize.height / 2);
        [self addChild:background];
    }
    
    return self;
}

@end
