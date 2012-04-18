//
//  SoundPlayer.m
//  shift
//
//  Created by Alex Chesebro on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundPlayer.h"

@implementation SoundPlayer

static SoundPlayer* instance = nil;

+(SoundPlayer*) sharedInstance
{
  if (instance == nil)
  {
    instance = [[SoundPlayer alloc] init];
  }
  return instance;
}

-(id) init
{
  NSAssert(instance == nil, @"Tried to create a second instance of sound player");
  if( (self = [super init]) ) 
  {
  }
  return self;
}


@end
