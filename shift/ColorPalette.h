//
//  ColorPalette.h
//  shift
//
//  Created by Brad Misik on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorPalette : NSObject
{
    NSMutableDictionary *colors;
}

+(ColorPalette *) sharedPalette;

-(id) initWithFile:(NSString *)filename;

-(NSString *) randomColorName;
-(ccColor3B) randomColor;
-(ccColor3B) colorWithName:(NSString *)colorName;

@end
