//
//  Menu.h
//  shift
//
//  Created by Greg McLain on 2/15/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "cocos2d.h"

@interface Menu : CCLayer
{
    CGPoint corners[4];
}

+(id) scene;
+(id) sceneWithMenu:(Menu *)menu;

-(void) goBack:(id)sender;

@end
