//
//  QuickPlayGame.h
//  shift
//
//  Created by Brad Misik on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

@interface QuickPlayGame : GameScene
{
    int rowCount, columnCount;
}

+(QuickPlayGame *) lastGame;
+(QuickPlayGame *) gameWithNumberOfRows:(int)rows columns:(int)columns;

-(id) initWithNumberOfRows:(int)rows columns:(int)columns;

@end
