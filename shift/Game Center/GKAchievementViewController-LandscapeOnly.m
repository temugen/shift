//
//  GKAchievementViewController-LandscapeOnly.m
//  shift
//
//  Created by Alex Chesebro on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GKAchievementViewController-LandscapeOnly.h"

@implementation GKAchievementViewController (LandscapeOnly)
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return (UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}
@end
