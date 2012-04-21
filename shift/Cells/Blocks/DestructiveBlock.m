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
        health = platformMinCollisionForce * 15;
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

-(void) crack
{
    CCRenderTexture *cracked = [CCRenderTexture renderTextureWithWidth:self.contentSize.width
                                                                height:self.contentSize.height];
    [cracked beginWithClear:0 g:0 b:0 a:0];
    CCSprite *current = [CCSprite spriteWithTexture:self.texture];
    current.scaleY = -1;
    current.position = ccp(current.contentSize.width / 2, current.contentSize.height / 2);
    [current visit];
    
    CCSprite *crack = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"crack1.png"]];
    crack.blendFunc = (ccBlendFunc){GL_ZERO, GL_ONE_MINUS_SRC_ALPHA};
    int randomX = arc4random() % (int)self.contentSize.width;
    int randomY = arc4random() % (int)self.contentSize.height;
    crack.position = ccp(randomX, randomY);
    int degrees = arc4random() % 360;
    crack.rotation = degrees * M_PI / 180;
    [crack visit];
    [cracked end];
    
    self.texture = cracked.sprite.texture;
}

-(void) takeHit:(int)damage
{
    health -= damage;
    
    if (health <= 0) {
        [self destroyBlock];
    }
    else {
        [self crack];
    }
}

-(void) destroyBlock
{
    [self.board removeBlock: self];
    [[SimpleAudioEngine sharedEngine] playEffect:@SFX_DESTRUCT];
}


@end
