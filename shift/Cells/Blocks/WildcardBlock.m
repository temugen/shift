//
//  WildcardBlock.m
//  shift
//
//  Created by Jicong Wang on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WildcardBlock.h"
#import "BoardLayer.h"
#import "ColorPalette.h"

@implementation WildcardBlock

-(id) initWithName:(NSString *)blockName
{
    NSString *filename = [NSString stringWithFormat:@"block_wild.png"];
    if ((self = [super initWithFilename:filename])) {
        comparable = YES;
        movable = YES;
        name = name;
    }
    return self;
}

-(BOOL) onCompareWithCell:(CellSprite *)cell
{
    return YES;
}

@end
