//
//  BlockSprite.m
//  shift
//
//  Created by Brad Misik on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BlockSprite.h"
#import "ColorPalette.h"

@implementation BlockSprite

-(id) initWithName:(NSString *)color
{
    if ((self = [super initWithFilename:[NSString stringWithFormat:@"block.png", color]])) {
        name = color;
        self.color = [[ColorPalette sharedPalette] colorWithName:color];
    }
    return self;
}

+(id) blockWithName:(NSString *)name
{
    return [[[self class] alloc] initWithName:name];
}

-(BOOL) onMoveWithDistance:(float)distance vertically:(BOOL)vertically
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialComplete" object:self];
    return NO;
}

@end
