//
//  BlockSprite.h
//  shift
//
//  Created by Brad Misik on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CellSprite.h"

@interface BlockSprite : CellSprite
{

}

-(id) initWithName:(NSString *)name;
+(id) blockWithName:(NSString *)name;

@end
