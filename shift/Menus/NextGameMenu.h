//
//  NextGameMenu.h
//  shift
//
//  Created by Brad Misik on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ButtonList.h"

@interface NextGameMenu : CCLayerColor
{
    ButtonList *buttons;
}

-(id) initWithMessage:(NSString *)msg time:(NSTimeInterval)time moves:(int)moves;

@end
