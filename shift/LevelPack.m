//
//  LevelPack.m
//  shift
//
//  Created by Brad Misik on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelPack.h"

@implementation LevelPack

@synthesize packNames;
@synthesize levels;
@synthesize numLevels;
@synthesize currentPack;

+(LevelPack *) sharedPack
{
    static LevelPack *sharedPack = nil;
    if (sharedPack != nil)
        return sharedPack;
    
    @synchronized(self)
    {
        if (sharedPack == nil) {
            sharedPack = [[LevelPack alloc] initWithFile:@"levels.plist"];
            [sharedPack setPack:@"default"];
        }
    }
    return sharedPack;
}

-(id) initWithFile:(NSString *)filename
{
    if ((self = [super init])) {
        NSString *extension = [filename pathExtension];
        NSString *baseName = [filename stringByDeletingPathExtension];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:baseName ofType:extension];
        packs = [NSDictionary dictionaryWithContentsOfFile:path];
        packNames = [packs allKeys];
        [self setPack:[packNames objectAtIndex:0]];
    }
    
    return self;
}

-(void) setPack:(NSString *)packName
{
    levels = [packs objectForKey:packName];
    numLevels = [levels count] - 1;
}

-(NSString *) levelNameWithNumber:(int)num
{
    return [levels objectAtIndex:num];
}

-(NSString *) levelNameWithNumber:(int)num fromPack:(NSString *)packName
{
    NSString *previousPack = currentPack;
    [self setPack:packName];
    NSString *levelName = [self levelNameWithNumber:num];
    [self setPack:previousPack];
    return levelName;
}

-(NSDictionary *) levelWithNumber:(int)num
{
    return [self levelWithName:[self levelNameWithNumber:num]];
}

-(NSDictionary *) levelWithNumber:(int)num fromPack:(NSString *)packName
{
    NSString *previousPack = currentPack;
    [self setPack:packName];
    NSDictionary *level = [self levelWithNumber:num];
    [self setPack:previousPack];
    return level;
}

-(NSDictionary *) levelWithName:(NSString *)name
{
    NSString *extension = @"plist";
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

-(NSDictionary *) levelWithName:(NSString *)name fromPack:(NSString *)packName
{
    NSString *previousPack = currentPack;
    [self setPack:packName];
    NSDictionary *level = [self levelWithName:name];
    [self setPack:previousPack];
    return level;
}

@end
