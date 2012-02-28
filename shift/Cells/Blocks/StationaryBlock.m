//
//  StationaryBlock.m
//  shift
//
//  Created by Donghun Lee on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StationaryBlock.h"

@implementation StationaryBlock

-(id) initWithName:(NSString *)blockName
{
    NSString *filename = [NSString stringWithFormat:@"block_stationary.png"];
    if ((self = [super initWithFilename:filename])) {
        comparable = NO;
        movable = NO;
        name = blockName;
    }
    return self;
}

@end
