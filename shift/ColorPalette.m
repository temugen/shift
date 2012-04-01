//
//  ColorPalette.m
//  shift
//
//  Created by Brad Misik on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColorPalette.h"

@implementation ColorPalette

+(ColorPalette *) sharedPalette
{
    static ColorPalette *sharedPalette = nil;
    if (sharedPalette != nil)
        return sharedPalette;
    
    @synchronized(self)
    {
        if (sharedPalette == nil)
            sharedPalette = [[ColorPalette alloc] initWithFile:@"colors.plist"];
    }
    return sharedPalette;
}

-(id) initWithFile:(NSString *)filename
{
    if ((self = [super init])) {
        NSString *extension = [filename pathExtension];
        NSString *baseName = [filename stringByDeletingPathExtension];
        
        colors = [[NSMutableDictionary alloc] initWithCapacity:20];
        NSString *path = [[NSBundle mainBundle] pathForResource:baseName ofType:extension];
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:path];
        NSDictionary *defaults = [plist objectForKey:@"default"];
        NSArray *colorNames = [defaults allKeys];
        for (NSArray *colorName in colorNames) {
            NSArray *colorValues = [defaults objectForKey:colorName];
            ccColor3B color = ccc3([[colorValues objectAtIndex:0] intValue],
                                   [[colorValues objectAtIndex:1] intValue],
                                   [[colorValues objectAtIndex:2] intValue]);
            [colors setObject:[NSData dataWithBytes:&color length:sizeof(color)] forKey:colorName];
        }
    }
    return self;
}

-(NSString *) randomColorName
{
    NSArray *colorNames = [colors allKeys];
    int randomIndex = arc4random() % [colors count];
    return [colorNames objectAtIndex:randomIndex];
}

-(ccColor3B) randomColor
{
    return [self colorWithName:[self randomColorName]];
}

-(ccColor3B) colorWithName:(NSString *)colorName
{
    const ccColor3B *ccColor = [[colors objectForKey:colorName] bytes];
    return *ccColor;
}

@end
