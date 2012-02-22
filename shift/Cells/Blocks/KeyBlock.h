//
//  KeyBlock.h
//  shift
//
//  Created by Greg McLain on 2/21/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "BlockSprite.h"

@interface KeyBlock : BlockSprite

+(id) blockWithName:(NSString *)name;

-(BOOL) onCollideWithCell:(CellSprite *)cell force:(float)force;
-(void) removeKey;

@end
