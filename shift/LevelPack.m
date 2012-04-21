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
}

-(NSString *) levelNameWithNumber:(int)num
{
    return [levels objectAtIndex:num];
}

-(NSDictionary *) levelWithNumber:(int)num
{
    return [self levelWithName:[self levelNameWithNumber:num]];
}

-(NSDictionary *) levelWithName:(NSString *)name
{
    return [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@.plist", name]];
}

@end
