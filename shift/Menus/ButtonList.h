//
//  ButtonList.h
//  shift
//
//  Created by Brad Misik on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoundedRectangle.h"

@interface ButtonList : CCLayer
{
    float buttonHeight;
}

-(id) init;

-(void) addNode:(CCNode *)node target:(id)target selector:(SEL)selector;
-(void) addButtonWithDescription:(NSString *)text target:(id)target selector:(SEL)selector;
-(void) addButtonWithDescription:(NSString *)text target:(id)target selector:(SEL)selector iconFilename:(NSString *)filename colorString:(NSString *)color;

@end
