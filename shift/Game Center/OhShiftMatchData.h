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
  NSString* p1id, *p1alias;
  NSString* p2id, *p2alias;
  NSDictionary* p1board;
  NSDictionary* p2board;
  NSDictionary* p1data;
  NSDictionary* p2data;
  NSString* difficulty;
}

@property (assign, readonly) int p1moves, p2moves;
@property (assign, readonly) double p1time, p2time;
@property (strong) NSDictionary* p1board;
@property (strong) NSDictionary* p2board;
@property (strong) NSDictionary* p1data;
@property (strong) NSDictionary* p2data;
@property (strong) NSString* p1id, *p1alias;
@property (strong) NSString* p2id, *p2alias;
@property (strong) NSString* difficulty;

-(id) initWithPlayerID:(NSString*)pid difficulty:(NSString*)diff andBoard:(NSDictionary*)board;
-(id) initWithData:(NSData*)data;
-(id) initFromFile:(NSString*)filename andData:(NSData*)data;
-(void) updatePlayerOneWithBoard:(NSDictionary*)board pid:(NSString*)pid moves:(int)moves andTimeTaken:(double)time;
-(void) updatePlayerTwoWithBoard:(NSDictionary*)board pid:(NSString*)pid moves:(int)moves andTimeTaken:(double)time;
-(NSData*) getDataForGameCenter;
-(void) writeToFile:(NSString*)filename;

@end
