//
//  GKTurnBasedMatchmakerViewController-LandscapeOnly.m
//  shift
//
//  Created by Alex Chesebro on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GKTurnBasedMatchmakerViewController-LandscapeOnly.h"

@implementation GKTurnBasedMatchmakerViewController (LandscapeOnly)
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return (UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}
@end
