//
//  ColorPalette.m
//  shift
//
//  Created by Brad Misik on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColorPalette.h"

@interface ColorPalette()

/* Private Functions */
-(id) initWithFile:(NSString *)filename;

@end

@implementation ColorPalette

@synthesize paletteNames;

+(ColorPalette *) sharedPalette
{
    static ColorPalette *sharedPalette = nil;
    if (sharedPalette != nil)
        return sharedPalette;
    
    @synchronized(self)
    {
        if (sharedPalette == nil)
            sharedPalette = [ColorPalette colorPalette];
    }
    return sharedPalette;
}

+(ColorPalette *) defaultPalette
{
    static ColorPalette *defaultPalette = nil;
    if (defaultPalette != nil)
        return defaultPalette;
    
    @synchronized(self)
    {
        if (defaultPalette == nil)
            defaultPalette = [ColorPalette colorPalette];
    }
    return defaultPalette;
}

+(id) colorPalette
{
    return [[ColorPalette alloc] init];
}

-(id) init
{
    if ((self = [self initWithFile:@"colors.plist"])) {
        [self setPalette:@"default"];
    }
    
    return self;
}

-(id) initWithFile:(NSString *)filename
{
    if ((self = [super init])) {
        NSString *extension = [filename pathExtension];
        NSString *baseName = [filename stringByDeletingPathExtension];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:baseName ofType:extension];
        palettes = [NSDictionary dictionaryWithContentsOfFile:path];
        paletteNames = [palettes allKeys];
    }
    
    return self;
}

-(void) setPalette:(NSString *)paletteName
{
    NSDictionary *palette = [palettes objectForKey:paletteName];
    colors = [NSMutableDictionary dictionaryWithCapacity:[palette count]];
    NSArray *colorNames = [palette allKeys];
    for (NSArray *colorName in colorNames) {
        NSArray *colorValues = [palette objectForKey:colorName];
        ccColor3B color = ccc3([[colorValues objectAtIndex:0] intValue],
                               [[colorValues objectAtIndex:1] intValue],
                               [[colorValues objectAtIndex:2] intValue]);
        [colors setObject:[NSData dataWithBytes:&color length:sizeof(color)] forKey:colorName];
    }
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
