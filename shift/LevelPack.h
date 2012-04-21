//
//  LevelPack.h
//  shift
//
//  Created by Brad Misik on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelPack : NSObject
{
    NSDictionary *packs;
    NSArray *levels;
    NSString *currentPack;
    
    @public
    NSArray *packNames;
}

@property(readonly) NSArray *packNames;

+(LevelPack *) sharedPack;

-(id) initWithFile:(NSString *)filename;

-(void) setPack:(NSString *)packName;
-(NSString *) levelNameWithNumber:(int)num;
-(NSString *) levelNameWithNumber:(int)num fromPack:(NSString *)packName;
-(NSDictionary *) levelWithNumber:(int)num;
-(NSDictionary *) levelWithNumber:(int)num fromPack:(NSString *)packName;
-(NSDictionary *) levelWithName:(NSString *)name;
-(NSDictionary *) levelWithName:(NSString *)name fromPack:(NSString *)packName;

@end
