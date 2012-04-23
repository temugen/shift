//
//  OhShiftMatchData.m
//  shift
//
//  Created by Alex Chesebro on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "OhShiftMatchData.h"

@interface OhShiftMatchData()

-(id) initWithDictionary:(NSDictionary*)dict;

@end


@implementation OhShiftMatchData

@synthesize p1moves;
@synthesize p2moves;
@synthesize p1time;
@synthesize p2time;
@synthesize p1board;
@synthesize p2board;
@synthesize p1data;
@synthesize p2data;


-(id) initWithMatch:(GKTurnBasedMatch*)match
{
  NSDictionary* matchInfo = [NSKeyedUnarchiver unarchiveObjectWithData:match.matchData];
  return [self initWithDictionary:matchInfo];
}


-(id) initFromFile:(NSString*)filename
{
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* documentsDirectory = [paths objectAtIndex:0];
  NSString* matchPath = [documentsDirectory stringByAppendingPathComponent:filename];
  NSDictionary* matchInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:matchPath];
  return [self initWithDictionary:matchInfo];
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
    
    [self updatePlayerOneData];
    [self updatePlayerTwoData];  
  }
  return self;  
}


-(void) updatePlayerOneWithBoard:(NSDictionary*)board moves:(int)moves andTimeTaken:(double)time
{
  p1time = time;
  p1moves = moves;
  p1board = board;
  
  [self updatePlayerOneData];
}


-(void) updatePlayerTwoWithBoard:(NSDictionary*)board moves:(int)moves andTimeTaken:(double)time
{
  p2time = time;
  p2moves = moves;
  p2board = board;
  
  [self updatePlayerTwoData];
}


-(void) updatePlayerOneData
{
  p1data = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:p1moves], @"moves",
            [NSNumber numberWithDouble:p1time], @"time",
            p1board, @"board",
            nil];  
}


-(void) updatePlayerTwoData
{
  p2data = [NSDictionary dictionaryWithObjectsAndKeys:
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
                             nil];
  return [NSKeyedArchiver archivedDataWithRootObject:matchInfo];
}


-(void) writeToFile:(NSString*)filename
{
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* documentsDirectory = [paths objectAtIndex:0];
  NSString* matchPath = [documentsDirectory stringByAppendingPathComponent:filename];
  
  NSDictionary* matchInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                             p1data, @"player1",
                             p2data, @"player2",
                             nil];  
  
  [NSKeyedArchiver archiveRootObject:matchInfo toFile:matchPath];
}


@end
