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
    NSDictionary *palettes;
    NSMutableDictionary *colors;
    NSString *currentPalette;
    
    @public
    NSArray *paletteNames;
}

@property(readonly) NSArray *paletteNames;

+(ColorPalette *) sharedPalette;

-(id) initWithFile:(NSString *)filename;

-(void) setPalette:(NSString *)paletteName;
-(NSString *) randomColorName;
-(ccColor3B) randomColor;
-(ccColor3B) colorWithName:(NSString *)colorName;
-(ccColor3B) colorWithName:(NSString *)colorName fromPalette:(NSString *)paletteName;

@end
