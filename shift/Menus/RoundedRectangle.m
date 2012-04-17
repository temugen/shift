//
//  RoundedRectangle.m
//  shift
//
//  Created by Greg McLain on 4/9/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "RoundedRectangle.h"

@implementation RoundedRectangle


-(id) initWithWidth:(float)width height:(float)height pressed:(BOOL)pressed
{
    CGSize size = CGSizeMake(width, height);
    CGPoint center = CGPointMake(size.width/2, size.height/2); 
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef boxPath = CGPathCreateMutable();
    CGFloat radius = 10.0;
    
    CGContextBeginPath(context);
    
    CGPathMoveToPoint(boxPath, nil, center.x , center.y - height/2);
    CGPathAddArcToPoint(boxPath, nil, center.x + width/2, center.y - height/2, center.x + width/2, center.y + height/2, radius);
    CGPathAddArcToPoint(boxPath, nil, center.x + width/2, center.y + height/2, center.x - width/2, center.y + height/2, radius);
    CGPathAddArcToPoint(boxPath, nil, center.x - width/2, center.y + height/2, center.x - width/2, center.y, radius);
    CGPathAddArcToPoint(boxPath, nil, center.x - width/2, center.y - height/2, center.x, center.y - height/2, radius);
    
    CGPathCloseSubpath(boxPath);
    CGContextAddPath(context, boxPath);    
    CGContextClosePath(context);
    CGContextClip(context);
    
    gradientBox = CGRectMake(center.x-width/2, center.y-height/2, width, height);
    
    if(pressed){
        [self createGradientWithInvert:YES];
    }
    else {
        [self createGradientWithInvert:NO];
    }
    
    static int counter = 0;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    self = [CCSprite spriteWithCGImage:image.CGImage key:[NSString stringWithFormat:@"image%d", counter++]];
    return self;
}

-(void) createGradientWithInvert:(BOOL)pressed
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 0.5 };
	CGFloat components[8] = {  0.92, 0.92, 0.92, 1.0, 0.82, 0.82, 0.82, 0.4 };
	
	CGGradientRef gradient = CGGradientCreateWithColorComponents (space, components, locations, num_locations);
    
    CGPoint startPoint, endPoint;
    if(pressed)
    {
        startPoint = CGPointMake(CGRectGetMidX(gradientBox), CGRectGetMinY(gradientBox)); 
        endPoint = CGPointMake(CGRectGetMidX(gradientBox), CGRectGetMaxY(gradientBox));
    }
    else
    {
        startPoint = CGPointMake(CGRectGetMidX(gradientBox), CGRectGetMaxY(gradientBox)); 
        endPoint = CGPointMake(CGRectGetMidX(gradientBox), CGRectGetMinY(gradientBox));
    }
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
}

@end
