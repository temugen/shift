//
//  LockBlock.h
//  shift
//
//  Created by Greg McLain on 2/21/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "BlockSprite.h"

@interface LockBlock : BlockSprite
{
    CCSprite *overlay;
}

-(void) unlock;
-(BOOL) dropKey;
-(BOOL) onDoubleTap;
-(BOOL) setKeyAtX:(int)x y:(int)y;

@end
