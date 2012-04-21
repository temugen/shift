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
        health = 400;
        comparable = NO;
        movable = NO;
        name = blockName;
    }
    return self;
}

-(void) decreaseHealthBy:(int)damage;
{
    int decreasedHealth = self.health;
    if(health > 0) decreasedHealth -= damage;
    self.health = decreasedHealth;
}

-(BOOL) onCollideWithCell:(CellSprite *)cell force:(float)force
{
    if([cell.name isEqualToString:@"ram"])
    {
     
    }
    if(force < 30)
        return NO;
    
    NSLog(@"Health is %i", self.health);
    if(self.health >0)
    {
        [self decreaseHealthBy:force];
        NSLog(@"Health is %i", self.health);
    }
    else if(self.health <= 0)
    {
        //Play block destroy sound
        [[SimpleAudioEngine sharedEngine] playEffect:@SFX_DESTRUCT];
        
        [self destroyBlock];
    }
    
    return NO;
}

-(void) destroyBlock
{
    [self.board removeBlock: self];
}


@end
