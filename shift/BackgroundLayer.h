//
//  BackgroundLayer.h
//  shift
//
//  Created by Brad Misik on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface BackgroundLayer : CCLayer
{
    @public
    CCTexture2D *texture;
}

@property(readonly) CCTexture2D *texture;

@end
