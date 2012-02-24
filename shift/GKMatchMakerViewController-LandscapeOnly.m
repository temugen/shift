//
//  GKMatchMakerViewController-LandscapeOnly.m
//  shift
//
//  Created by Alex Chesebro on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GKMatchMakerViewController-LandscapeOnly.h"

@implementation GKMatchmakerViewController (LandscapeOnly)
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return (UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}
@end
