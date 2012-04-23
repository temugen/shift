//
//  OhShiftMatchData.h
//  shift
//
//  Created by Alex Chesebro on 4/23/12.
//  Copyright (c) 2012 __Oh_Shift!__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OhShiftMatchData : NSObject
{
  int p1moves, p2moves;
  double p1time, p2time;
  NSDictionary* p1board;
  NSDictionary* p2board;
  NSDictionary* p1data;
  NSDictionary* p2data;
}

@property (assign, readonly) int p1moves, p2moves;
@property (assign, readonly) double p1time, p2time;
@property (strong) NSDictionary* p1board;
@property (strong) NSDictionary* p2board;
@property (strong) NSDictionary* p1data;
@property (strong) NSDictionary* p2data;

-(id) initWithMatch:(GKTurnBasedMatch*)match;
-(id) initFromFile:(NSString*)filename;
-(void) updatePlayerOneWithBoard:(NSDictionary*)board moves:(int)moves andTimeTaken:(double)time;
-(void) updatePlayerTwoWithBoard:(NSDictionary*)board moves:(int)moves andTimeTaken:(double)time;
-(NSData*) getDataForGameCenter;
-(void) writeToFile:(NSString*)filename;

@end
