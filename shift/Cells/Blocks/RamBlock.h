//
//  RamBlock.h
//  shift
//
//  Created by Donghun Lee on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockSprite.h"

@interface RamBlock : BlockSprite

-(id) initWithName:(NSString *)blockName;

-(BOOL) onCollideWithCell:(CellSprite *)cell force:(float)force;
-(void) removeKey;

@end
