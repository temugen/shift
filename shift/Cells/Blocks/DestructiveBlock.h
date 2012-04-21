//
//  DestructiveBlock.h
//  shift
//
//  Created by Donghun Lee on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StationaryBlock.h"

@interface DestructiveBlock : StationaryBlock
{
    
}

-(void) decreaseHealthBy:(int) damage;
-(void) destroyBlock;

@end
