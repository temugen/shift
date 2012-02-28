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

-(id) initWithName:(NSString *)blockName;

-(void) decreaseHealth;
-(BOOL) onCollideWithCell:(CellSprite *)cell force:(float)force;
-(void) destroyBlock;

@end
