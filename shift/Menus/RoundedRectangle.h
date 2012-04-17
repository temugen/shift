//
//  RoundedRectangle.h
//  shift
//
//  Created by Greg McLain on 4/9/12.
//  Copyright (c) 2012. All rights reserved.
//

@interface RoundedRectangle : CCSprite
{
    CGRect gradientBox;
}

-(id) initWithWidth:(float)width height:(float)height pressed:(BOOL)pressed;
-(void) createGradientWithInvert:(BOOL)pressed;

@end
