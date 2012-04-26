//
//  OhShiftMatchData.m
//  shift
//
//  Created by Alex Chesebro on 4/23/12.
//  Copyright (c) 2012 __Oh_Shift!__. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "OhShiftMatchData.h"

@interface OhShiftMatchData()

-(id) initWithDictionary:(NSDictionary*)dict;

@end


@implementation OhShiftMatchData

@synthesize p1id;
@synthesize p2id;
@synthesize p1moves;
@synthesize p2moves;
@synthesize p1time;
@synthesize p2time;
@synthesize p1board;
@synthesize p2board;
@synthesize p1data;
@synthesize p2data;
@synthesize difficulty;


-(id) initWithPlayerID:(NSString*)pid difficulty:(NSString*)diff andBoard:(NSDictionary*)board
{
  if ((self = [super init]))
  {
    p1time = 0.0;
    p1moves = 0;
    p1board = board;
    p2time = 0.0;
    p2moves = 0;
    p2board = board;
    p1id = pid;
    p2id = @"";
    difficulty = diff;
    
    [self updatePlayerOneData];
    [self updatePlayerTwoData];  
  }
  return self;
}


-(id) initWithData:(NSData*)data
{
  NSDictionary* matchInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  return [self initWithDictionary:matchInfo];
}


-(id) initFromFile:(NSString*)filename andData:(NSData*)data
{
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* documentsDirectory = [paths objectAtIndex:0];
  NSString* matchPath = [documentsDirectory stringByAppendingPathComponent:filename];
  NSDictionary* matchInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:matchPath];
  OhShiftMatchData* oldData = [[OhShiftMatchData alloc] initWithData:data];
  
  [oldData updatePlayerTwoWithBoard:[matchInfo objectForKey:@"board"]
                                pid:[matchInfo objectForKey:@"id"] 
                              moves:[[matchInfo objectForKey:@"moves"] intValue] 
                       andTimeTaken:[[matchInfo objectForKey:@"time"] doubleValue]];
   return oldData;
}


-(id) initWithDictionary:(NSDictionary*)dict
{
  if ((self = [super init]))
  {
    p1time = [[[dict objectForKey:@"player1"] objectForKey:@"time"] doubleValue];
    p1moves = [[[dict objectForKey:@"player1"] objectForKey:@"moves"] intValue];
    p1board = [[dict objectForKey:@"player1"] objectForKey:@"board"];
    p2time = [[[dict objectForKey:@"player2"] objectForKey:@"time"] doubleValue];
    p2moves = [[[dict objectForKey:@"player2"] objectForKey:@"moves"] intValue];
    p2board = [[dict objectForKey:@"player2"] objectForKey:@"board"];
    p1id = [[dict objectForKey:@"player1"] objectForKey:@"id"];
    p2id = [[dict objectForKey:@"player2"] objectForKey:@"id"];
    difficulty = [dict objectForKey:@"difficulty"];
    
    [self updatePlayerOneData];
    [self updatePlayerTwoData];  
  }
  return self;  
}


-(void) updatePlayerOneWithBoard:(NSDictionary*)board pid:(NSString*)pid moves:(int)moves andTimeTaken:(double)time
{
  p1time = time;
  p1moves = moves;
  p1board = board;
  p1id = pid;
  
  [self updatePlayerOneData];
}


-(void) updatePlayerTwoWithBoard:(NSDictionary*)board pid:(NSString*)pid moves:(int)moves andTimeTaken:(double)time
{
  p2time = time;
  p2moves = moves;
  p2board = board;
  p2id = pid;
  
  [self updatePlayerTwoData];
}


-(void) updatePlayerOneData
{
  p1data = [NSDictionary dictionaryWithObjectsAndKeys:
            p1id, @"id",
            [NSNumber numberWithInt:p1moves], @"moves",
            [NSNumber numberWithDouble:p1time], @"time",
            p1board, @"board",
            nil];  
}


-(void) updatePlayerTwoData
{
  p2data = [NSDictionary dictionaryWithObjectsAndKeys:
            p2id, @"id",
            [NSNumber numberWithInt:p2moves], @"moves",
            [NSNumber numberWithDouble:p2time], @"time",
            p2board, @"board",
            nil];  
}


-(NSData*) getDataForGameCenter
{
  NSDictionary* matchInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                             p1data, @"player1",
                             p2data, @"player2",
                             difficulty, @"difficulty",
                             nil];
  return [NSKeyedArchiver archivedDataWithRootObject:matchInfo];
}


-(void) writeToFile:(NSString*)filename
{
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* documentsDirectory = [paths objectAtIndex:0];
  NSString* matchPath = [documentsDirectory stringByAppendingPathComponent:filename];  
  [NSKeyedArchiver archiveRootObject:[self getDataForGameCenter] toFile:matchPath];
}


@end
