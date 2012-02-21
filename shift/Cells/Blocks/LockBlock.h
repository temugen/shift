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
    BOOL locked;
}

@property(nonatomic, assign) BOOL locked;

+(id) blockWithName:(NSString *)name;

@end
