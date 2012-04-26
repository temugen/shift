//
//  ColorPalette.m
//  shift
//
//  Created by Brad Misik on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColorPalette.h"

@implementation ColorPalette

@synthesize paletteNames;
@synthesize colorNames;
@synthesize currentPalette;

+(ColorPalette *) sharedPalette
{
    static ColorPalette *sharedPalette = nil;
    if (sharedPalette != nil)
        return sharedPalette;
    
    @synchronized(self)
    {
        if (sharedPalette == nil) {
            sharedPalette = [[ColorPalette alloc] initWithFile:@"colors.plist"];
            [sharedPalette setPalette:@"default"];
        }
    }
    return sharedPalette;
}

-(id) initWithFile:(NSString *)filename
{
    if ((self = [super init])) {
        NSString *extension = [filename pathExtension];
        NSString *baseName = [filename stringByDeletingPathExtension];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:baseName ofType:extension];
        palettes = [NSDictionary dictionaryWithContentsOfFile:path];
        paletteNames = [palettes allKeys];
        [self setPalette:[paletteNames objectAtIndex:0]];
    }
    
    return self;
}

-(void) setPalette:(NSString *)paletteName
{
    NSDictionary *palette = [palettes objectForKey:paletteName];
    colors = [NSMutableDictionary dictionaryWithCapacity:[palette count]];
    colorNames = [palette allKeys];
    for (NSArray *colorName in colorNames) {
        NSArray *colorValues = [palette objectForKey:colorName];
        ccColor3B color = ccc3([[colorValues objectAtIndex:0] intValue],
                               [[colorValues objectAtIndex:1] intValue],
                               [[colorValues objectAtIndex:2] intValue]);
        [colors setObject:[NSData dataWithBytes:&color length:sizeof(color)] forKey:colorName];
    }
    currentPalette = paletteName;
}

-(NSString *) randomColorName
{
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

-(ccColor3B) colorWithName:(NSString *)colorName fromPalette:(NSString *)paletteName
{
    NSString *previousPalette = currentPalette;
    [self setPalette:paletteName];
    ccColor3B color = [self colorWithName:colorName];
    [self setPalette:previousPalette];
    return color;
}

@end
