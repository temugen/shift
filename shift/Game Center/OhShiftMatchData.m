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

@synthesize p1id, p1alias;
@synthesize p2id, p2alias;
@synthesize p1moves;
@synthesize p2moves;
@synthesize p1time;
@synthesize p2time;
@synthesize p1board;
@synthesize p2board;
@synthesize p1data;
@synthesize p2data;
@synthesize difficulty;


-(id) initWithPlayerID:(NSString*)pid alias:(NSString*)alias difficulty:(NSString*)diff andBoard:(NSDictionary*)board
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
    p1alias = alias;
    p2id = @"";
    p2alias = @"";
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
                              alias:[matchInfo objectForKey:@"alias"]
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
    p1alias = [[dict objectForKey:@"player1"] objectForKey:@"alias"];
    p2id = [[dict objectForKey:@"player2"] objectForKey:@"id"];
    p2alias = [[dict objectForKey:@"player2"] objectForKey:@"alias"];
    difficulty = [dict objectForKey:@"difficulty"];
    
    [self updatePlayerOneData];
    [self updatePlayerTwoData];  
  }
  return self;  
}

-(void) updatePlayerOneWithBoard:(NSDictionary*)board pid:(NSString*)pid alias:(NSString*)alias moves:(int)moves andTimeTaken:(double)time
{
  p1time = time;
  p1moves = moves;
  p1board = board;
  p1id = pid;
  p1alias = alias;
  
  [self updatePlayerOneData];
}


-(void) updatePlayerTwoWithBoard:(NSDictionary*)board pid:(NSString*)pid alias:(NSString*)alias moves:(int)moves andTimeTaken:(double)time
{
  p2time = time;
  p2moves = moves;
  p2board = board;
  p2id = pid;
  p2alias = alias;
  
  [self updatePlayerTwoData];
}


-(void) updatePlayerOneData
{
  p1data = [NSDictionary dictionaryWithObjectsAndKeys:
            p1id, @"id",
            p1alias, @"alias",
            [NSNumber numberWithInt:p1moves], @"moves",
            [NSNumber numberWithDouble:p1time], @"time",
            p1board, @"board",
            nil]; 
}


-(void) updatePlayerTwoData
{
  p2data = [NSDictionary dictionaryWithObjectsAndKeys:
            p2id, @"id",
            p2alias, @"alias",
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
