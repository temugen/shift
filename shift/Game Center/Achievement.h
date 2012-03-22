//
//  Achievement.h
//  shift
//
//  Created by Jicong Wang on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Achievement : NSObject<NSCoding>{
    NSMutableDictionary * achievements;
}
-(NSMutableDictionary*) getAchievements;
-(void)setAchievements:(NSMutableDictionary*) other;

@end
