//
//  DestructiveBlock.m
//  shift
//
//  Created by Donghun Lee on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DestructiveBlock.h"
#import "BoardLayer.h"

@implementation DestructiveBlock

-(id) initWithName:(NSString *)blockName
{
    NSString *filename = [NSString stringWithFormat:@"block_destructive.png"];
    if ((self = [super initWithFilename:filename])) {
        health = platformMinCollisionForce * 8;
        comparable = NO;
        movable = NO;
        name = blockName;
    }
    return self;
}

-(BOOL) onCollideWithCell:(CellSprite *)cell force:(float)force
{
    if(![cell.name isEqualToString:@"ram"] || force < platformMinCollisionForce)
    {
        return NO;
    }
    
    [self takeHit:force];
    
    return YES;
}

-(void) takeHit:(int)damage
{
    health -= damage;
    
    if (health <= 0) {
        [self destroyBlock];
    }
}

-(void) destroyBlock
{
    [self.board removeBlock: self];
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_DESTRUCT];
}


@end
