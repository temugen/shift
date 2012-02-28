//
//  GKLeaderboardViewController-LandscapeOnly.m
//  shift
//
//  Created by Alex Chesebro on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GKLeaderboardViewController-LandscapeOnly.h"

@implementation GKLeaderboardViewController (LandscapeOnly)
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return (UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}
@end
